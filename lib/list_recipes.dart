import 'dart:async';

import 'package:flutter/material.dart';

import 'data/recipe.dart';
import 'item_recipe.dart';
import 'objectbox.g.dart';

class RecipeList extends StatefulWidget {
  final Store store;

  const RecipeList({
    required this.store,
    Key? key,
  }) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  final _controller = StreamController<List<Recipe>>();

  @override
  void initState() {
    super.initState();
    _controller.addStream(
      widget.store
          .box<Recipe>()
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
  Widget build(BuildContext context) => StreamBuilder<List<Recipe>>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text('Empty list'),
            );
          }
          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(top: 64),
            itemBuilder: (context, i) => RecipeItem(
              recipe: data[i],
              store: widget.store,
            ),
            itemCount: data.length,
          );
        },
      );
}
