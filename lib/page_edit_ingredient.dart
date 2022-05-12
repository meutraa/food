import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'data/ingredient.dart';
import 'modal_confirm.dart';
import 'neumorphic_text_field.dart';
import 'objectbox.g.dart';
import 'style.dart';
import 'util/validate.dart';

class EditIngredientPage extends StatefulWidget {
  final Ingredient? ingredient;
  final Store store;

  const EditIngredientPage({
    required this.store,
    super.key,
    this.ingredient,
  });

  @override
  _EditIngredientPageState createState() => _EditIngredientPageState();
}

class _EditIngredientPageState extends State<EditIngredientPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController name;

  late final TextEditingController energy;

  late final TextEditingController fats;
  late final TextEditingController saturated;

  late final TextEditingController carbohydrates;
  late final TextEditingController sugar;
  late final TextEditingController fibre;

  late final TextEditingController protein;
  late final TextEditingController salt;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.ingredient?.name);

    energy = TextEditingController(text: widget.ingredient?.energy.toString());

    fats = TextEditingController(text: widget.ingredient?.fats.toString());
    saturated =
        TextEditingController(text: widget.ingredient?.saturated.toString());

    carbohydrates = TextEditingController(
        text: widget.ingredient?.carbohydrates.toString());
    sugar = TextEditingController(text: widget.ingredient?.sugar.toString());
    fibre = TextEditingController(text: widget.ingredient?.fibre.toString());

    protein =
        TextEditingController(text: widget.ingredient?.protein.toString());
    salt = TextEditingController(text: widget.ingredient?.salt.toString());
  }

  @override
  void dispose() {
    name.dispose();
    energy.dispose();
    fats.dispose();
    saturated.dispose();
    carbohydrates.dispose();
    sugar.dispose();
    fibre.dispose();
    protein.dispose();
    salt.dispose();
    super.dispose();
  }

  Future<void> saveValue() async {
    final item = Ingredient(
      id: widget.ingredient?.id ?? 0,
      mass: 100,
      name: name.text,
      energy: double.tryParse(energy.text) ?? 0,
      fats: double.tryParse(fats.text) ?? 0,
      saturated: double.tryParse(saturated.text) ?? 0,
      carbohydrates: double.tryParse(carbohydrates.text) ?? 0,
      sugar: double.tryParse(sugar.text) ?? 0,
      fibre: double.tryParse(fibre.text) ?? 0,
      protein: double.tryParse(protein.text) ?? 0,
      salt: double.tryParse(salt.text) ?? 0,
    );
    await widget.store.box<Ingredient>().putAsync(item);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.only(
              top: 84,
              left: 24,
              right: 24,
              bottom: 96,
            ),
            children: [
              NeumorphicTextField(
                child: TextFormField(
                  controller: name,
                  // Autofocus if this is a new item
                  autofocus: widget.ingredient == null,
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
              const SizedBox(height: 16),
              NeumorphicTextField(
                child: TextFormField(
                  controller: energy,
                  validator: requiredNumber,
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Energy',
                    hintText: '0',
                    suffixText: 'kcal',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Fats',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: NeumorphicTextField(
                        child: TextFormField(
                          controller: fats,
                          validator: requiredNumber,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Total',
                            hintText: '0',
                            suffixText: 'g',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: NeumorphicTextField(
                      child: TextFormField(
                        controller: saturated,
                        validator: requiredNumber,
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Saturated',
                          hintText: '0',
                          suffixText: 'g',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Carbohydrates',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: NeumorphicTextField(
                        child: TextFormField(
                          controller: carbohydrates,
                          validator: requiredNumber,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Total',
                            hintText: '0',
                            suffixText: 'g',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: NeumorphicTextField(
                        child: TextFormField(
                          controller: sugar,
                          validator: requiredNumber,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Sugar',
                            hintText: '0',
                            suffixText: 'g',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: NeumorphicTextField(
                      child: TextFormField(
                        controller: fibre,
                        validator: requiredNumber,
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Fibre',
                          hintText: '0',
                          suffixText: 'g',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Other',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: NeumorphicTextField(
                        child: TextFormField(
                          controller: protein,
                          validator: requiredNumber,
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Protein',
                            hintText: '0',
                            suffixText: 'g',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: NeumorphicTextField(
                      child: TextFormField(
                        controller: salt,
                        validator: requiredNumber,
                        textInputAction: TextInputAction.done,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Salt',
                          hintText: '0',
                          suffixText: 'g',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
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
        ),
      );
}
