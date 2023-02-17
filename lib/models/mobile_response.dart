class MobileResponse<t> {
  int? status;
  String? message;
  t? data;

  MobileResponse.fromJson(
      Map<String, dynamic> json, Function(dynamic json) parseData) {
    status = json['status'];
    message = json['message'];
    try {
      data = parseData(json["data"]);
    } catch (e) {
      data = json["data"];
    } finally {}
  }
}
