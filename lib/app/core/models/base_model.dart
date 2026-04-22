abstract class BaseModel {
  final int? id;
  final DateTime? createdAt;

  BaseModel({this.id, this.createdAt});

  Map<String, dynamic> toMap();
}