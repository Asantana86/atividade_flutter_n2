import 'base_model.dart';

class UserModel extends BaseModel {
  final String nome;
  final String email;
  final String senha;

  UserModel({
    super.id,
    super.createdAt,
    required this.nome,
    required this.email,
    required this.senha,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }
}