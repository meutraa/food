// ignore: prefer_relative_imports
import 'package:food/data/ingredient.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Intake {
  int id;

  final DateTime time;
  final int weight; // in grams
  final consumable = ToOne<Ingredient>();

  Intake({
    required this.time,
    required this.weight,
    this.id = 0,
  });
}
