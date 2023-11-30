import 'dart:convert';
import 'dart:io';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
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
  EditIngredientPageState createState() => EditIngredientPageState();
}

class EditIngredientPageState extends State<EditIngredientPage> {
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

  Future<void> scanData() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1920,
      maxWidth: 1920,
      imageQuality: 88,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      List<int> imageBytes = await imageFile.readAsBytes();

      // Convert to Base64
      String base64Image = base64Encode(imageBytes);

      String body = jsonEncode({
        'model': 'gpt-4-vision-preview',
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': 'Analyze the nutritional information on this label and output it in the format:\n'
                    'Energy|Total Fats|Saturated Fats|Total Carbohydrates|Sugar|Fibre|Protein|Salt|Message\n'
                    'Under no circumstances should the output differ from that format.'
                    'Where everything is measured in grams (or kCal for Energy) and the values are for per 100g, not per serving.\n'
                    'If for any field you are unable to accurately determine a value, either make a best guess, or if you really are not sure, use a value of 0.\n'
                    'Do not output the unit, for example, write 36.6 and not 36.6g. Write 110, not 110kCal.'
                    'For the fields from Energy to Salt, under no circumstances should you use anything but a numerical value.'
                    'It is not that important to fill in saturated fats, sugar, fibre, and salt, if you are unsure just put 0 and don\'t consider it a big issue.'
                    'Message is optional. If you had trouble fufilling the requirements of the task, this is the place to put your comment.'
              },
              {
                'type': 'image_url',
                'image_url': {
                  "url": "data:image/jpeg;base64,$base64Image",
                }
              }
            ]
          }
        ],
        'max_tokens': 300,
      });

      // Step 2: Make the API Request
      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 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',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        var decodedResponse = jsonDecode(response.body);

        // Extract the message content of the first choice
        String messageContent =
            decodedResponse['choices'][0]['message']['content'];

        final parts = messageContent.split("|");
        energy.text = parts[0];
        fats.text = parts[1];
        saturated.text = parts[2];
        carbohydrates.text = parts[3];
        sugar.text = parts[4];
        fibre.text = parts[5];
        protein.text = parts[6];
        salt.text = parts[7];
        final message = parts[8];
        if (message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(days: 1),
              backgroundColor: Colors.orangeAccent,
              content: Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              response.body,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    }
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
                    onPressed: scanData,
                    minDistance: -2,
                    style: textButtonStyle,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Scan',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                    child: const Row(
                      children: [
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
