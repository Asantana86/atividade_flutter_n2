abstract class BaseModel {
  final int? id;
  final DateTime? createdAt;
  int isSync;
  bool ativo;

  BaseModel({
    this.id, 
    DateTime? createdAt, 
    this.isSync = 0, 
    this.ativo = true,
  }): createdAt = createdAt ?? DateTime.now();

  BaseModel.fromMap(Map<String, dynamic> map)
      : id = map['id'] as int?,
        createdAt = map['created_at'] != null
            ? DateTime.tryParse(map['created_at'].toString())
            : null,
        isSync = (map['is_sync'] as int?) ?? 0,
        ativo = (map['ativo'] as int?) == 1;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'is_sync': isSync,
      'ativo': ativo ? 1 : 0,
    };
  }
}