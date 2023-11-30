import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import 'neumorphic_text_field.dart';
import 'objectbox.g.dart';
import 'streamed.dart';

class DataList<T> extends StatefulWidget {
  final Store store;
  final Widget Function(BuildContext, T) itemBuilder;
  final String Function(T) searchString;
  final Condition<T>? condition;
  final QueryIntegerProperty<T> orderField;
  final String hint;

  const DataList({
    required this.store,
    required this.itemBuilder,
    required this.searchString,
    required this.hint,
    required this.orderField,
    this.condition,
    super.key,
  });

  @override
  DataListState<T> createState() => DataListState<T>();
}

class DataListState<T> extends State<DataList<T>>
    with AutomaticKeepAliveClientMixin {
  var _filter = '';
  final _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filterController.addListener(filterListener);
  }

  void filterListener() => setState(
        () => _filter = _filterController.text.toLowerCase(),
      );

  @override
  void dispose() {
    _filterController
      ..removeListener(filterListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Streamed<T>(
      orderField: widget.orderField,
      store: widget.store,
      condition: widget.condition,
      builder: (context, items) {
        final data = items
            .where(
              (e) => widget.searchString(e).toLowerCase().contains(_filter),
            )
            .toList(growable: false);

        if (data.isEmpty && _filter.isEmpty) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.lightBlue,
                  Colors.lightBlue,
                  Colors.transparent,
                  Colors.transparent,
                ],
                stops: [
                  0.0,
                  0.1,
                  0.85,
                  0.91,
                  1.0,
                ],
              ).createShader(bounds),
              blendMode: BlendMode.dstIn,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 96, top: 52),
                reverse: true,
                itemBuilder: (context, i) =>
                    widget.itemBuilder(context, data[i]),
                itemCount: data.length,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 14,
                  bottom: 14,
                  left: 16,
                  right: 92,
                ),
                child: NeumorphicTextField(
                  child: TextFormField(
                    controller: _filterController,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      alignLabelWithHint: true,
                      hintText: widget.hint,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
