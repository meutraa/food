import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'data/recipe.dart';
import 'graph.dart';
import 'modal_confirm.dart';
import 'objectbox.g.dart';
import 'page_edit_recipe.dart';

class RecipeItem extends StatelessWidget {
  final Recipe recipe;
  final Store store;
  late final Ingredient mash;

  RecipeItem({
    required this.recipe,
    required this.store,
    super.key,
  }) : mash = recipe.mash();

  @override
  Widget build(BuildContext context) => ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              recipe.name,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              '${recipe.mass.toInt()} g',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        children: [
          Row(
            children: [
              SizedBox(
                height: 128,
                width: 128,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ColoredStats(
                    carbs: mash.carbohydrates,
                    proteins: mash.protein,
                    fats: mash.fats,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 32,
                  ),
                  child: Table(
                    children: recipe.portions
                        .map(
                          (e) => TableRow(
                            children: [
                              Text((e.ingredient.hasValue
                                      ? e.ingredient.target?.name
                                      : e.recipe.target?.name) ??
                                  ''),
                              Text('${e.mass.toInt()} g')
                            ],
                          ),
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
                    onConfirmed: () {
                      // Check if this recipe is used in any active portions
                      final refs = store
                          .box<Portion>()
                          .query(
                            Portion_.recipe
                                .equals(recipe.id)
                                .and(Portion_.time.notNull()),
                          )
                          .build()
                          .count();

                      if (refs == 0) {
                        store.box<Recipe>().remove(recipe.id);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Unable to delete ${recipe.name}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Used in ${refs.toString()} active portions',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
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
                    final data = jsonEncode(recipe.toJson());
                    showDialog<void>(
                      context: context,
                      barrierColor: null,
                      builder: (context) => Dialog(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: QrImageView(
                            data: data,
                            errorCorrectionLevel: QrErrorCorrectLevel.M,
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
                    );
                  },
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
          ),
        ],
      );
}
