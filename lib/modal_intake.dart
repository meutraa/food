import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:objectbox/objectbox.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'data/recipe.dart';
import 'util/validate.dart';

Future<void> showIntakeDialog(
  BuildContext context, {
  required Store store,
  Portion? initialPortion,
}) async {
  final recipes = store.box<Recipe>().getAll().map(
        (e) => Portion(mass: 0)..recipe.target = e,
      );
  final ingredients = store.box<Ingredient>().getAll().map(
        (e) => Portion(mass: 0)..ingredient.target = e,
      );
  final portions = recipes.toList()..addAll(ingredients);

  Portion? portion = initialPortion;
  final _massController = TextEditingController(
    text: initialPortion?.mass.toStringAsFixed(1),
  );
  final _formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      content: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Autocomplete<Portion>(
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
                    Neumorphic(
                  style: const NeumorphicStyle(
                    depth: -4,
                    border: NeumorphicBorder(
                      color: Color(0x88ffffff),
                      width: 0.5,
                    ),
                    shadowLightColorEmboss: Colors.grey,
                    shadowDarkColorEmboss: Colors.black,
                    color: Colors.grey,
                  ),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    autofocus: initialPortion == null,
                    decoration: const InputDecoration(
                      labelText: 'Recipe/Ingredient',
                      hintText: 'Hummous',
                    ),
                    controller: textEditingController
                      ..text = initialPortion?.name ?? '',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    focusNode: focusNode,
                  ),
                ),
                onSelected: (v) => portion = v,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 128, top: 8),
                child: Neumorphic(
                  style: const NeumorphicStyle(
                    depth: -4,
                    border: NeumorphicBorder(
                      color: Color(0x88ffffff),
                      width: 0.5,
                    ),
                    shadowLightColorEmboss: Colors.grey,
                    shadowDarkColorEmboss: Colors.black,
                    color: Colors.grey,
                  ),
                  child: TextFormField(
                    controller: _massController,
                    autofocus: initialPortion != null,
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
