import 'package:objectbox/objectbox.dart';

@Entity()
class Ingredient {
  int id;

  final String name;
  final String? description;

  int? hidden;

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
    this.hidden = 0,
    this.id = 0,
    this.description,
  });

  Ingredient.initial(
    this.name,
    this.description,
    this.energy,
    this.fats,
    this.saturated,
    this.carbohydrates,
    this.sugar,
    double nsp,
    double aoac,
    this.protein, {
    this.salt = 0,
    this.hidden = 0,
    this.id = 0,
  })  : mass = 100,
        fibre = aoac == -1 ? (nsp == -1 ? 0 : nsp) : aoac;

  Ingredient.mash({
    required this.mass,
    required this.name,
    this.id = 0,
    this.hidden = 0,
    this.energy = 0,
    this.fats = 0,
    this.saturated = 0,
    this.carbohydrates = 0,
    this.sugar = 0,
    this.fibre = 0,
    this.protein = 0,
    this.salt = 0,
    this.description,
  });

  Object toJson() => [
        name,
        mass,
        energy,
        fats,
        saturated,
        carbohydrates,
        sugar,
        fibre,
        protein,
        salt,
      ];

  Ingredient.fromJson(List<dynamic> m)
      : id = 0,
        description = null,
        name = m[0] as String,
        mass = m[1] as double,
        energy = m[2] as double,
        fats = m[3] as double,
        saturated = m[4] as double,
        carbohydrates = m[5] as double,
        sugar = m[6] as double,
        fibre = m[7] as double,
        protein = m[8] as double,
        salt = m[9] as double;

  Ingredient mash(double mass) {
    final ratio = mass / (this.mass == 0 ? 0.00001 : this.mass);

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
