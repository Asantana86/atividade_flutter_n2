abstract class BaseModel {
  final dynamic id;
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
      : id = map['id'], 
        createdAt = map['created_at'] != null
            ? DateTime.tryParse(map['created_at'].toString())
            : null,   
        isSync = map['is_sync'] != null 
            ? int.tryParse(map['is_sync'].toString()) ?? 0 
            : 0,    
        ativo = map['ativo'] is bool 
            ? map['ativo'] 
            : (map['ativo'].toString() == '1' || map['ativo'].toString() == 'true');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'is_sync': isSync,
      'ativo': ativo ? 1 : 0,
    };
  }
}