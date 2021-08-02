import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'data/recipe.dart';
import 'data/stats.dart';
import 'date.dart';
import 'item_stat.dart';
import 'objectbox.g.dart';
import 'page_preferences.dart';
import 'streamed.dart';
import 'util/calculations.dart';
import 'util/preferences.dart';

// ignore_for_file: cascade_invocations

class StatisticsPage extends StatefulWidget {
  final Store store;

  const StatisticsPage({
    required this.store,
    Key? key,
  }) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class StatData {
  final String Function(double) format;
  final double Function(Stats) value;
  final double target;
  final double Function(Stats) average;
  final String label;
  final Color color;

  const StatData({
    required this.label,
    required this.value,
    required this.target,
    required this.average,
    required this.format,
    required this.color,
  });
}

class _StatisticsPageState extends State<StatisticsPage>
    with AutomaticKeepAliveClientMixin {
  late DateTime startTime;
  late DateTime endTime;

  double totalGramsProtein = 0;
  double totalEnergyProtein = 0;

  double totalEnergyFat = 0;
  double totalEnergyCarbs = 0;
  double totalGramsFat = 0;
  double totalGramsCarbs = 0;
  double requiredEnergy = 0;

  List<StatData> stats = [];

  static Future<Stats> updateData(
    List<Portion> portions,
    DateTime start,
    DateTime end,
  ) async {
    final stats = Stats();
    for (final p in portions) {
      final mash = p.on(
        ingredient: (e) => e.mash(p.mass),
        recipe: (e) => p.mash(),
      );
      stats.totalEnergy += mash.energy;
      if (p.time!.isAfter(start) && p.time!.isBefore(end)) {
        stats.consumedEnergy += mash.energy;
        stats.consumedCarbs += mash.carbohydrates;
        stats.consumedFats += mash.fats;
        stats.consumedProtein += mash.protein;
      }
      stats.averageEnergy += mash.energy;
      stats.averageCarbs += mash.carbohydrates;
      stats.averageFats += mash.fats;
      stats.averageProtein += mash.protein;
    }
    if (portions.isNotEmpty) {
      stats.totalMinutes =
          DateTime.now().difference(portions.last.time!).inMinutes;
      stats.averageEnergy *= 1440 / stats.totalMinutes;
      stats.averageCarbs *= 1440 / stats.totalMinutes;
      stats.averageFats *= 1440 / stats.totalMinutes;
      debugPrint('totalprotein = ${stats.averageEnergy}');
      debugPrint('days = ${stats.totalMinutes / 1440}');
      stats.averageProtein *= 1440 / stats.totalMinutes;
      debugPrint('averageprotein = ${stats.averageEnergy}');
    }

    return stats;
  }

  @override
  void initState() {
    super.initState();
    setTimeLimits(DateTime.now());
    genStats();
  }

  void setTimeLimits(DateTime time) => setState(() {
        startTime = DateTime(
          time.year,
          time.month,
          time.day - (time.hour >= 5 ? 0 : 1),
          5,
        );
        endTime = startTime.add(const Duration(days: 1));
      });

  Color getMacroColor(Stats d) {
    final m = max(
      max(
        d.consumedCarbs,
        d.consumedProtein,
      ),
      d.consumedFats,
    );
    if (m == d.consumedCarbs) {
      return Colors.pinkAccent;
    }
    if (m == d.consumedFats) {
      return Colors.yellowAccent;
    }
    if (m == d.consumedProtein) {
      return Colors.orangeAccent;
    }
    return Colors.white;
  }

  void genStats() {
    final bodyWeight = Preferences.mass.val;
    requiredEnergy = bmr();
    final totalEnergy = (requiredEnergy * Preferences.calPerc.val) / 100;

    totalGramsProtein = (bodyWeight * Preferences.protein.val) / 100;
    totalEnergyProtein = totalGramsProtein * 4;

    final usableEnergy = totalEnergy - totalEnergyProtein;
    totalEnergyFat = (usableEnergy * Preferences.fatPerc.val) / 100;
    totalEnergyCarbs = usableEnergy - totalEnergyFat;
    totalGramsFat = totalEnergyFat / 9;
    totalGramsCarbs = totalEnergyCarbs / 4;

    stats = [
      StatData(
        label: 'Energy',
        value: (d) => d.consumedEnergy,
        average: (d) => d.averageEnergy,
        target: totalEnergy.toDouble(),
        format: (d) => '${d.toStringAsFixed(0)} kcal',
        color: Colors.deepPurpleAccent,
      ),
      StatData(
        label: 'Carbohydrates',
        value: (d) => d.consumedCarbs,
        average: (d) => d.averageCarbs,
        target: totalGramsCarbs,
        format: (d) => '${d.toStringAsFixed(1)} g',
        color: Colors.pinkAccent,
      ),
      StatData(
        label: 'Fat',
        value: (d) => d.consumedFats,
        average: (d) => d.averageFats,
        target: totalGramsFat,
        format: (d) => '${d.toStringAsFixed(1)} g',
        color: Colors.yellowAccent,
      ),
      StatData(
        label: 'Protein',
        value: (d) => d.consumedProtein,
        average: (d) => d.averageProtein,
        target: totalGramsProtein,
        format: (d) => '${d.toStringAsFixed(1)} g',
        color: Colors.orangeAccent,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Streamed<Portion>(
      store: widget.store,
      orderField: Portion_.time,
      condition: Portion_.time.notNull(),
      builder: (context, items) => FutureBuilder<Stats>(
        future: updateData(items, startTime, endTime),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final d = snapshot.data!;
          debugPrint(d.averageProtein.toString());
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 16),
                    child: IconButton(
                      onPressed: () async {
                        final data = await FlutterBarcodeScanner.scanBarcode(
                          '#ffffff',
                          'Cancel',
                          true,
                          ScanMode.QR,
                        );
                        if (data.isEmpty) {
                          return;
                        }
                        final json = jsonDecode(data) as List<dynamic>;
                        if (json.length > 2 && json[2] is double) {
                          // ingredient
                          final ing = Ingredient.fromJson(json);
                          widget.store.box<Ingredient>().put(ing);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.blueAccent,
                            content: Text(
                              'Added ${ing.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ));
                        } else if (json.isNotEmpty && json[0] is String) {
                          // recipe
                          final recipe = Recipe.fromJson(json);
                          debugPrint(recipe.name);
                          widget.store.box<Recipe>().put(recipe);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.blueAccent,
                            content: Text(
                              'Added ${recipe.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text(
                              'Invalid data',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ));
                        }
                      },
                      icon: NeumorphicIcon(
                        Icons.qr_code_rounded,
                        size: 32,
                        style: const NeumorphicStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: items.last.time!,
                        lastDate: DateTime.now(),
                        initialDate: startTime,
                        builder: (context, child) => Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Colors.blueAccent,
                              surface: Colors.blueAccent,
                            ),
                            buttonTheme: const ButtonThemeData(
                              textTheme: ButtonTextTheme.primary,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (date != null) {
                        setTimeLimits(date.add(const Duration(hours: 6)));
                      }
                    },
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            weekdays[startTime.weekday],
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'the',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            '${startTime.day}${daySuffix(startTime.day)} of '
                            '${months[startTime.month]}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 16),
                    child: IconButton(
                      onPressed: () => Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PreferencePage(),
                        ),
                      ).then((value) => setState(genStats)),
                      icon: NeumorphicIcon(
                        Icons.settings_rounded,
                        size: 32,
                        style: const NeumorphicStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  height: 220,
                  width: 280,
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.topCenter,
                        child: Text('Fats'),
                      ),
                      const Positioned(
                        right: 32,
                        bottom: 40,
                        child: Text('Carbs'),
                      ),
                      const Positioned(
                        left: 32,
                        bottom: 40,
                        child: Text('Protein'),
                      ),
                      RadarChart(
                        RadarChartData(
                          tickCount: 1,
                          ticksTextStyle:
                              const TextStyle(color: Colors.transparent),
                          dataSets: [
                            RadarDataSet(
                              borderColor: Colors.white.withOpacity(0.8),
                              borderWidth: 0.2,
                              entryRadius: 0,
                              fillColor: Colors.white.withOpacity(0.2),
                              dataEntries: [
                                RadarEntry(value: totalEnergyFat),
                                RadarEntry(value: totalEnergyCarbs),
                                RadarEntry(value: totalEnergyProtein),
                              ],
                            ),
                            RadarDataSet(
                              borderColor: getMacroColor(d),
                              borderWidth: 1,
                              entryRadius: 3,
                              fillColor: getMacroColor(d).withOpacity(0.5),
                              dataEntries: [
                                RadarEntry(value: d.consumedFats * 9),
                                RadarEntry(value: d.consumedCarbs * 4),
                                RadarEntry(value: d.consumedProtein * 4),
                              ],
                            ),
                          ],
                          tickBorderData: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderData: FlBorderData(show: false),
                          gridBorderData: const BorderSide(
                            color: Colors.transparent,
                          ),
                          radarBorderData: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${((((requiredEnergy * d.totalMinutes) / 1440) - d.totalEnergy) / -7716).toStringAsFixed(2)} kg',
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Today: ${((requiredEnergy - d.consumedEnergy) / -7716).toStringAsFixed(2)} kg',
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...stats
                  .map(
                    (s) => [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 8,
                        ),
                        child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(),
                            2: FlexColumnWidth(),
                          },
                          children: [
                            TableRow(children: [
                              Text(
                                s.label,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                '${(s.value(d) * 100 / s.target).toStringAsFixed(0)}%',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11),
                              ),
                              Text(
                                s.format(s.target),
                                textAlign: TextAlign.end,
                                style: const TextStyle(fontSize: 11),
                              )
                            ])
                          ],
                        ),
                      ),
                      StatItem(
                        value: s.value(d),
                        target: s.target,
                        average: s.average(d),
                        format: s.format,
                        color: s.color,
                      ),
                    ],
                  )
                  .expand((e) => e)
                  .toList(growable: false)
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
