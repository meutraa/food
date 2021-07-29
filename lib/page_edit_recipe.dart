import 'package:flutter/material.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'data/recipe.dart';
import 'modal_confirm.dart';
import 'objectbox.g.dart';
import 'page_edit_ingredient.dart';

class EditRecipePage extends StatefulWidget {
  final Recipe? recipe;
  final Store store;

  const EditRecipePage({
    required this.store,
    this.recipe,
    Key? key,
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

  @override
  void initState() {
    super.initState();

    // Load the ingredients from the database
    ingredients = widget.store.box<Ingredient>().getAll();

    name = TextEditingController(text: widget.recipe?.name);
    mass = TextEditingController(text: widget.recipe?.mass.toString());

    _portions.addAll(widget.recipe?.portions.map(
          (e) => PortionState(e)..mass.text = e.mass.toString(),
        ) ??
        []);
  }

  @override
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
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () => showConfirmDialog(
                    context,
                    title: 'Discard Changes?',
                    onConfirmed: () => Navigator.pop(context),
                  ),
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 36,
                  child: VerticalDivider(
                    color: Colors.white,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final valid = _formKey.currentState?.validate();
                    if (valid ?? false) {
                      await saveValue();
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(
                    Icons.save_outlined,
                    color: Colors.white,
                  ),
                  label: const Text(
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
                      decoration: const InputDecoration(
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
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
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
              const Text(
                'Ingredients',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 16),
              Table(
                columnWidths: const {
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
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Mass',
                                hintText: '50',
                                suffixText: 'g',
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                setState(() => _portions.remove(e)),
                            icon: const Icon(
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
                icon: const Icon(
                  Icons.add_outlined,
                  color: Colors.white,
                ),
                label: const Padding(
                  padding: EdgeInsets.symmetric(
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
