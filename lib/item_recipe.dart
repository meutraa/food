import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'data/recipe.dart';
import 'item_ingredient.dart';
import 'modal_confirm.dart';
import 'objectbox.g.dart';
import 'page_edit_recipe.dart';

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              recipe.name,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Text(
              '${nf(recipe.mass)} g',
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
                            Text('${nf(e.mass)} g')
                          ]),
                        )
                        .toList(growable: false),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () => showConfirmDialog(
                    context,
                    title: 'Delete ${recipe.name}?',
                    body: 'This action can not be reversed',
                    onConfirmed: () => store.box<Recipe>().remove(recipe.id),
                  ),
                  icon: const Icon(
                    Icons.delete_outlined,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    final c = Recipe(
                      mass: recipe.mass,
                      name: '${recipe.name} Clone',
                    );
                    c.portions.addAll(recipe.portions);
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditRecipePage(
                          store: store,
                          recipe: c,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.copy_outlined,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Clone',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditRecipePage(
                          store: store,
                          recipe: recipe,
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
              ],
            ),
          )
        ],
      );
}
