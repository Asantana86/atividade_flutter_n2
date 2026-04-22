import 'base_model.dart';

class ClienteModel extends BaseModel {
  final String nome;
  final String documento; // CPF ou CNPJ
  final String email;
  final String telefone;

  ClienteModel({
    super.id,
    super.createdAt,
    required this.nome,
    required this.documento,
    required this.email,
    required this.telefone,
  });

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      nome: map['nome'] as String,
      documento: map['documento'] as String,
      email: map['email'] as String,
      telefone: map['telefone'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'nome': nome,
      'documento': documento,
      'email': email,
      'telefone': telefone,
    };
  }
}