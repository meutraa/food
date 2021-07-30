import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:food/preferences.dart';

import 'data/portion.dart';
import 'date.dart';
import 'item_stat.dart';
import 'objectbox.g.dart';
import 'streamed.dart';

// ignore_for_file: cascade_invocations

class Stats {
  double consumedEnergy;
  double consumedFats;
  double consumedProtein;
  double consumedCarbs;

  Stats({
    this.consumedEnergy = 0,
    this.consumedFats = 0,
    this.consumedProtein = 0,
    this.consumedCarbs = 0,
  });
}

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
  final String label;
  final Color color;

  const StatData({
    required this.label,
    required this.value,
    required this.target,
    required this.format,
    required this.color,
  });
}

class _StatisticsPageState extends State<StatisticsPage> {
  late final DateTime startTime;

  late final double totalGramsProtein;
  late final double totalEnergyProtein;

  late final double totalEnergyFat;
  late final double totalEnergyCarbs;
  late final double totalGramsFat;
  late final double totalGramsCarbs;

  late final List<StatData> stats;

  Future<Stats> updateStats(List<Portion> portions) async {
    final stats = Stats();
    for (final p in portions) {
      final mash = p.on(
        ingredient: (e) => e.mash(p.mass),
        recipe: (e) => p.mash(),
      );
      stats.consumedEnergy += mash.energy;
      stats.consumedCarbs += mash.carbohydrates;
      stats.consumedFats += mash.fats;
      stats.consumedProtein += mash.protein;
    }
    return stats;
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    startTime = DateTime(
      now.year,
      now.month,
      now.day - (now.hour >= 5 ? 0 : 1),
      5,
    );

    final bodyWeight = Preferences.mass.val;
    final totalEnergy = Preferences.energy.val;

// Protein based on weight
    totalGramsProtein = (bodyWeight * Preferences.proteinPercMult.val) / 100;
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
        target: totalEnergy.toDouble(),
        format: (d) => '${d.toStringAsFixed(0)} Kcal',
        color: Colors.deepPurpleAccent,
      ),
      StatData(
        label: 'Carbohydrates',
        value: (d) => d.consumedCarbs,
        target: totalGramsCarbs,
        format: (d) => '${d.toStringAsFixed(1)} g',
        color: Colors.pinkAccent,
      ),
      StatData(
        label: 'Fat',
        value: (d) => d.consumedFats,
        target: totalGramsFat,
        format: (d) => '${d.toStringAsFixed(1)} g',
        color: Colors.yellowAccent,
      ),
      StatData(
        label: 'Protein',
        value: (d) => d.consumedProtein,
        target: totalGramsProtein,
        format: (d) => '${d.toStringAsFixed(1)} g',
        color: Colors.orangeAccent,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Streamed<Portion>(
        store: widget.store,
        orderField: Portion_.id,
        condition: Portion_.time.greaterThan(startTime.millisecondsSinceEpoch),
        builder: (context, items) => FutureBuilder<Stats>(
          future: updateStats(items),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final d = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: IconButton(
                      onPressed: () {},
                      icon: NeumorphicIcon(
                        Icons.settings_rounded,
                        size: 32,
                        style: NeumorphicStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
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
                const SizedBox(height: 2),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 240,
                      width: 320,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: RadarChart(
                          RadarChartData(
                            getTitle: (i) {
                              switch (i) {
                                case 0:
                                  return 'Fats';
                                case 1:
                                  return 'Carbs';
                                default:
                                  return 'Protein';
                              }
                            },
                            tickCount: 6,
                            titlePositionPercentageOffset: 0.2,
                            titleTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                            ticksTextStyle:
                                const TextStyle(color: Colors.transparent),
                            dataSets: [
                              RadarDataSet(
                                borderColor: Colors.black,
                                borderWidth: 0.5,
                                entryRadius: 2,
                                fillColor: Colors.white.withOpacity(0.5),
                                dataEntries: [
                                  RadarEntry(value: totalEnergyFat),
                                  RadarEntry(value: totalEnergyCarbs),
                                  RadarEntry(value: totalEnergyProtein),
                                ],
                              ),
                              RadarDataSet(
                                borderColor: () {
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
                                }(),
                                borderWidth: 0.5,
                                entryRadius: 3,
                                fillColor: Colors.white.withOpacity(0.5),
                                dataEntries: [
                                  RadarEntry(value: d.consumedFats * 9),
                                  RadarEntry(value: d.consumedCarbs * 4),
                                  RadarEntry(value: d.consumedProtein * 4),
                                ],
                              ),
                            ],
                            tickBorderData: BorderSide(
                              color: Colors.white.withOpacity(0.25),
                              width: 0.5,
                            ),
                            borderData: FlBorderData(show: false),
                            gridBorderData: BorderSide(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            radarBorderData: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ...stats
                    .map(
                      (s) => [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                s.label,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                s.format(s.target),
                                style: const TextStyle(fontSize: 11),
                              )
                            ],
                          ),
                        ),
                        StatItem(
                          value: s.value(d),
                          target: s.target,
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
