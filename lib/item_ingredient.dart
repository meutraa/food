import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food/data/ingredient.dart';
import 'package:food/page_edit_ingredient.dart';

import 'objectbox.g.dart';

String nf(double? val) => val?.toString() ?? '?';

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
            Text(
              ingredient.name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              nf(ingredient.mass) + ' g',
              style: const TextStyle(
                fontSize: 14,
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
                      ticksTextStyle: TextStyle(color: Colors.transparent),
                      dataSets: [
                        RadarDataSet(
                          borderColor: Colors.yellowAccent,
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
                          color: Colors.white.withOpacity(0.25), width: 0.5),
                      borderData: FlBorderData(show: false),
                      gridBorderData:
                          BorderSide(color: Colors.white.withOpacity(0.5)),
                      radarBorderData: BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 8,
                  ),
                  child: Table(
                    children: [
                      TableRow(children: [
                        Text('Energy'),
                        Text(nf(ingredient.energy) + ' Kcal')
                      ]),
                      TableRow(children: [
                        Text('Carbohydrates'),
                        Text(nf(ingredient.carbohydrates) + ' g')
                      ]),
                      TableRow(children: [
                        Text('  Sugars'),
                        Text(nf(ingredient.sugar) + ' g')
                      ]),
                      TableRow(children: [
                        Text('  Fibre'),
                        Text(nf(ingredient.fibre) + ' g')
                      ]),
                      TableRow(children: [
                        Text('Fat'),
                        Text(ingredient.fats.toString() + ' g')
                      ]),
                      TableRow(children: [
                        Text('  Trans'),
                        Text(nf(ingredient.trans) + ' g')
                      ]),
                      TableRow(children: [
                        Text('  Saturated'),
                        Text(nf(ingredient.saturated) + ' g')
                      ]),
                      TableRow(children: [
                        Text('  Monounsaturated'),
                        Text(nf(ingredient.mono) + ' g')
                      ]),
                      TableRow(children: [
                        Text('  Polyunsaturated'),
                        Text(nf(ingredient.poly) + ' g')
                      ]),
                      TableRow(children: [
                        Text('Protein'),
                        Text(nf(ingredient.protein) + ' g')
                      ]),
                      TableRow(children: [
                        Text('Salt'),
                        Text(nf(ingredient.salt) + ' g')
                      ]),
                    ],
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditIngredientPage(
                          store: store,
                          ingredient: ingredient,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
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
