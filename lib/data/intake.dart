import 'package:food/data/ingredient.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Intake {
  int id;

  final DateTime time;
  final int weight; // in grams
  final consumable = ToOne<Ingredient>();

  Intake({
    this.id = 0,
    required this.time,
    required this.weight,
  });
}
