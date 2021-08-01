import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntPreference extends BasePreference<int> {
  IntPreference(
    SharedPreferences _prefs, {
    required String key,
    required int defaultValue,
  }) : super(
          _prefs,
          key: key,
          defaultValue: defaultValue,
          set: (prefs, key, value) => prefs.setInt(key, value ?? defaultValue),
          get: (prefs, key) => prefs.getInt(key),
        );
}

class BasePreference<T> {
  final SharedPreferences _prefs;
  final String key;
  final T? Function(SharedPreferences prefs, String key) get;
  final Future<bool> Function(
    SharedPreferences prefs,
    String key,
    T? value,
  ) set;
  late final ValueNotifier<T?> notifier;
  final T defaultValue;

  BasePreference(
    this._prefs, {
    required this.key,
    required this.get,
    required this.set,
    required this.defaultValue,
  }) {
    T? initial;
    try {
      initial = get(_prefs, key);
    } catch (e) {
      _prefs.remove(key);
      initial = defaultValue;
    }
    notifier = ValueNotifier(initial);
  }

  set val(T? value) {
    notifier.value = value ?? defaultValue;
    set(_prefs, key, value ?? defaultValue);
  }

  T get val => notifier.value ?? defaultValue;
}

class Preferences {
  static final Preferences _state = Preferences._private();

  factory Preferences() => _state;

  Preferences._private();

  static late final IntPreference initialDataVersion;

  static late final IntPreference mass;
  static late final IntPreference age;
  static late final IntPreference sex;
  static late final IntPreference height;

  static late final IntPreference calPerc;
  static late final IntPreference fatPerc;
  static late final IntPreference protein;
  static late final IntPreference intensity;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    initialDataVersion = IntPreference(
      prefs,
      key: 'initialDataVersion',
      defaultValue: 0,
    );
    calPerc = IntPreference(prefs, key: 'energy', defaultValue: 100);
    fatPerc = IntPreference(prefs, key: 'fat', defaultValue: 70);
    protein = IntPreference(prefs, key: 'protein', defaultValue: 80);
    intensity = IntPreference(prefs, key: 'intensity', defaultValue: 10);
    sex = IntPreference(prefs, key: 'sex', defaultValue: 0);
    mass = IntPreference(prefs, key: 'mass', defaultValue: 60);
    age = IntPreference(prefs, key: 'age', defaultValue: 18);
    height = IntPreference(prefs, key: 'height', defaultValue: 168);
  }
}
