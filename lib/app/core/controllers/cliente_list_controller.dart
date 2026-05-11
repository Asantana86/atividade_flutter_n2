import 'package:flutter/foundation.dart';

import '../base/base_controller.dart';
import '../models/cliente_model.dart';
import '../repositories/cliente_repository.dart';
import '../services/cliente_service.dart';
import '../validations/cliente_validation.dart';

class ClienteListController extends BaseController<
    ClienteModel,
    ClienteRepository,
    ClienteValidation,
    ClienteService> {
      

  final ValueNotifier<List<ClienteModel>> clientes = ValueNotifier([]);

  ClienteListController(super.service);

  @override
  void dispose() {
    clientes.dispose();
    super.dispose();
  }

  Future<void> carregarClientes({void Function(String)? onError}) async {
    final result = await executeListOperation(
      service.findAllActive(),
      onError: onError,
    );
    
    clientes.value = result;
  }

  Future<bool> excluirCliente(
    int id, {
    void Function(String)? onSuccess,
    void Function(String)? onError,
  }) async {
    final success = await executeCrudOperation(
      service.softDelete(id),
      onSuccess: onSuccess,
      onError: onError,
      successMessage: 'Cliente excluído com sucesso!',
    );

    if (success) {
      await carregarClientes(onError: onError);
    }
    
    return success;
  }
}