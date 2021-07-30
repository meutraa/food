import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'style.dart';
import 'util/preferences.dart';

class PreferenceItem<T> extends StatefulWidget {
  final BasePreference<T> preference;
  final double Function(T) decode;
  final T Function(double) encode;
  final String title;
  final String Function(double) format;
  final double min;
  final double max;

  const PreferenceItem({
    required this.preference,
    required this.decode,
    required this.encode,
    required this.title,
    required this.format,
    required this.min,
    required this.max,
    Key? key,
  }) : super(key: key);

  @override
  State<PreferenceItem<T>> createState() => _PreferenceItemState<T>();
}

class _PreferenceItemState<T> extends State<PreferenceItem<T>> {
  late double val;

  @override
  void initState() {
    super.initState();
    val = widget.decode(widget.preference.val);
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                widget.format(val),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          NeumorphicSlider(
            style: const SliderStyle(
              depth: 4,
              border: lightBorder,
              accent: Colors.white,
              variant: Colors.white,
            ),
            onChanged: (v) {
              widget.preference.val = widget.encode(v);
              setState(() => val = v);
            },
            min: widget.min,
            value: val,
            max: widget.max,
          ),
          const SizedBox(height: 16),
        ],
      );
}
