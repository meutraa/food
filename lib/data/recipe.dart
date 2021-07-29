import 'package:objectbox/objectbox.dart';

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
}
