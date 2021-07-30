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

class DoublePreference extends BasePreference<double> {
  DoublePreference(
    SharedPreferences _prefs, {
    required String key,
    required double defaultValue,
  }) : super(
          _prefs,
          key: key,
          defaultValue: defaultValue,
          set: (prefs, key, value) => prefs.setDouble(
            key,
            value ?? defaultValue,
          ),
          get: (prefs, key) => prefs.getDouble(key),
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
    final initial = get(_prefs, key);
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

  static late final DoublePreference mass;
  static late final IntPreference energy;

  static late final IntPreference fatPerc;
  static late final IntPreference proteinPercMult;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    mass = DoublePreference(prefs, key: 'mass', defaultValue: 60);
    energy = IntPreference(prefs, key: 'energy', defaultValue: 1400);
    fatPerc = IntPreference(prefs, key: 'fat', defaultValue: 70);
    proteinPercMult = IntPreference(prefs, key: 'protein', defaultValue: 100);
  }
}
