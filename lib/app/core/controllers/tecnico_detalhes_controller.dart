import 'package:flutter/foundation.dart';

import '../base/base_controller.dart';
import '../models/tecnico_model.dart';
import '../repositories/tecnico_repository.dart';
import '../services/tecnico_service.dart';
import '../validations/tecnico_validation.dart';

class TecnicoDetalhesController
    extends
        BaseController<
          TecnicoModel,
          TecnicoRepository,
          TecnicoValidation,
          TecnicoService
        > {
  TecnicoDetalhesController(super.service, {required this.tecnicoId});

  final dynamic tecnicoId;
  final ValueNotifier<TecnicoModel?> _tecnico = ValueNotifier(null);
  ValueNotifier<TecnicoModel?> get tecnico => _tecnico;

  Future<void> carregarTecnico({void Function(String)? onError}) async {
    try {
      isLoading.value = true;
      final tecnicoCarregado = await service.repository.findById(tecnicoId);
      if (tecnicoCarregado != null) {
        _tecnico.value = tecnicoCarregado;
      } else {
        onError?.call('Técnico não encontrado.');
      }
    } catch (e) {
      onError?.call('Erro ao carregar técnico: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
