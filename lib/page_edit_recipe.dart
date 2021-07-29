import 'package:flutter/material.dart';
import 'package:food/page_edit_ingredient.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'data/recipe.dart';
import 'objectbox.g.dart';

class EditRecipePage extends StatefulWidget {
  final Recipe? recipe;
  final Store store;

  const EditRecipePage({
    Key? key,
    required this.store,
    this.recipe,
  }) : super(key: key);

  @override
  _EditRecipePageState createState() => _EditRecipePageState();
}

class PortionState {
  final mass = TextEditingController();
  final Portion portion;

  PortionState(this.portion);
}

class _EditRecipePageState extends State<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController name;
  late final TextEditingController mass;

  final _portions = <PortionState>[];

  List<Ingredient>? ingredients;

  void initState() {
    super.initState();

    // Load the ingredients from the database
    ingredients = widget.store.box<Ingredient>().getAll();

    name = TextEditingController(text: widget.recipe?.name);
    mass = TextEditingController(text: widget.recipe?.mass.toString());

    // TODO: load in all the existing portions
    _portions.addAll(widget.recipe?.portions.map(
          (e) => PortionState(e)..mass.text = e.mass.toString(),
        ) ??
        []);
  }

  void dispose() {
    name.dispose();
    super.dispose();
  }

  Future<void> saveValue() async {
    // Save all the portions
    final portions = _portions.map((e) {
      final p = Portion(
        id: e.portion.id,
        mass: double.tryParse(e.mass.text) ?? 0,
      );
      // Ingredient already exists in database
      p.ingredient.target = e.portion.ingredient.target;
      return p;
    }).toList(growable: false);

    widget.store.box<Portion>().putMany(portions);

    final item = Recipe(
      id: widget.recipe?.id ?? 0,
      name: name.text,
      mass: double.tryParse(mass.text) ?? 0,
    );

    item.portions.addAll(portions);

    widget.store.box<Recipe>().put(item);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.lightBlue,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: VerticalDivider(
                    color: Colors.white,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final valid = _formKey.currentState?.validate();
                    if (valid == true) {
                      await saveValue();
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(
                    Icons.save_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 5,
                    child: TextFormField(
                      controller: name,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 16),
                      child: TextFormField(
                        controller: mass,
                        validator: requiredNumber,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          labelText: 'Per',
                          hintText: '100',
                          suffixText: 'g',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Ingredients',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 16),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(8),
                  1: FlexColumnWidth(5),
                  2: FlexColumnWidth(3),
                },
                children: _portions
                    .map(
                      (e) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Autocomplete<Ingredient>(
                              displayStringForOption: (v) => v.name,
                              optionsBuilder: (v) {
                                if (v.text == '') {
                                  return const Iterable<Ingredient>.empty();
                                }
                                final t = v.text.toLowerCase();
                                return (ingredients ?? [])
                                    .where(
                                      (b) => b.name.toLowerCase().contains(t),
                                    )
                                    .toList(growable: false);
                              },
                              fieldViewBuilder: (context, textEditingController,
                                      focusNode, onFieldSubmitted) =>
                                  TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: textEditingController
                                  ..text =
                                      e.portion.ingredient.target?.name ?? '',
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                                focusNode: focusNode,
                              ),
                              onSelected: (v) {
                                final idx = _portions.indexOf(e);
                                e.portion.ingredient.target = v;
                                _portions[idx] = e;
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 16),
                            child: TextFormField(
                              controller: e.mass,
                              validator: requiredNumber,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.numberWithOptions(),
                              decoration: InputDecoration(
                                labelText: 'Mass',
                                hintText: '50',
                                suffixText: 'g',
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                setState(() => _portions.remove(e)),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(growable: false),
              ),
              TextButton.icon(
                onPressed: () => setState(() {
                  _portions.add(PortionState(Portion(mass: 0)));
                }),
                icon: Icon(
                  Icons.add_outlined,
                  color: Colors.white,
                ),
                label: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 8,
                  ),
                  child: Text(
                    'Add Ingredient',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
