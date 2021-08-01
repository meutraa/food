import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class Ingredient {
  int id;

  final String name;
  final String? description;

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
    this.id = 0,
  })  : mass = 100,
        fibre = aoac == -1 ? (nsp == -1 ? 0 : nsp) : aoac;

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
    this.description,
  });

  @override
  String toString() => jsonEncode(<String, dynamic>{
        'mass': mass,
        'name': name,
        'energy': energy,
        'fats': fats,
        'saturated': saturated,
        'carbohydrates': carbohydrates,
        'sugar': sugar,
        'fibre': fibre,
        'protein': protein,
        'salt': salt,
      });

  static Ingredient fromJson(String val) {
    final m = jsonDecode(val) as Map<String, dynamic>;
    return Ingredient(
      mass: m['mass'] as double,
      name: m['name'] as String,
      energy: m['energy'] as double,
      fats: m['fats'] as double,
      saturated: m['saturated'] as double,
      carbohydrates: m['carbohydrates'] as double,
      sugar: m['sugar'] as double,
      fibre: m['fibre'] as double,
      protein: m['protein'] as double,
      salt: m['salt'] as double,
    );
  }

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
