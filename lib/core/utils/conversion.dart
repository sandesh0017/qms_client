String interpolate(String string, {required List<dynamic> params}) {
  String result = string;
  for (int i = 0; i < params.length; i++) {
    result = result.replaceAll('{$i}', params[i].toString());
  }
  return result;
}

extension StringFormating on String {
  format({required List<dynamic> params}) {
    return interpolate(this, params: params);
  }
}
