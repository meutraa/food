import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food/item_ingredient.dart';

import 'data/ingredient.dart';
import 'objectbox.g.dart';

class IngredientList extends StatefulWidget {
  final Store store;

  const IngredientList({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  _IngredientListState createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  final _controller = StreamController<List<Ingredient>>();

  @override
  void initState() {
    super.initState();
    _controller.addStream(
      widget.store
          .box<Ingredient>()
          .query()
          .watch(triggerImmediately: true)
          .map((e) => e.find()),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Ingredient>>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.data == null) {
            return Center(
              child: Text('Empty list'),
            );
          }
          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(top: 64),
            itemBuilder: (context, i) => IngredientItem(
              ingredient: data[i],
              store: widget.store,
            ),
            itemCount: data.length,
          );
        },
      );
}
