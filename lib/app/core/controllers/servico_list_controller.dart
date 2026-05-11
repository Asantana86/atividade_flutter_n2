import 'package:flutter/foundation.dart';

import '../base/base_controller.dart';
import '../models/servico_model.dart';
import '../repositories/servico_repository.dart';
import '../services/servico_service.dart';
import '../validations/servico_validation.dart';

class ServicoListController extends BaseController<
    ServicoModel,
    ServicoRepository,
    ServicoValidation,
    ServicoService> {
      
  final ValueNotifier<List<ServicoModel>> servicos = ValueNotifier([]);

  ServicoListController(super.service);

  @override
  void dispose() {
    servicos.dispose();
    super.dispose();
  }

  Future<void> carregarServicos({void Function(String)? onError}) async {
    final result = await executeListOperation(
      service.findAllActive(),
      onError: onError,
    );
    
    servicos.value = result;
  }

  Future<bool> excluirServico(
    int id, {
    void Function(String)? onSuccess,
    void Function(String)? onError,
  }) async {
    final success = await executeCrudOperation(
      service.softDelete(id),
      onSuccess: onSuccess,
      onError: onError,
      successMessage: 'Serviço removido com sucesso!',
    );

    if (success) {
      await carregarServicos(onError: onError);
    }
    
    return success;
  }
}