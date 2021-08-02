// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'data/ingredient.dart';
import 'data/portion.dart';
import 'data/recipe.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(6, 4101147900017153457),
      name: 'Ingredient',
      lastPropertyId: const IdUid(16, 2093308163979442057),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4013903059640739860),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 2090748974153688133),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 2588603877116106213),
            name: 'mass',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 2152827974320335695),
            name: 'energy',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7652548494679121427),
            name: 'fats',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4783143636097394884),
            name: 'saturated',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 1282655853159619118),
            name: 'carbohydrates',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 5414923412053848263),
            name: 'sugar',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 8467655912063351325),
            name: 'fibre',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 804031010785208270),
            name: 'protein',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 7284364091020943374),
            name: 'salt',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 2955767762301129367),
            name: 'description',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 2093308163979442057),
            name: 'hidden',
            type: 6,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(7, 4721127787242866140),
      name: 'Portion',
      lastPropertyId: const IdUid(6, 283010009421134714),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2550124787511536600),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 2353487401390339780),
            name: 'mass',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 453013460953681734),
            name: 'ingredientId',
            type: 11,
            flags: 520,
            indexId: const IdUid(6, 8603847032606655999),
            relationTarget: 'Ingredient'),
        ModelProperty(
            id: const IdUid(5, 7405375763407012131),
            name: 'recipeId',
            type: 11,
            flags: 520,
            indexId: const IdUid(7, 7782367577531607084),
            relationTarget: 'Recipe'),
        ModelProperty(
            id: const IdUid(6, 283010009421134714),
            name: 'time',
            type: 10,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[]),
  ModelEntity(
      id: const IdUid(8, 7205039251749828705),
      name: 'Recipe',
      lastPropertyId: const IdUid(3, 4573618699899586253),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 2043049732395398508),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 3355160824709342950),
            name: 'name',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 4573618699899586253),
            name: 'mass',
            type: 8,
            flags: 0)
      ],
      relations: <ModelRelation>[
        ModelRelation(
            id: const IdUid(3, 8363734226604639706),
            name: 'portions',
            targetId: const IdUid(7, 4721127787242866140))
      ],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(8, 7205039251749828705),
      lastIndexId: const IdUid(7, 7782367577531607084),
      lastRelationId: const IdUid(3, 8363734226604639706),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [
        36816919420837512,
        5267267050005486488,
        5918916334508561344,
        7120205940503542543,
        8861615756480254289
      ],
      retiredIndexUids: const [
        4157116326453056863,
        266081879550341698,
        5469313326393036151,
        8645433870857251723
      ],
      retiredPropertyUids: const [
        1222528314231353824,
        6962855061843395183,
        3223880003707822278,
        1698466432074694215,
        7289906479910282808,
        3620697102584583847,
        4569798418764039418,
        319566245250694942,
        1469355687310338378,
        6498546952786623555,
        2493596399289435015,
        9211664360949512662,
        5424715489034289323,
        5762251127101145539,
        8821669328975412213,
        4604273341300643895,
        2557874668193150369,
        6721022271539783193,
        8563267185212603896,
        2998328616056215884,
        4359242047460789542,
        5500125760129248176,
        3533557609767676090,
        2720562536719449149,
        3543251099866274844,
        5277583540680425445,
        2430763154650924247,
        2814250879766869569,
        2515320513591593693,
        1272504987310327819,
        1729422549099514156,
        6694816106999142205,
        435729449234496677,
        5621160335754154102,
        7504966109391101,
        5413495891883569908,
        8729865071656684027,
        8243472228486495303,
        7250936914958332269
      ],
      retiredRelationUids: const [7759112108806387875],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    Ingredient: EntityDefinition<Ingredient>(
        model: _entities[0],
        toOneRelations: (Ingredient object) => [],
        toManyRelations: (Ingredient object) => {},
        getId: (Ingredient object) => object.id,
        setId: (Ingredient object, int id) {
          object.id = id;
        },
        objectToFB: (Ingredient object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final descriptionOffset = object.description == null
              ? null
              : fbb.writeString(object.description!);
          fbb.startTable(17);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addFloat64(2, object.mass);
          fbb.addFloat64(3, object.energy);
          fbb.addFloat64(4, object.fats);
          fbb.addFloat64(5, object.saturated);
          fbb.addFloat64(9, object.carbohydrates);
          fbb.addFloat64(10, object.sugar);
          fbb.addFloat64(11, object.fibre);
          fbb.addFloat64(12, object.protein);
          fbb.addFloat64(13, object.salt);
          fbb.addOffset(14, descriptionOffset);
          fbb.addInt64(15, object.hidden);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Ingredient(
              mass:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              energy:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 10, 0),
              fats:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 12, 0),
              saturated:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 14, 0),
              carbohydrates:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 22, 0),
              sugar:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 24, 0),
              fibre:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 26, 0),
              protein:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 28, 0),
              salt:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 30, 0),
              hidden: const fb.Int64Reader()
                  .vTableGetNullable(buffer, rootOffset, 34),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              description: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 32));

          return object;
        }),
    Portion: EntityDefinition<Portion>(
        model: _entities[1],
        toOneRelations: (Portion object) => [object.ingredient, object.recipe],
        toManyRelations: (Portion object) => {},
        getId: (Portion object) => object.id,
        setId: (Portion object, int id) {
          object.id = id;
        },
        objectToFB: (Portion object, fb.Builder fbb) {
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addFloat64(1, object.mass);
          fbb.addInt64(3, object.ingredient.targetId);
          fbb.addInt64(4, object.recipe.targetId);
          fbb.addInt64(5, object.time?.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final timeValue =
              const fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 14);
          final object = Portion(
              mass:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 6, 0),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              time: timeValue == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(timeValue));
          object.ingredient.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0);
          object.ingredient.attach(store);
          object.recipe.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0);
          object.recipe.attach(store);
          return object;
        }),
    Recipe: EntityDefinition<Recipe>(
        model: _entities[2],
        toOneRelations: (Recipe object) => [],
        toManyRelations: (Recipe object) =>
            {RelInfo<Recipe>.toMany(3, object.id): object.portions},
        getId: (Recipe object) => object.id,
        setId: (Recipe object, int id) {
          object.id = id;
        },
        objectToFB: (Recipe object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addFloat64(2, object.mass);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = Recipe(
              mass:
                  const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0),
              name:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 6, ''),
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0));
          InternalToManyAccess.setRelInfo(object.portions, store,
              RelInfo<Recipe>.toMany(3, object.id), store.box<Recipe>());
          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [Ingredient] entity fields to define ObjectBox queries.
