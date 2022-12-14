import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'data/ingredient.dart';
import 'data/initial.dart';
import 'objectbox.g.dart';
import 'page_home.dart';
import 'style.dart';
import 'util/preferences.dart';

late Store store;

void main() {
  SystemChrome.setSystemUIOverlayStyle(uiStyle);
  runApp(Container(color: Colors.lightBlue));

  Future.wait([
    () async {
      await Preferences().init();
      store = await openStore();
      // Load initial data in if new data
      if (Preferences.initialDataVersion.val == 0) {
        debugPrint('migrating initial data to version 1');
        store.box<Ingredient>().putMany(foods);
        Preferences.initialDataVersion.val = 1;
      }
    }()
  ]).then(
    (value) => runApp(
      NeumorphicApp(
        title: 'Food',
        materialTheme: ThemeData(
          splashColor: Colors.white,
          primarySwatch: Colors.lightBlue,
          canvasColor: Colors.lightBlue,
          colorScheme: ColorScheme.light(
            primary: Colors.lightBlue,
            secondary: Colors.yellowAccent.shade100,
            onSecondary: Colors.lightBlue,
            brightness: Brightness.dark,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          typography: Typography.material2018(),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionHandleColor: Colors.white,
            selectionColor: Colors.white.withOpacity(0.4),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(
              left: 24,
              bottom: 12,
              top: 12,
              right: 24,
            ),
            suffixStyle: TextStyle(color: Colors.white),
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: NeumorphicThemeData(
          defaultTextColor: Colors.white,
          baseColor: Colors.lightBlue,
          variantColor: Colors.yellowAccent.shade100,
          shadowDarkColor: Colors.lightBlue.shade700,
          shadowLightColor: Colors.lightBlue.shade300,
          shadowDarkColorEmboss: Colors.lightBlue.shade700,
          shadowLightColorEmboss: Colors.lightBlue.shade300,
          buttonStyle: const NeumorphicStyle(
            depth: 8,
            boxShape: NeumorphicBoxShape.circle(),
            border: lightBorder,
          ),
          accentColor: Colors.yellowAccent.shade100,
        ),
        home: HomePage(store: store),
      ),
    ),
  );
}
