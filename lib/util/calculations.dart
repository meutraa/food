import 'preferences.dart';

double bmr() {
  final w = Preferences.mass.val;
  final h = Preferences.height.val;
  final a = Preferences.age.val;
  final i = Preferences.intensity.val;
  final base = (10 * w) + (6.25 * h) - (5 * a);
  if (Preferences.sex.val == 0) {
    // Woman BMR = 10W + 6.25H - 5A - 161
    return (base - 161) * ((100 + i) / 100);
  }
  // Mifflin St Jeor method BMR = 10W + 6.25H - 5A + 5
  return (base + 5) * ((100 + i) / 100);
}

String intensityToString(double i) {
  if (i < 15) {
    return 'Sedentary';
  }
  if (i < 30) {
    return 'Light: 30-90 m/week';
  }
  if (i < 45) {
    return 'Medium: 90-120 m/week';
  }
  if (i < 55) {
    return 'Daily: 120-180 m/week';
  }
  if (i < 70) {
    return 'Intense: 300-800 m/week';
  }
  return 'Extreme: 800+ m/week';
}