class Ingredient_ {
  /// see [Ingredient.id]
  static final id =
      QueryIntegerProperty<Ingredient>(_entities[0].properties[0]);

  /// see [Ingredient.name]
  static final name =
      QueryStringProperty<Ingredient>(_entities[0].properties[1]);

  /// see [Ingredient.mass]
  static final mass =
      QueryDoubleProperty<Ingredient>(_entities[0].properties[2]);

  /// see [Ingredient.energy]
  static final energy =
      QueryDoubleProperty<Ingredient>(_entities[0].properties[3]);

  /// see [Ingredient.fats]
  static final fats =
      QueryDoubleProperty<Ingredient>(_entities[0].properties[4]);

  /// see [Ingredient.saturated]
  static final saturated =
      QueryDoubleProperty<Ingredient>(_entities[0].properties[5]);

  /// see [Ingredient.carbohydrates]
  static final carbohydrates =
      QueryDoubleProperty<Ingredient>(_entities[0].properties[6]);

  /// see [Ingredient.sugar]
  static final sugar =
      QueryDoubleProperty<Ingredient>(_entities[0].properties[7]);

  /// see [Ingredient.fibre]
  static final fibre =
      QueryDoubleProperty<Ingredient>(_entities[0].properties[8]);

  /// see [Ingredient.protein]
  static final protein =
      QueryDoubleProperty<Ingredient>(_entities[0].properties[9]);

  /// see [Ingredient.salt]
  static final salt =
      QueryDoubleProperty<Ingredient>(_entities[0].properties[10]);

  /// see [Ingredient.description]
  static final description =
      QueryStringProperty<Ingredient>(_entities[0].properties[11]);

  /// see [Ingredient.hidden]
  static final hidden =
      QueryIntegerProperty<Ingredient>(_entities[0].properties[12]);
}

/// [Portion] entity fields to define ObjectBox queries.
class Portion_ {
  /// see [Portion.id]
  static final id = QueryIntegerProperty<Portion>(_entities[1].properties[0]);

  /// see [Portion.mass]
  static final mass = QueryDoubleProperty<Portion>(_entities[1].properties[1]);

  /// see [Portion.ingredient]
  static final ingredient =
      QueryRelationToOne<Portion, Ingredient>(_entities[1].properties[2]);

  /// see [Portion.recipe]
  static final recipe =
      QueryRelationToOne<Portion, Recipe>(_entities[1].properties[3]);

  /// see [Portion.time]
  static final time = QueryIntegerProperty<Portion>(_entities[1].properties[4]);
}

/// [Recipe] entity fields to define ObjectBox queries.
class Recipe_ {
  /// see [Recipe.id]
  static final id = QueryIntegerProperty<Recipe>(_entities[2].properties[0]);

  /// see [Recipe.name]
  static final name = QueryStringProperty<Recipe>(_entities[2].properties[1]);

  /// see [Recipe.mass]
  static final mass = QueryDoubleProperty<Recipe>(_entities[2].properties[2]);

  /// see [Recipe.portions]
  static final portions =
      QueryRelationToMany<Recipe, Portion>(_entities[2].relations[0]);
}
