import '../base/base_validation.dart';
import '../models/usuario_model.dart';
import '../repositories/usuario_repository.dart';

class UsuarioValidation extends BaseValidation<UsuarioModel, UsuarioRepository> {
  UsuarioValidation(super.repository);

  @override
  void validateFields(UsuarioModel? model) {
    super.validateFields(model);

    final usuario = model!;

    if (usuario.nome.trim().isEmpty) {
      throw Exception("O nome do usuário é obrigatório.");
    }

    if (usuario.email.trim().isEmpty) {
      throw Exception("O e-mail é obrigatório.");
    }

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(usuario.email)) {
      throw Exception("Informe um e-mail válido.");
    }

    if (usuario.id == null || (usuario.senha != null && usuario.senha!.isNotEmpty)) {
      if (usuario.senha == null || usuario.senha!.trim().isEmpty) {
        throw Exception("A senha é obrigatória.");
      }
      if (usuario.senha!.length <= 7) {
        throw Exception("A senha não pode ser menor ou igual a 7 caracteres.");
      }
      if (!RegExp(r'[A-Z]').hasMatch(usuario.senha!)) {
        throw Exception("A senha deve conter ao menos uma letra maiúscula.");
      }
      if (!RegExp(r'[0-9]').hasMatch(usuario.senha!)) {
        throw Exception("A senha deve conter ao menos um número.");
      }
      if (!RegExp(r'[!@#\$&*~_.,;^%]').hasMatch(usuario.senha!)) {
        throw Exception("A senha deve conter ao menos um caractere especial.");
      }
    }
  }

  @override
  Future<void> validateRulesCreate(UsuarioModel model) async {
    final emailExiste = await repository.exists("email = ?", [model.email]);

    if (emailExiste) {
      throw Exception("Já existe um usuário cadastrado com este e-mail localmente.");
    }
  }

  @override
  Future<void> validateRulesUpdate(UsuarioModel model) async {
    final emailExiste = await repository.exists("email = ? AND id != ?", [
      model.email,
      model.id,
    ]);

    if (emailExiste) {
      throw Exception("Este e-mail já está sendo utilizado por outro usuário.");
    }
  }
}