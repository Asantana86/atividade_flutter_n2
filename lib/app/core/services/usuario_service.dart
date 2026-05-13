import 'package:supabase_flutter/supabase_flutter.dart';

import '../base/base_service.dart';
import '../models/usuario_model.dart';
import '../repositories/usuario_repository.dart';
import '../validations/usuario_validation.dart';

class UsuarioService extends BaseService<UsuarioModel, UsuarioRepository, UsuarioValidation> {
  UsuarioService(super.validation, super.repository);

  @override
  UsuarioModel cloneModelWithId(UsuarioModel model, dynamic id) {
    return UsuarioModel(
      id: id,
      createdAt: model.createdAt,
      isSync: model.isSync,
      ativo: model.ativo,
      nome: model.nome,
      email: model.email,
      senha: model.senha,
    );
  }

  @override
  Future<UsuarioModel> create(UsuarioModel model) async {
    validation.validateFields(model);
    await validation.validateRulesCreate(model);

    try {
      final authResponse = await Supabase.instance.client.auth.signUp(
        email: model.email,
        password: model.senha!,
        data: {
          'nome_completo': model.nome,
        },
      );

      if (authResponse.user == null) {
        throw Exception('Falha ao gerar credencial no servidor.');
      }

      final usuarioComId = cloneModelWithId(model, authResponse.user!.id);
      
      usuarioComId.isSync = 1;

      await repository.insert(usuarioComId);
      
      return usuarioComId;

    } on AuthException catch (e) {
      if (e.message.contains('already registered')) {
        throw Exception('Este e-mail já está em uso na nuvem.');
      }
      throw Exception('Erro de autenticação: ${e.message}');
    }
  }

  @override
  void beforeUpdate(UsuarioModel model) {
    model.isSync = 0; 
  }

  Future<void> alterarSenha(String novaSenha) async {
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: novaSenha),
      );
    } on AuthException catch (e) {
      throw Exception('Falha ao alterar senha: ${e.message}');
    }
  }
}