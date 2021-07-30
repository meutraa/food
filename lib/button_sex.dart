import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'util/preferences.dart';

class SexButton extends StatefulWidget {
  const SexButton({
    Key? key,
  }) : super(key: key);

  @override
  State<SexButton> createState() => _SexButtonState();
}

class _SexButtonState extends State<SexButton> {
  late int val;

  @override
  void initState() {
    super.initState();
    val = Preferences.sex.val;
  }

  @override
  Widget build(BuildContext context) => NeumorphicButton(
        onPressed: () {
          final v = (val + 1) % 2;
          Preferences.sex.val = val + 1 % 2;
          setState(() {
            val = v;
          });
        },
        padding: const EdgeInsets.all(16),
        child: Icon(val == 0 ? Icons.female_rounded : Icons.male_rounded),
      );
}
