import 'dart:async';

import 'package:flutter/material.dart';
import 'package:objectbox/internal.dart';

import 'objectbox.g.dart';

class Streamed<T> extends StatefulWidget {
  final Store store;
  final Widget Function(BuildContext, List<T>) builder;
  final Condition<T>? condition;
  final QueryIntegerProperty<T> orderField;

  const Streamed({
    super.key,
    required this.store,
    required this.builder,
    required this.orderField,
    this.condition,
  });

  @override
  _StreamedState<T> createState() => _StreamedState<T>();
}

class _StreamedState<T> extends State<Streamed<T>> {
  final _controller = StreamController<List<T>>();

  @override
  void initState() {
    super.initState();
    final qbuild = widget.store.box<T>().query(widget.condition)
      ..order(
        widget.orderField,
        flags: Order.descending,
      );
    _controller.addStream(
      qbuild.watch(triggerImmediately: true).map((e) => e.find()),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<T>>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.data == null) {
            return const SizedBox.shrink();
          }
          return widget.builder(context, snapshot.data!);
        },
      );
}
