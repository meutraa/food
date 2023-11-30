import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:string_similarity/string_similarity.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'data/recipe.dart';
import 'objectbox.g.dart';
import 'util/validate.dart';

const _style = NeumorphicStyle(
  depth: 8,
  border: NeumorphicBorder(
    color: Color(0x88ffffff),
    width: 0.5,
  ),
  shadowLightColor: Colors.white70,
  shadowDarkColor: Colors.black87,
  color: Colors.white,
);

Future<void> showIntakeDialog(
  BuildContext context, {
  required Store store,
  bool hideIngredient = false,
  Portion? initialPortion,
}) async {
  final recipes = store.box<Recipe>().getAll().map(
        (e) => Portion(mass: 0)..recipe.target = e,
      );
  final ingredients = store
      .box<Ingredient>()
      .query(Ingredient_.hidden.isNull().or(Ingredient_.hidden.notEquals(1)))
      .build()
      .find()
      .map(
        (e) => Portion(mass: 0)..ingredient.target = e,
      );
  final portions = recipes.toList()..addAll(ingredients);

  Portion? portion = initialPortion;
  final massController = TextEditingController(
    text: initialPortion?.mass.toInt().toString(),
  );
  final formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    barrierColor: Colors.lightBlue.shade800.withOpacity(0.8),
    builder: (context) => Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 120,
                  child: Neumorphic(
                    style: _style,
                    child: TextFormField(
                      controller: massController,
                      autofocus: true,
                      validator: requiredNumber,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      enableInteractiveSelection: false,
                      cursorColor: Colors.lightBlue,
                      style: const TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Mass',
                        hintText: '50',
                        suffixText: 'g',
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(0.5)),
                        suffixStyle: const TextStyle(color: Colors.lightBlue),
                        labelStyle: const TextStyle(color: Colors.lightBlue),
                      ),
                    ),
                  ),
                ),
                NeumorphicButton(
                  style: const NeumorphicStyle(
                    depth: 8,
                    border: NeumorphicBorder(
                      color: Color(0x88ffffff),
                      width: 0.5,
                    ),
                    // boxShape: NeumorphicBoxShape.circle(),
                    shadowLightColor: Colors.white70,
                    shadowDarkColor: Colors.black87,
                  ),
                  onPressed: () async {
                    final valid = formKey.currentState?.validate();
                    if (valid == false) {
                      return;
                    }
                    if (portion == null) {
                      return;
                    }

                    final p = Portion(
                      id: portion?.id ?? 0,
                      mass: double.tryParse(massController.text) ?? 0,
                      time: portion?.time ?? DateTime.now(),
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
                  child: const Icon(Icons.check, size: 32),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (!hideIngredient)
              Autocomplete<Portion>(
                displayStringForOption: (v) => v.name,
                optionsViewBuilder: (context, onSelected, options) => Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: 300,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        shrinkWrap: true,
                        separatorBuilder: (context, i) =>
                            const SizedBox(height: 8),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final Portion option = options.elementAt(index);
                          return GestureDetector(
                            onTap: () => onSelected(option),
                            child: Neumorphic(
                              style: const NeumorphicStyle(
                                color: Colors.white,
                                depth: 4,
                                shadowLightColor: Colors.white54,
                                shadowDarkColor: Colors.black87,
                              ),
                              child: ListTile(
                                dense: true,
                                title: Text(
                                  option.name,
                                  style: const TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: option
                                            .ingredient.target?.description ==
                                        null
                                    ? null
                                    : Text(
                                        option.ingredient.target?.description ??
                                            '',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 10,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                optionsBuilder: (v) {
                  if (v.text == '') {
                    return const Iterable<Portion>.empty();
                  }
                  final t = v.text.toLowerCase();

                  portions.sort(
                    (a, b) => StringSimilarity.compareTwoStrings(
                            b.name.toLowerCase(), t)
                        .compareTo(
                      StringSimilarity.compareTwoStrings(
                        a.name.toLowerCase(),
                        t,
                      ),
                    ),
                  );
                  return portions.take(5);
                },
                fieldViewBuilder: (context, textEditingController, focusNode,
                        onFieldSubmitted) =>
                    Neumorphic(
                  style: _style,
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    enableInteractiveSelection: false,
                    cursorColor: Colors.lightBlue,
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Recipe/Ingredient',
                      hintText: 'Hummous',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                      suffixStyle: const TextStyle(color: Colors.lightBlue),
                      labelStyle: const TextStyle(color: Colors.lightBlue),
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
          ],
        ),
      ),
    ),
  );
}
