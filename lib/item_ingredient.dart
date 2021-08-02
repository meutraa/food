import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'data/ingredient.dart';
import 'objectbox.g.dart';
import 'page_edit_ingredient.dart';

String nf(double? val) => val?.toStringAsFixed(1) ?? '?';

class IngredientTableMapRow {
  final int index;
  final String name;
  final double? Function(Ingredient ing) value;
  final String unit;

  const IngredientTableMapRow(this.index, this.name, this.value, this.unit);
}

final tableRows = [
  IngredientTableMapRow(0, 'Energy', (e) => e.energy, 'kcal'),
  IngredientTableMapRow(1, 'Carbohydrates', (e) => e.carbohydrates, 'g'),
  IngredientTableMapRow(2, '  Sugar', (e) => e.sugar, 'g'),
  IngredientTableMapRow(3, '  Fibre', (e) => e.fibre, 'g'),
  IngredientTableMapRow(4, 'Fats', (e) => e.fats, 'g'),
  IngredientTableMapRow(5, '  Saturated', (e) => e.saturated, 'g'),
  IngredientTableMapRow(6, 'Protein', (e) => e.protein, 'g'),
  IngredientTableMapRow(7, 'Salt', (e) => e.salt, 'g'),
];

class IngredientItem extends StatelessWidget {
  final Ingredient ingredient;
  final Store store;

  const IngredientItem({
    required this.ingredient,
    required this.store,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                ingredient.name,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            Text(
              '${nf(ingredient.mass)} g',
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
                                ingredient.carbohydrates,
                                ingredient.protein,
                              ),
                              ingredient.fats,
                            );
                            if (m == ingredient.carbohydrates) {
                              return Colors.pinkAccent;
                            }
                            if (m == ingredient.fats) {
                              return Colors.yellowAccent;
                            }
                            if (m == ingredient.protein) {
                              return Colors.orangeAccent;
                            }
                          }(),
                          borderWidth: 0.5,
                          entryRadius: 3,
                          fillColor: Colors.white.withOpacity(0.5),
                          dataEntries: [
                            RadarEntry(
                              value: ingredient.fats / ingredient.mass * 100,
                            ),
                            RadarEntry(
                              value: ingredient.carbohydrates /
                                  ingredient.mass *
                                  100,
                            ),
                            RadarEntry(
                              value: ingredient.protein / ingredient.mass * 100,
                            ),
                            RadarEntry(
                              value: ingredient.energy / ingredient.mass * 6,
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
                                '${nf(e.value(ingredient))} ${e.unit}',
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
                  onPressed: () => showDialog<void>(
                    context: context,
                    barrierColor: null,
                    builder: (context) => Dialog(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: QrImage(
                        data: jsonEncode(ingredient.toJson()),
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.circle,
                          color: Colors.white,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Share',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 8,
                ),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditIngredientPage(
                          store: store,
                          ingredient: ingredient,
                        ),
                      ),
                    );
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
              ),
            ],
          )
        ],
      );
}
