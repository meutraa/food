import 'dart:convert';
import 'dart:math';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'data/recipe.dart';
import 'data/stats.dart';
import 'date.dart';
import 'graph.dart';
import 'item_stat.dart';
import 'objectbox.g.dart';
import 'page_preferences.dart';
import 'stats_painter.dart';
import 'streamed.dart';
import 'util/calculations.dart';
import 'util/preferences.dart';

// ignore_for_file: cascade_invocations

class StatisticsPage extends StatefulWidget {
  final Store store;

  const StatisticsPage({
    required this.store,
    super.key,
  });

  @override
  StatisticsPageState createState() => StatisticsPageState();
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

const mul = 1.3;

class StatisticsPageState extends State<StatisticsPage>
    with AutomaticKeepAliveClientMixin {
  late DateTime startTime;
  late DateTime delay;
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
        stats.consumedSugar += mash.sugar;
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
      final up = 1440 - (stats.totalMinutes % 1440);
      stats.totalMinutes += up;
      stats.averageEnergy *= 1440 / stats.totalMinutes;
      stats.averageCarbs *= 1440 / stats.totalMinutes;
      stats.averageFats *= 1440 / stats.totalMinutes;
      stats.averageProtein *= 1440 / stats.totalMinutes;
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
        delay = DateTime.now().add(const Duration(milliseconds: 200));
        startTime = DateTime(
          time.year,
          time.month,
          time.day - (time.hour >= 5 ? 0 : 1),
          5,
        );
        endTime = startTime.add(const Duration(days: 1));
      });

  Color getMacroColor(double c, double f, double p) {
    final ce = c * 4;
    final fe = f * 9;
    final pe = p * 4;
    final m = max(
        max(
          ce,
          pe,
        ),
        fe);
    if (m == ce) {
      return Colors.pinkAccent;
    } else if (m == fe) {
      return Colors.yellowAccent;
    } else {
      return Colors.orangeAccent;
    }
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
      condition: Portion_.time.notNull().and(
            Portion_.time
                .greaterThan(DateTime(2022, 09).millisecondsSinceEpoch),
          ),
      builder: (context, items) => FutureBuilder<Stats>(
        future: updateData(items, startTime, endTime),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final d = snapshot.data!;
          return Listener(
            onPointerMove: (ev) {
              if (DateTime.now().isBefore(delay)) {
                return;
              }
              final mag = ev.delta.dx;
              const sen = 0.5;
              if (mag < sen && mag > -sen) {
                return;
              }
              if (mag > 0 && endTime.isBefore(DateTime.now())) {
                setTimeLimits(startTime.add(const Duration(days: 1)));
              } else if (mag < 0 &&
                  items.isNotEmpty &&
                  startTime.isAfter(items.last.time!)) {
                setTimeLimits(startTime.subtract(const Duration(days: 1)));
              }
            },
            child: Column(
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.blueAccent,
                                content: Text(
                                  'Added ${ing.name}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          } else if (json.isNotEmpty && json[0] is String) {
                            // recipe
                            final recipe = Recipe.fromJson(json);
                            widget.store.box<Recipe>().put(recipe);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.blueAccent,
                                content: Text(
                                  'Added ${recipe.name}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.redAccent,
                                content: Text(
                                  'Invalid data',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
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
                        Center(
                          child: Stack(
                            children: [
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: CustomPaint(
                                  painter: CurvePainter(
                                    maxi: 100,
                                    fillColor: getMacroColor(
                                      d.averageCarbs,
                                      d.averageFats,
                                      d.averageProtein,
                                    ).withOpacity(0.15),
                                    drawDots: false,
                                    fats: mul * d.averageFats * 0.8,
                                    carbs: mul * d.averageCarbs * 0.4,
                                    proteins: mul * d.averageProtein * 0.4,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: CustomPaint(
                                  painter: CurvePainter(
                                    maxi: 100,
                                    width: 0.5,
                                    drawDots: false,
                                    fats: mul * d.averageFats * 0.8,
                                    carbs: mul * d.averageCarbs * 0.4,
                                    proteins: mul * d.averageProtein * 0.4,
                                  ),
                                ),
                              ),
                              // Actual
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: CustomPaint(
                                  painter: CurvePainter(
                                    maxi: 100,
                                    fillColor: getMacroColor(
                                      d.consumedCarbs,
                                      d.consumedFats,
                                      d.consumedProtein,
                                    ).withOpacity(0.4),
                                    drawDots: false,
                                    fats: mul * d.consumedFats * 0.8,
                                    carbs: mul * d.consumedCarbs * 0.4,
                                    proteins: mul * d.consumedProtein * 0.4,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: ColoredStats(
                                  maxi: 100,
                                  fats: mul * d.consumedFats * 0.8,
                                  carbs: mul * d.consumedCarbs * 0.4,
                                  proteins: mul * d.consumedProtein * 0.4,
                                ),
                              ),
                              // Target
                              SizedBox(
                                height: 200,
                                width: 200,
                                child: CustomPaint(
                                  painter: CurvePainter(
                                    maxi: 100,
                                    drawDots: false,
                                    fats: mul * totalGramsFat * 0.8,
                                    carbs: mul * totalGramsCarbs * 0.4,
                                    proteins: mul * totalGramsProtein * 0.4,
                                  ),
                                ),
                              ),
                            ],
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
                          mini: s.label == 'Carbohydrates'
                              ? d.consumedSugar
                              : null,
                          average: s.average(d),
                          format: s.format,
                          color: s.color,
                        ),
                      ],
                    )
                    .expand((e) => e)
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
