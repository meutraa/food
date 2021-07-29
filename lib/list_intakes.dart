import 'dart:async';

import 'package:flutter/material.dart';

import 'data/intake.dart';
import 'objectbox.g.dart';

class IntakeList extends StatefulWidget {
  final Store store;

  const IntakeList({
    required this.store,
    Key? key,
  }) : super(key: key);

  @override
  _IntakeListState createState() => _IntakeListState();
}

class _IntakeListState extends State<IntakeList> {
  final _controller = StreamController<List<Intake>>();

  @override
  void initState() {
    super.initState();
    _controller.addStream(
      widget.store
          .box<Intake>()
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
  Widget build(BuildContext context) => StreamBuilder<List<Intake>>(
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
          return ListView.separated(
            padding: const EdgeInsets.only(top: 64),
            itemBuilder: (context, i) => Text(
              data[i].consumable.target?.name ?? 'No target',
            ),
            separatorBuilder: (context, i) => const Divider(),
            itemCount: data.length,
          );
        },
      );
}
