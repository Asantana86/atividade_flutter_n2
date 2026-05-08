import '../base/base_provider.dart';
import '../models/cliente_model.dart';


class ClienteProvider extends BaseProvider<ClienteModel> {
  
  @override
  String get endpoint => '/rest/v1/clientes';

  @override
  Map<String, dynamic> toExternalFormat(ClienteModel entity) {
    return {
      'id': entity.id,
      'nome': entity.nome,
      'documento': entity.documento,
      'telefone': entity.telefone,
      'email': entity.email,
      'ativo': entity.ativo,
      'created_at': entity.createdAt?.toIso8601String(), 
    };
  }

  @override
  ClienteModel fromExternalFormat(Map<String, dynamic> data) {
    return ClienteModel(
      id: data['id'],
      nome: data['nome'],
      documento: data['documento'],
      telefone: data['telefone'],
      email: data['email'],
      ativo: data['ativo'] ?? true,
      isSync: 1, 
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at']) 
          : null,
    );
  }
}