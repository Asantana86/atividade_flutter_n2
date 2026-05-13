import 'package:flutter/foundation.dart';

import '../base/base_controller.dart';
import '../models/usuario_model.dart';
import '../repositories/usuario_repository.dart';
import '../services/usuario_service.dart';
import '../validations/usuario_validation.dart';

class UsuarioListController extends BaseController<
    UsuarioModel,
    UsuarioRepository,
    UsuarioValidation,
    UsuarioService> {
      
  final ValueNotifier<List<UsuarioModel>> usuarios = ValueNotifier([]);

  UsuarioListController(super.service);

  @override
  void dispose() {
    usuarios.dispose();
    super.dispose();
  }

  Future<void> carregarUsuarios({void Function(String)? onError}) async {
    final result = await executeListOperation(
      service.findAllActive(),
      onError: onError,
    );
    
    usuarios.value = result;
  }

  Future<bool> excluirUsuario(
    dynamic id, { // dynamic para aceitar o UUID
    void Function(String)? onSuccess,
    void Function(String)? onError,
  }) async {
    final success = await executeCrudOperation(
      service.softDelete(id),
      onSuccess: onSuccess,
      onError: onError,
      successMessage: 'Usuário excluído com sucesso!',
    );

    if (success) {
      await carregarUsuarios(onError: onError);
    }
    
    return success;
  }
}