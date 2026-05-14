import 'package:flutter/foundation.dart';

import '../base/base_controller.dart';
import '../models/servico_model.dart';
import '../repositories/servico_repository.dart';
import '../services/servico_service.dart';
import '../validations/servico_validation.dart';

class ServicoDetalhesController
    extends
        BaseController<
          ServicoModel,
          ServicoRepository,
          ServicoValidation,
          ServicoService
        > {
  ServicoDetalhesController(super.service, {required this.servicoId});

  final dynamic servicoId;
  final ValueNotifier<ServicoModel?> _servico = ValueNotifier(null);
  ValueNotifier<ServicoModel?> get servico => _servico;

  Future<void> carregarServico({void Function(String)? onError}) async {
    try {
      isLoading.value = true;
      final servicoCarregado = await service.repository.findById(servicoId);
      if (servicoCarregado != null) {
        _servico.value = servicoCarregado;
      } else {
        onError?.call('Serviço não encontrado.');
      }
    } catch (e) {
      onError?.call('Erro ao carregar serviço: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
