import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'data/portion.dart';
import 'item_stat.dart';
import 'objectbox.g.dart';
import 'streamed.dart';

// ignore_for_file: cascade_invocations

const totalEnergy = 1400;
const totalGramsFat = totalEnergy * 0.65 / 9;
const totalGramsProtein = totalEnergy * 0.20 / 4;
const totalGramsCarbs = totalEnergy * 0.15 / 4;

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

class _StatisticsPageState extends State<StatisticsPage> {
  late DateTime startTime;

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
    final time = DateTime.now();
    startTime = time.subtract(Duration(
      hours: time.hour + 5,
      minutes: time.minute,
      seconds: time.second,
    ));
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
                Center(
                  child: Text(
                    formatDate(startTime, [DD, '\n', dd, ' ', MM]),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 280,
                      width: 280,
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
                                case 2:
                                  return 'Protein';
                                default:
                                  return 'Energy';
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
                                dataEntries: const [
                                  RadarEntry(value: totalGramsFat),
                                  RadarEntry(value: totalGramsCarbs),
                                  RadarEntry(value: totalGramsProtein),
                                  RadarEntry(value: totalEnergy / 6),
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
                                  RadarEntry(value: d.consumedFats),
                                  RadarEntry(value: d.consumedCarbs),
                                  RadarEntry(value: d.consumedProtein),
                                  RadarEntry(value: d.consumedEnergy / 6),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Energy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        '${totalEnergy.toStringAsFixed(0)} Kcal',
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      )
                    ],
                  ),
                ),
                StatItem(
                  value: d.consumedEnergy,
                  target: totalEnergy.toDouble(),
                  format: (d) => '${d.toStringAsFixed(0)} Kcal',
                  color: Colors.deepPurpleAccent,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Carbohydrates',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        '${totalGramsCarbs.toStringAsFixed(1)} g',
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      )
                    ],
                  ),
                ),
                StatItem(
                  value: d.consumedCarbs,
                  target: totalGramsCarbs,
                  format: (d) => '${d.toStringAsFixed(1)} g',
                  color: Colors.pinkAccent,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Fat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        '${totalGramsFat.toStringAsFixed(1)} g',
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      )
                    ],
                  ),
                ),
                StatItem(
                  value: d.consumedFats,
                  target: totalGramsFat,
                  format: (d) => '${d.toStringAsFixed(1)} g',
                  color: Colors.yellowAccent,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Protein',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        '${totalGramsProtein.toStringAsFixed(1)} g',
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      )
                    ],
                  ),
                ),
                StatItem(
                  value: d.consumedProtein,
                  target: totalGramsProtein,
                  format: (d) => '${d.toStringAsFixed(1)} g',
                  color: Colors.orangeAccent,
                ),
              ],
            );
          },
        ),
      );
}
