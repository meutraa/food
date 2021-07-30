import 'package:objectbox/objectbox.dart';

@Entity()
class Ingredient {
  int id;

  final String name;

  double mass; // in g
  double energy; // in kcal

  double fats;
  double saturated;

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
      carbohydrates: carbohydrates * ratio,
      sugar: sugar * ratio,
      fibre: fibre * ratio,
      protein: protein * ratio,
      salt: salt * ratio,
    );
  }
}
