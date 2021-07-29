import 'package:flutter/material.dart';

import 'objectbox.g.dart';
import 'page_home.dart';

class Application extends StatefulWidget {
  const Application({
    Key? key,
  }) : super(key: key);

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late Future<Store> store;

  @override
  void initState() {
    store = openStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Food',
        theme: ThemeData(
          splashColor: Colors.white,
          primarySwatch: Colors.lightBlue,
          canvasColor: Colors.lightBlue,
          colorScheme: ColorScheme.light(
            primary: Colors.lightBlue,
            secondary: Colors.yellowAccent.shade100,
            onSecondary: Colors.lightBlue,
            brightness: Brightness.dark,
          ),
          typography: Typography.material2018(),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionHandleColor: Colors.white,
            selectionColor: Colors.white.withOpacity(0.4),
          ),
          inputDecorationTheme: InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
            ),
            suffixStyle: const TextStyle(
              color: Colors.white,
            ),
            labelStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        home: FutureBuilder<Store>(
          future: store,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return HomePage(store: snapshot.data!);
          },
        ),
      );
}
