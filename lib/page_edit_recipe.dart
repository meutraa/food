import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:string_similarity/string_similarity.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'data/recipe.dart';
import 'modal_confirm.dart';
import 'neumorphic_text_field.dart';
import 'objectbox.g.dart';
import 'style.dart';
import 'util/validate.dart';

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
    ingredients = widget.store
        .box<Ingredient>()
        .query(Ingredient_.hidden.isNull().or(Ingredient_.hidden.notEquals(1)))
        .build()
        .find();

    name = TextEditingController(text: widget.recipe?.name);
    mass = TextEditingController(text: widget.recipe?.mass.toInt().toString());

    _portions.addAll(widget.recipe?.portions.map(
          (e) => PortionState(e)..mass.text = e.mass.toInt().toString(),
        ) ??
        []);

    if (_portions.isEmpty) {
      _portions.add(PortionState(Portion(mass: 0)));
    }
  }

  @override
  void dispose() {
    name.dispose();
    mass.dispose();
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

    if (widget.recipe != null) {
      final pids = widget.recipe!.portions.map((e) => e.id);
      final npids = portions.map((e) => e.id);
      final remove = pids.where((e) => !npids.contains(e));

      widget.recipe!.portions.removeWhere(
        (i) => remove.contains(i.id),
      );
      widget.store.box<Recipe>().put(widget.recipe!);
    }

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
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(
                  bottom: 96,
                  top: 84,
                  left: 24,
                  right: 24,
                ),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 17,
                        child: NeumorphicTextField(
                          child: TextFormField(
                            controller: name,
                            autofocus: widget.recipe == null,
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
                              hintText: 'Tofu Curry',
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 16),
                          child: NeumorphicTextField(
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
                                  optionsViewBuilder:
                                      (context, onSelected, options) => Align(
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
                                            final Ingredient option =
                                                options.elementAt(index);
                                            return GestureDetector(
                                              onTap: () => onSelected(option),
                                              child: Neumorphic(
                                                style: const NeumorphicStyle(
                                                  color: Colors.white,
                                                  depth: 4,
                                                  shadowLightColor:
                                                      Colors.white54,
                                                  shadowDarkColor:
                                                      Colors.black87,
                                                ),
                                                child: ListTile(
                                                  dense: true,
                                                  title: Text(
                                                    option.name,
                                                    style: const TextStyle(
                                                      color: Colors.lightBlue,
                                                    ),
                                                  ),
                                                  subtitle:
                                                      option.description == null
                                                          ? null
                                                          : Text(
                                                              option.description ??
                                                                  '',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .lightBlue,
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
                                      return const Iterable<Ingredient>.empty();
                                    }
                                    final t = v.text.toLowerCase();
                                    (ingredients ?? []).sort(
                                      (a, b) =>
                                          StringSimilarity.compareTwoStrings(
                                                  b.name.toLowerCase(), t)
                                              .compareTo(
                                        StringSimilarity.compareTwoStrings(
                                          a.name.toLowerCase(),
                                          t,
                                        ),
                                      ),
                                    );
                                    return ingredients?.take(5) ?? [];
                                  },
                                  fieldViewBuilder: (context,
                                          textEditingController,
                                          focusNode,
                                          onFieldSubmitted) =>
                                      NeumorphicTextField(
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        labelText: 'Ingredient',
                                        hintText: 'Lemon',
                                      ),
                                      controller: textEditingController
                                        ..text =
                                            e.portion.ingredient.target?.name ??
                                                '',
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                      focusNode: focusNode,
                                    ),
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
                                child: NeumorphicTextField(
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
                              ),
                              IconButton(
                                onPressed: () => setState(
                                  () => _portions.remove(e),
                                ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NeumorphicButton(
                        onPressed: () => showConfirmDialog(
                          context,
                          title: 'Discard Changes?',
                          onConfirmed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.pop(context);
                          },
                        ),
                        minDistance: -2,
                        style: textButtonStyle,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      NeumorphicButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.of(context).pop();
                            saveValue();
                          }
                        },
                        minDistance: -2,
                        style: textButtonStyle,
                        child: Row(
                          children: const [
                            Icon(
                              Icons.save_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
