import '../base/base_model.dart';

class UsuarioModel extends BaseModel {
  String nome;
  String email;
  String senha;

  UsuarioModel({
    super.id,
    super.createdAt,
    super.isSync = 0,
    super.ativo = true,
    required this.nome,
    required this.email,
    required this.senha,
  });

  UsuarioModel.fromMap(super.map)
      : nome = map['nome'] ?? '',
        email = map['email'] ?? '',
        senha = map['senha'] ?? '',
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {

    final map = super.toMap();
    
    map.addAll({
      'nome': nome,
      'email': email,
      'senha': senha,
    });
    
    return map;
  }
}