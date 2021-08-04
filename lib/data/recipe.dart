import 'package:objectbox/objectbox.dart';

import 'ingredient.dart';
import 'portion.dart';

@Entity()
class Recipe {
  int id;

  final String name;
  final double mass;
  final portions = ToMany<Portion>();

  Recipe({
    required this.mass,
    required this.name,
    this.id = 0,
  });

  Object toJson() => [
        name,
        mass,
        portions.map((e) => e.toJson()).toList(growable: false),
      ];

  Recipe.fromJson(List<dynamic> m)
      : name = m[0] as String,
        mass = m[1] as double,
        id = 0 {
    portions.addAll(
      (m[2] as List<dynamic>).map(
        (dynamic e) => Portion(
          mass: e[0] as double,
        )..ingredient.target =
            (Ingredient.fromJson(e[1] as List<dynamic>)..hidden = 1),
      ),
    );
  }
}
