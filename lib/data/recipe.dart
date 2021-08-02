
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

  static Recipe fromJson(List<dynamic> m) {
    final r = Recipe(
      name: m[0] as String,
      mass: m[1] as double,
    );
    final portions = m[2] as List<dynamic>;
    for (final portion in portions) {
      final p = Portion(
        mass: portion[0] as double,
      );

      final ing = Ingredient.fromJson(portion[1] as List<dynamic>)..hidden = 1;
      p.ingredient.target = ing;
      r.portions.add(p);
    }
    return r;
  }
}
