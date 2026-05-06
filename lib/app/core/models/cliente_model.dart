import 'base_model.dart';

class ClienteModel extends BaseModel {
  String nome;
  String? documento;
  String? telefone;
  String? email;

  ClienteModel({
    super.id,
    super.isSync,
    required this.nome,
    this.documento,
    this.telefone,
    this.email,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'documento': documento,
      'telefone': telefone,
      'email': email,
      'is_sync': isSync ? 1 : 0, 
    };
  }

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      documento: map['documento'] as String?,
      telefone: map['telefone'] as String?,
      email: map['email'] as String?,
      isSync: map['is_sync'] == 1 || map['is_sync'] == true,
    );
  }
}