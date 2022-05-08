import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'button_sex.dart';
import 'item_preference.dart';
import 'util/calculations.dart';
import 'util/preferences.dart';

class PreferencePage extends StatelessWidget {
  const PreferencePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 72, horizontal: 32),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Preferences',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  SexButton(),
                ],
              ),
              const SizedBox(height: 24),
              PreferenceItem<int>(
                title: 'Age',
                format: (v) => '${v.toStringAsFixed(0)} years',
                preference: Preferences.age,
                decode: (v) => v.toDouble(),
                encode: (v) => v.round(),
                min: 12,
                max: 80,
              ),
              PreferenceItem<int>(
                title: 'Height',
                format: (v) => '${v.toStringAsFixed(0)} cm',
                preference: Preferences.height,
                decode: (v) => v.toDouble(),
                encode: (v) => v.round(),
                min: 100,
                max: 200,
              ),
              PreferenceItem<int>(
                title: 'Body Mass',
                format: (v) => '${v.toStringAsFixed(0)} kg',
                preference: Preferences.mass,
                decode: (v) => v.toDouble(),
                encode: (v) => v.round(),
                min: 40,
                max: 100,
              ),
              PreferenceItem<int>(
                title: 'Weekly Activity',
                format: intensityToString,
                preference: Preferences.intensity,
                decode: (v) => v.toDouble(),
                encode: (v) => v.round(),
                min: 10,
                max: 90,
              ),
              const Divider(
                height: 24,
                thickness: 0.2,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              PreferenceItem<int>(
                title: 'Energy deficit/surplus',
                format: (v) => '${v.toStringAsFixed(0)} %',
                preference: Preferences.calPerc,
                decode: (v) => v.toDouble(),
                encode: (v) => v.round(),
                min: 60,
                max: 140,
              ),
              PreferenceItem<int>(
                title: 'Fat Ratio',
                format: (v) => '${v.toStringAsFixed(0)} %',
                preference: Preferences.fatPerc,
                decode: (v) => v.toDouble(),
                encode: (v) => v.round(),
                min: 10,
                max: 100,
              ),
              PreferenceItem<int>(
                title: 'Protein Ratio',
                format: (v) => '${v.toStringAsFixed(1)} g/kg',
                preference: Preferences.protein,
                decode: (v) => v / 100,
                encode: (v) => (v * 100).round(),
                min: 0.6,
                max: 2.2,
              ),
              Expanded(
                child: NeumorphicButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
