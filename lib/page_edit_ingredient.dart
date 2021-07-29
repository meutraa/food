import 'package:flutter/material.dart';

import 'data/ingredient.dart';
import 'objectbox.g.dart';

String? requiredNumber(String? val) {
  if (val == null || val.isEmpty) {
    return 'Required';
  }
  final d = double.tryParse(val);
  if (null == d || d == 0.0) {
    return 'Required';
  }
  return null;
}

class EditIngredientPage extends StatefulWidget {
  final Ingredient? ingredient;
  final Store store;

  const EditIngredientPage({
    Key? key,
    required this.store,
    this.ingredient,
  }) : super(key: key);

  @override
  _EditIngredientPageState createState() => _EditIngredientPageState();
}

class _EditIngredientPageState extends State<EditIngredientPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController name;

  late final TextEditingController mass;
  late final TextEditingController energy;

  late final TextEditingController fats;
  late final TextEditingController saturated;
  late final TextEditingController mono;
  late final TextEditingController poly;
  late final TextEditingController trans;

  late final TextEditingController carbohydrates;
  late final TextEditingController sugar;
  late final TextEditingController fibre;

  late final TextEditingController protein;
  late final TextEditingController salt;

  void initState() {
    super.initState();
    name = TextEditingController(text: widget.ingredient?.name);

    mass = TextEditingController(text: widget.ingredient?.mass.toString());
    energy = TextEditingController(text: widget.ingredient?.energy.toString());

    fats = TextEditingController(text: widget.ingredient?.fats.toString());
    saturated =
        TextEditingController(text: widget.ingredient?.saturated.toString());
    mono = TextEditingController(text: widget.ingredient?.mono?.toString());
    poly = TextEditingController(text: widget.ingredient?.poly?.toString());
    trans = TextEditingController(text: widget.ingredient?.trans?.toString());

    carbohydrates = TextEditingController(
        text: widget.ingredient?.carbohydrates.toString());
    sugar = TextEditingController(text: widget.ingredient?.sugar.toString());
    fibre = TextEditingController(text: widget.ingredient?.fibre.toString());

    protein =
        TextEditingController(text: widget.ingredient?.protein.toString());
    salt = TextEditingController(text: widget.ingredient?.salt.toString());
  }

  void dispose() {
    name.dispose();
    mass.dispose();
    energy.dispose();
    fats.dispose();
    saturated.dispose();
    mono.dispose();
    poly.dispose();
    trans.dispose();
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
      mass: double.tryParse(mass.text) ?? 0,
      name: name.text,
      energy: double.tryParse(energy.text) ?? 0,
      fats: double.tryParse(fats.text) ?? 0,
      saturated: double.tryParse(saturated.text) ?? 0,
      mono: double.tryParse(mono.text) ?? 0,
      poly: double.tryParse(poly.text) ?? 0,
      trans: double.tryParse(trans.text) ?? 0,
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
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: TextFormField(
                        controller: protein,
                        validator: requiredNumber,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Protein',
                          hintText: '0',
                          suffixText: 'g',
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: TextFormField(
                        controller: energy,
                        validator: requiredNumber,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Energy',
                          hintText: '0',
                          suffixText: 'Kcal',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Fats',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: TextFormField(
                        controller: fats,
                        validator: requiredNumber,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Total',
                          hintText: '0',
                          suffixText: 'g',
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: TextFormField(
                        controller: trans,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Trans',
                          hintText: '0',
                          suffixText: 'g',
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: saturated,
                      validator: requiredNumber,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Saturated',
                        hintText: '0',
                        suffixText: 'g',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: TextFormField(
                        controller: mono,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Mono Unsaturated',
                          hintText: '0',
                          suffixText: 'g',
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: TextFormField(
                        controller: poly,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Poly Unsaturated',
                          hintText: '0',
                          suffixText: 'g',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Carbohydrates',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: TextFormField(
                        controller: carbohydrates,
                        validator: requiredNumber,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Total',
                          hintText: '0',
                          suffixText: 'g',
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: TextFormField(
                        controller: sugar,
                        validator: requiredNumber,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Sugar',
                          hintText: '0',
                          suffixText: 'g',
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: fibre,
                      validator: requiredNumber,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Fibre',
                        hintText: '0',
                        suffixText: 'g',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Other',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: salt,
                validator: requiredNumber,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Salt',
                  hintText: '0',
                  suffixText: 'g',
                ),
              ),
            ],
          ),
        ),
      );
}
