import 'package:food/data/portion.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Recipe {
  int id;

  final String name;
  final double mass;
  final portions = ToMany<Portion>();

  Recipe({
    this.id = 0,
    required this.mass,
    required this.name,
  });
}
