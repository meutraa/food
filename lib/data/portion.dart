import 'package:objectbox/objectbox.dart';

import 'ingredient.dart';
import 'recipe.dart';

@Entity()
class Portion {
  int id;

  final double mass;
  final ingredient = ToOne<Ingredient>();
  final recipe = ToOne<Recipe>();

  Portion({
    required this.mass,
    this.id = 0,
  });
}
