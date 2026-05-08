import '../base/base_provider.dart';
import '../models/usuario_model.dart';

class UsuarioProvider extends BaseProvider<UsuarioModel> {
  
  @override
  String get endpoint => '/rest/v1/usuarios';

  @override
  Map<String, dynamic> toExternalFormat(UsuarioModel entity) {
    return {
      'id': entity.id,
      'nome': entity.nome,
      'email': entity.email,
      'senha': entity.senha,
      'ativo': entity.ativo,
      'created_at': entity.createdAt?.toIso8601String(),
    };
  }

  @override
  UsuarioModel fromExternalFormat(Map<String, dynamic> data) {
    return UsuarioModel(
      id: data['id'],
      nome: data['nome'],
      email: data['email'],
      senha: data['senha'] ?? '', 
      ativo: data['ativo'] ?? true,
      isSync: 1,
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at']) 
          : null,
    );
  }
}