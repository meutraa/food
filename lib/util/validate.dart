String? requiredNumber(String? val) {
  if (val == null || val.isEmpty) {
    return 'Required';
  }
  final d = double.tryParse(val);
  if (null == d) {
    return 'Required';
  }
  return null;
}
