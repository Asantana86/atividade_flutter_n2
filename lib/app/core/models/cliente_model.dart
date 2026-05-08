import '../base/base_model.dart';

class ClienteModel extends BaseModel {
  String nome;
  String documento;
  String telefone;
  String? email;

  ClienteModel({
    super.id,
    super.createdAt,
    super.isSync = 0,
    super.ativo = true,
    required this.nome,
    required this.documento,
    required this.telefone,
    this.email,
  });

  ClienteModel.fromMap(super.map)
      : nome = map['nome'] ?? '',
        documento = map['documento'] ?? '',
        telefone = map['telefone'] ?? '',
        email = map['email'],
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    
    map.addAll({
      'nome': nome,
      'documento': documento,
      'telefone': telefone,
      'email': email, 
    });
    
    return map;
  }
}