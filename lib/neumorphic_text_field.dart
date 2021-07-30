import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicTextField extends StatelessWidget {
  final TextFormField child;

  const NeumorphicTextField({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Neumorphic(
        style: const NeumorphicStyle(
          depth: -4,
          border: NeumorphicBorder(
            color: Color(0x88ffffff),
            width: 0.5,
          ),
        ),
        child: child,
      );
}
