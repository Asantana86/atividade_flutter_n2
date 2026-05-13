import '../base/base_controller.dart';
import '../models/usuario_model.dart';
import '../repositories/usuario_repository.dart';
import '../services/usuario_service.dart';
import '../validations/usuario_validation.dart';

class UsuarioFormController extends BaseController<
    UsuarioModel,
    UsuarioRepository,
    UsuarioValidation,
    UsuarioService> {
      
  UsuarioFormController(super.service, {super.model});

  bool get isEditing => model != null;

  Future<bool> salvarUsuario({
    required String nome,
    required String email,
    required String senha,
    void Function(String)? onSuccess,
    void Function(String)? onError,
  }) async {
    
    if (isEditing && senha.isNotEmpty) {
      try {
        await service.alterarSenha(senha);
      } catch (e) {
        // Se a alteração de senha falhar (ex: sem internet), aborta a gravação
        onError?.call(e.toString());
        return false;
      }
    }

    final usuario = UsuarioModel(
      id: model?.id,
      createdAt: model?.createdAt,
      isSync: model?.isSync ?? 0,
      ativo: model?.ativo ?? true,
      nome: nome.trim(),
      email: email.trim(),
      senha: senha,
    );

    final operation = isEditing 
        ? service.update(usuario) 
        : service.create(usuario);

    return await executeCrudOperation(
      operation,
      onSuccess: onSuccess,
      onError: onError,
      successMessage: isEditing ? 'Usuário atualizado com sucesso!' : 'Usuário criado com sucesso!',
    );
  }
}