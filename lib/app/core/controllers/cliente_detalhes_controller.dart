import 'package:flutter/foundation.dart';

import '../base/base_controller.dart';
import '../models/cliente_model.dart';
import '../repositories/cliente_repository.dart';
import '../services/cliente_service.dart';
import '../validations/cliente_validation.dart';

class ClienteDetalhesController
    extends
        BaseController<
          ClienteModel,
          ClienteRepository,
          ClienteValidation,
          ClienteService
        > {
  ClienteDetalhesController(super.service, {required this.clienteId});

  final dynamic clienteId;
  final ValueNotifier<ClienteModel?> _cliente = ValueNotifier(null);
  ValueNotifier<ClienteModel?> get cliente => _cliente;

  Future<void> carregarCliente({void Function(String)? onError}) async {
    try {
      isLoading.value = true;
      final clienteCarregado = await service.repository.findById(clienteId);
      if (clienteCarregado != null) {
        _cliente.value = clienteCarregado;
      } else {
        onError?.call('Cliente não encontrado.');
      }
    } catch (e) {
      onError?.call('Erro ao carregar cliente: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
