import 'package:flutter/foundation.dart';

import '../base/base_controller.dart';
import '../models/tecnico_model.dart';
import '../repositories/tecnico_repository.dart';
import '../services/tecnico_service.dart';
import '../validations/tecnico_validation.dart';

class TecnicoListController extends BaseController<
    TecnicoModel,
    TecnicoRepository,
    TecnicoValidation,
    TecnicoService> {
      
  final ValueNotifier<List<TecnicoModel>> tecnicos = ValueNotifier([]);

  TecnicoListController(super.service);

  @override
  void dispose() {
    tecnicos.dispose();
    super.dispose();
  }

  Future<void> carregarTecnicos({void Function(String)? onError}) async {
    final result = await executeListOperation(
      service.findAllActive(),
      onError: onError,
    );
    
    tecnicos.value = result;
  }

  Future<bool> excluirTecnico(
    int id, {
    void Function(String)? onSuccess,
    void Function(String)? onError,
  }) async {
    final success = await executeCrudOperation(
      service.softDelete(id),
      onSuccess: onSuccess,
      onError: onError,
      successMessage: 'Técnico excluído com sucesso!',
    );

    if (success) {
      await carregarTecnicos(onError: onError);
    }
    
    return success;
  }
}