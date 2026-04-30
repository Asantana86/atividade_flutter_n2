abstract class BaseModel {
  int? id;
  bool isSync;

  BaseModel({this.id, this.isSync = false});

  Map<String, dynamic> toMap();
}