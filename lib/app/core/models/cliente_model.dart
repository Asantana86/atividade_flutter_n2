import 'base_model.dart';

class ClienteModel extends BaseModel {
  String nome;
  String documento; // CPF ou CNPJ
  String email;
  String telefone;

  ClienteModel({
    super.id,
    super.isSync,
    required this.nome,
    required this.documento,
    required this.email,
    required this.telefone,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'documento': documento,
      'email': email,
      'telefone': telefone,
      'isSync': isSync ? 1 : 0,
    };
  }

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'],
      nome: map['nome'],
      documento: map['documento'],
      email: map['email'],
      telefone: map['telefone'],
      isSync: map['isSync'] == 1,
    );
  }
}