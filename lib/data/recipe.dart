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

  Ingredient mash() {
    final mash = Ingredient.mash(name: name, mass: mass);

    // Calculate combined stats if recipe
    for (final p in portions) {
      final i = p.ingredient.target!;
      final ratio = p.mass / (i.mass == 0 ? 0.000001 : i.mass);

      mash.carbohydrates += i.carbohydrates * ratio;
      mash.sugar += i.sugar * ratio;
      mash.fibre += i.fibre * ratio;
      mash.energy += i.energy * ratio;
      mash.fats += i.fats * ratio;
      mash.saturated += i.saturated * ratio;
      mash.protein += i.protein * ratio;
      mash.salt += i.salt * ratio;
    }

    return mash;
  }

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
