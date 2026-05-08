import '../base/base.validation.dart';
import '../models/tecnico_model.dart';
import '../repositories/tecnico_repository.dart';

class TecnicoValidation extends BaseValidation<TecnicoModel, TecnicoRepository> {
  TecnicoValidation(super.repository);

  @override
  void validateFields(TecnicoModel? model) {
    super.validateFields(model);
    final tecnico = model!;

    if (tecnico.nome.trim().isEmpty) {
      throw Exception("O nome do técnico é obrigatório.");
    }
  }

  @override
  Future<void> validateRulesCreate(TecnicoModel model) async {
    
  }

  @override
  Future<void> validateRulesUpdate(TecnicoModel model) async {
    
  }
}