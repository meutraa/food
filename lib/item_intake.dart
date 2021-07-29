import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'item_ingredient.dart';
import 'objectbox.g.dart';

class PortionItem extends StatefulWidget {
  final Portion portion;
  final Store store;

  const PortionItem({
    required this.portion,
    required this.store,
    Key? key,
  }) : super(key: key);

  @override
  _PortionItemState createState() => _PortionItemState();
}

class _PortionItemState extends State<PortionItem> {
  // This ingredient is an ingredient, or a mashed together recipe
  late Ingredient intake;

  @override
  void initState() {
    super.initState();
    intake = Ingredient.mash(
      mass: widget.portion.mass,
      name: widget.portion.on(ingredient: (e) => e.name, recipe: (e) => e.name),
    );
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) async {
        final mash = widget.portion.on(
          ingredient: (e) => e.mash(widget.portion.mass),
          recipe: (e) => widget.portion.mash(),
        );
        setState(() {
          intake = mash;
          intake.mass = widget.portion.mass;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) => ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              intake.name,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Text(
              '${nf(intake.mass)} g',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 128,
                width: 128,
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
                      tickCount: 5,
                      titlePositionPercentageOffset: 0.35,
                      titleTextStyle: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 10,
                      ),
                      ticksTextStyle:
                          const TextStyle(color: Colors.transparent),
                      dataSets: [
                        RadarDataSet(
                          borderColor: () {
                            final m = max(
                              max(
                                intake.carbohydrates,
                                intake.protein,
                              ),
                              intake.fats,
                            );
                            if (m == intake.carbohydrates) {
                              return Colors.pinkAccent;
                            }
                            if (m == intake.fats) {
                              return Colors.yellowAccent;
                            }
                            if (m == intake.protein) {
                              return Colors.orangeAccent;
                            }
                          }(),
                          borderWidth: 0.5,
                          entryRadius: 3,
                          fillColor: Colors.white.withOpacity(0.5),
                          dataEntries: [
                            RadarEntry(
                              value: intake.fats / intake.mass * 100,
                            ),
                            RadarEntry(
                              value: intake.carbohydrates / intake.mass * 100,
                            ),
                            RadarEntry(
                              value: intake.protein / intake.mass * 100,
                            ),
                            RadarEntry(
                              value: intake.energy / intake.mass * 6,
                            ),
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
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 8,
                    end: 16,
                  ),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(8),
                      1: FlexColumnWidth(3),
                    },
                    children: tableRows
                        .map(
                          (e) => TableRow(
                            decoration: e.index.isOdd
                                ? BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                  )
                                : null,
                            children: [
                              Text(
                                e.name,
                              ),
                              Text(
                                '${nf(e.value(intake))} ${e.unit}',
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 8,
                ),
                child: TextButton.icon(
                  onPressed: () {
                    // Navigator.push<void>(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => EditPortionPage(
                    //       store: widget.store,
                    //       portion: widget.portion,
                    //     ),
                    //   ),
                    // );
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      );
}
