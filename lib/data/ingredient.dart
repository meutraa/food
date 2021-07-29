import 'package:objectbox/objectbox.dart';

@Entity()
class Ingredient {
  int id;

  final String name;

  final double mass; // in g
  final double energy; // in kcal

  final double fats;
  final double saturated;
  final double? mono;
  final double? poly;
  final double? trans;

  final double carbohydrates;
  final double sugar;
  final double fibre;

  final double protein;
  final double salt;

  Ingredient({
    required this.mass,
    required this.name,
    required this.energy,
    required this.fats,
    required this.saturated,
    required this.mono,
    required this.poly,
    required this.trans,
    required this.carbohydrates,
    required this.sugar,
    required this.fibre,
    required this.protein,
    required this.salt,
    this.id = 0,
  });
}
