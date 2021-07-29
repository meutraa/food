import 'package:objectbox/objectbox.dart';

@Entity()
class Ingredient {
  int id;

  final String name;

  double mass; // in g
  double energy; // in kcal

  double fats;
  double saturated;
  double? mono;
  double? poly;
  double? trans;

  double carbohydrates;
  double sugar;
  double fibre;

  double protein;
  double salt;

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

  Ingredient.mash({
    required this.mass,
    required this.name,
    this.id = 0,
    this.energy = 0,
    this.fats = 0,
    this.saturated = 0,
    this.mono = 0,
    this.poly = 0,
    this.trans = 0,
    this.carbohydrates = 0,
    this.sugar = 0,
    this.fibre = 0,
    this.protein = 0,
    this.salt = 0,
  });

  Ingredient mash(double mass) {
    final ratio = mass / this.mass;

    return Ingredient(
      id: id,
      mass: mass,
      name: name,
      energy: energy * ratio,
      fats: fats * ratio,
      saturated: saturated * ratio,
      mono: (mono ?? 0) * ratio,
      poly: (poly ?? 0) * ratio,
      trans: (trans ?? 0) * ratio,
      carbohydrates: carbohydrates * ratio,
      sugar: sugar * ratio,
      fibre: fibre * ratio,
      protein: protein * ratio,
      salt: salt * ratio,
    );
  }
}
