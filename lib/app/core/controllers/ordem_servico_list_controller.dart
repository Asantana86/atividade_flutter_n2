import 'package:flutter/foundation.dart';

import '../base/base_controller.dart';
import '../models/ordem_servico_model.dart';
import '../repositories/ordem_servico_repository.dart';
import '../services/cliente_service.dart';
import '../services/ordem_servico_service.dart';
import '../services/servico_service.dart';
import '../services/tecnico_service.dart';
import '../validations/ordem_servico_validation.dart';

class OrdemServicoListController extends BaseController<
    OrdemServicoModel,
    OrdemServicoRepository,
    OrdemServicoValidation,
    OrdemServicoService> {
      
  final ClienteService clienteService;
  final TecnicoService tecnicoService;
  final ServicoService servicoService;

  // Estado reativo das OS
  final ValueNotifier<List<OrdemServicoModel>> ordens = ValueNotifier([]);

  OrdemServicoListController(
    super.service, {
    required this.clienteService,
    required this.tecnicoService,
    required this.servicoService,
  });

  @override
  void dispose() {
    ordens.dispose();
    super.dispose();
  }

  /// Carrega OS conforme a aba: Canceladas usa inativas+status; demais só ativos.
  Future<void> carregarOrdens({
    StatusOS? abaStatus,
    void Function(String)? onError,
  }) async {
    final result = await executeListOperation(
      abaStatus == StatusOS.cancelado
          ? service.findCanceladas()
          : service.findAllActive(),
      onError: onError,
    );

    ordens.value = result;
  }

  /// Cancela uma OS
  Future<bool> cancelarOS(
    int id, {
    StatusOS? abaStatus,
    void Function(String)? onSuccess,
    void Function(String)? onError,
  }) async {
    final success = await executeCrudOperation(
      service.softDelete(id),
      onSuccess: onSuccess,
      onError: onError,
      successMessage: 'Ordem de serviço cancelada com sucesso.',
    );

    if (success) {
      await carregarOrdens(abaStatus: abaStatus, onError: onError);
    }

    return success;
  }
}