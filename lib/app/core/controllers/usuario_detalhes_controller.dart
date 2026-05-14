import 'package:flutter/foundation.dart';

import '../base/base_controller.dart';
import '../models/usuario_model.dart';
import '../repositories/usuario_repository.dart';
import '../services/usuario_service.dart';
import '../validations/usuario_validation.dart';

class UsuarioDetalhesController
    extends
        BaseController<
          UsuarioModel,
          UsuarioRepository,
          UsuarioValidation,
          UsuarioService
        > {
  UsuarioDetalhesController(super.service, {required this.usuarioId});

  final dynamic usuarioId;
  final ValueNotifier<UsuarioModel?> _usuario = ValueNotifier(null);
  ValueNotifier<UsuarioModel?> get usuario => _usuario;

  Future<void> carregarUsuario({void Function(String)? onError}) async {
    try {
      isLoading.value = true;
      final usuarioCarregado = await service.repository.findById(usuarioId);
      if (usuarioCarregado != null) {
        _usuario.value = usuarioCarregado;
      } else {
        onError?.call('Usuário não encontrado.');
      }
    } catch (e) {
      onError?.call('Erro ao carregar usuário: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
