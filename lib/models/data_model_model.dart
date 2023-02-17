// To parse this JSON data, do
//
//     final DataModel = DataModelFromJson(jsonString);

class DataModel {
  DataModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
