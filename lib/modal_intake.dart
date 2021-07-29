import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'data/recipe.dart';
import 'page_edit_ingredient.dart';

Future<void> showIntakeDialog(
  BuildContext context, {
  required Store store,
}) async {
  final recipes = store.box<Recipe>().getAll().map(
        (e) => Portion(mass: 0)..recipe.target = e,
      );
  final ingredients = store.box<Ingredient>().getAll().map(
        (e) => Portion(mass: 0)..ingredient.target = e,
      );
  final portions = recipes.toList()..addAll(ingredients);

  Portion? portion;
  final _massController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Form(
          key: _formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 4,
                child: Autocomplete<Portion>(
                  displayStringForOption: (v) => v.name,
                  optionsBuilder: (v) {
                    if (v.text == '') {
                      return const Iterable<Portion>.empty();
                    }
                    final t = v.text.toLowerCase();
                    return portions
                        .where(
                          (b) => b.name.toLowerCase().contains(t),
                        )
                        .toList(growable: false);
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                          onFieldSubmitted) =>
                      TextFormField(
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Recipe/Ingredient',
                      hintText: 'Hummous',
                    ),
                    controller: textEditingController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    focusNode: focusNode,
                  ),
                  onSelected: (v) => portion = v,
                ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16),
                  child: TextFormField(
                    controller: _massController,
                    validator: requiredNumber,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Mass',
                      hintText: '50',
                      suffixText: 'g',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final valid = _formKey.currentState?.validate();
            if (valid == false) {
              return;
            }
            if (portion == null) {
              return;
            }

            final p = Portion(
              mass: double.tryParse(_massController.text) ?? 0,
              time: DateTime.now(),
            );
            if (portion?.ingredient.hasValue ?? false) {
              p.ingredient.target = portion!.ingredient.target;
            } else if (portion?.recipe.hasValue ?? false) {
              p.recipe.target = portion!.recipe.target;
            } else {
              return;
            }

            store.box<Portion>().put(p);
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}
