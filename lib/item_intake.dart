import 'package:flutter/material.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'date.dart';
import 'graph.dart';
import 'item_ingredient.dart';
import 'modal_confirm.dart';
import 'modal_intake.dart';
import 'objectbox.g.dart';

class PortionItem extends StatefulWidget {
  final Portion portion;
  final Store store;

  const PortionItem({
    required this.portion,
    required this.store,
    Key? key,
  }) : super(key: key);

  @override
  _PortionItemState createState() => _PortionItemState();
}

class _PortionItemState extends State<PortionItem> {
  // This ingredient is an ingredient, or a mashed together recipe
  late Ingredient intake;

  @override
  void initState() {
    super.initState();
    intake = Ingredient.mash(
      mass: widget.portion.mass,
      name: widget.portion.on(ingredient: (e) => e.name, recipe: (e) => e.name),
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final mash = widget.portion.on(
          ingredient: (e) => e.mash(widget.portion.mass),
          recipe: (e) => widget.portion.mash(),
        );
        setState(() {
          intake = mash;
          intake.mass = widget.portion.mass;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: () => showIntakeDialog(
          context,
          store: widget.store,
          hideIngredient: true,
          initialPortion: widget.portion
            ..mass = 0.0
            ..id = 0
            ..recipe.target = widget.portion.recipe.target
            ..time = DateTime.now()
            ..ingredient.target = widget.portion.ingredient.target,
        ),
        child: ExpansionTile(
          title: Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(12),
              2: FlexColumnWidth(2),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  Text(
                    '${intake.mass.toInt()} g    ',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      intake.name,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Text(
                    timeAgo(widget.portion.time!),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 128,
                  width: 128,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ColoredStats(
                      carbs: intake.carbohydrates,
                      proteins: intake.protein,
                      fats: intake.fats,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 8,
                      end: 16,
                    ),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(8),
                        1: FlexColumnWidth(3),
                      },
                      children: tableRows
                          .map(
                            (e) => TableRow(
                              decoration: e.index.isOdd
                                  ? BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                    )
                                  : null,
                              children: [
                                Text(
                                  e.name,
                                ),
                                Text(
                                  '${nf(e.value(intake))} ${e.unit}',
                                  textAlign: TextAlign.end,
                                )
                              ],
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      showConfirmDialog(
                        context,
                        title: 'Delete ${intake.name}?',
                        onConfirmed: () {
                          widget.store.box<Portion>().remove(widget.portion.id);
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 8,
                  ),
                  child: TextButton.icon(
                    onPressed: () => showIntakeDialog(
                      context,
                      store: widget.store,
                      initialPortion: widget.portion,
                    ),
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
