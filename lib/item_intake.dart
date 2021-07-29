import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'data/intake.dart';

import 'item_ingredient.dart';

class IntakeItem extends StatelessWidget {
  final Intake intake;

  const IntakeItem({
    required this.intake,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                Text(
                  intake.consumable.target?.name ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Row(children: [
                  Text('${nf(intake.weight.toDouble())} g'),
                ]),
                Text(intake.time.toIso8601String())
              ],
            ),
          ),
        ),
      );
}
