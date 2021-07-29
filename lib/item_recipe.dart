import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food/data/recipe.dart';
import 'package:food/page_edit_recipe.dart';

import 'item_ingredient.dart';
import 'objectbox.g.dart';

class RecipeItem extends StatelessWidget {
  final Recipe recipe;
  final Store store;

  const RecipeItem({
    required this.recipe,
    required this.store,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ExpansionTile(
        title: Text(
          recipe.name,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /*SizedBox(
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
                              value: recipe.fats / recipe.mass * 100,
                            ),
                            RadarEntry(
                              value: recipe.carbohydrates / recipe.mass * 100,
                            ),
                            RadarEntry(
                              value: recipe.protein / recipe.mass * 100,
                            ),
                            RadarEntry(
                              value: recipe.energy / recipe.mass * 6,
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
              ),*/
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 32,
                  ),
                  child: Table(
                    children: recipe.portions
                        .map(
                          (e) => TableRow(children: [
                            Text((e.ingredient.hasValue
                                    ? e.ingredient.target?.name
                                    : e.recipe.target?.name) ??
                                ''),
                            Text(nf(e.mass) + ' g')
                          ]),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditRecipePage(
                          store: store,
                          recipe: recipe,
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
