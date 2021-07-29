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
                fontWeight: FontWeight.w300,
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
          Padding(
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

                    // Create a copy of all these portions
                    c.portions.addAll(recipe.portions.map((e) => e..id = 0));
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
