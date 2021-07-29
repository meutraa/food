import 'dart:async';

import 'package:flutter/material.dart';

import 'data/intake.dart';
import 'objectbox.g.dart';

class StatisticsPage extends StatefulWidget {
  final Store store;

  const StatisticsPage({
    required this.store,
    Key? key,
  }) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final _controller = StreamController<List<Intake>>();

  @override
  void initState() {
    super.initState();
    final time = DateTime.now();
    final startTime = time.subtract(Duration(
      hours: time.hour,
      minutes: time.minute,
      seconds: time.second,
    ));
    _controller.addStream(
      widget.store
          .box<Intake>()
          .query(Intake_.time.greaterThan(startTime.millisecondsSinceEpoch))
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
          var totalEnergy = 0.0;
          for (final e in data) {
            totalEnergy += e.weight *
                ((e.consumable.target?.energy ?? 0) /
                    (e.consumable.target?.mass ?? 1));
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Energy'),
                  Text(totalEnergy.toString()),
                ],
              )
            ],
          );
        },
      );
}
