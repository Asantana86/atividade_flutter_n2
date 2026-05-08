import '../base/base.service.dart';
import '../models/usuario_model.dart';
import '../repositories/usuario_repository.dart';
import '../validations/usuario_validation.dart';

class UsuarioService extends BaseService<UsuarioModel, UsuarioRepository, UsuarioValidation> {
  
  UsuarioService(super.validation, super.repository);

  @override
  UsuarioModel cloneModelWithId(UsuarioModel model, int id) {
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
  void beforeCreate(UsuarioModel model) {
    // model.senha = CriptografiaHelper.gerarHash(model.senha);
  }

  @override
  void beforeUpdate(UsuarioModel model) {

    model.isSync = 0;

    // Se a senha foi alterada na tela de edição, faremos o hash dela aqui também.
  }
}