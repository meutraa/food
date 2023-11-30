import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

const radioStyle = NeumorphicRadioStyle(
  selectedDepth: -2,
  border: lightBorder,
);

const lightBorder = NeumorphicBorder(
  color: Color(0x22ffffff),
  width: 0.5,
);

const textButtonStyle = NeumorphicStyle(
  border: lightBorder,
  depth: 4,
);

const uiStyle = SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarContrastEnforced: false,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.light,
  statusBarColor: Colors.transparent,
);
