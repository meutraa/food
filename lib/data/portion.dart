import 'package:objectbox/objectbox.dart';

import 'ingredient.dart';
import 'recipe.dart';

// ignore_for_file: cascade_invocations

@Entity()
class Portion {
  int id;

  // If this is null, it is a portion used in a recipe, not intake
  @Property(type: PropertyType.date)
  DateTime? time;

  double mass;
  final ingredient = ToOne<Ingredient>();
  final recipe = ToOne<Recipe>();

  Portion({
    required this.mass,
    this.id = 0,
    this.time,
  });

  Ingredient mash() {
    final e = recipe.target!;
    final mash = Ingredient.mash(name: e.name, mass: mass);

    // Calculate combined stats if recipe
    for (final p in e.portions) {
      // Does not support embedded recipes yet
      final i = p.ingredient.target!;
      final ratio = p.mass / i.mass;

      mash.carbohydrates += i.carbohydrates * ratio;
      mash.sugar += i.sugar * ratio;
      mash.fibre += i.fibre * ratio;
      mash.energy += i.energy * ratio;
      mash.fats += i.fats * ratio;
      mash.saturated += i.saturated * ratio;
      mash.protein += i.protein * ratio;
      mash.salt += i.salt * ratio;
    }

    final ratio = mass / e.mass;

    mash.carbohydrates *= ratio;
    mash.sugar *= ratio;
    mash.fibre *= ratio;
    mash.energy *= ratio;
    mash.fats *= ratio;
    mash.saturated *= ratio;
    mash.protein *= ratio;
    mash.salt *= ratio;

    return mash;
  }

  T on<T>({
    required T Function(Ingredient) ingredient,
    required T Function(Recipe) recipe,
  }) {
    if (this.ingredient.hasValue) {
      return ingredient(this.ingredient.target!);
    }
    return recipe(this.recipe.target!);
  }

  String get name {
    if (ingredient.hasValue) {
      return ingredient.target!.name;
    }
    return recipe.target!.name;
  }
}
