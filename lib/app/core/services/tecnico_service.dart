import '../base/base_service.dart';
import '../models/tecnico_model.dart';
import '../repositories/tecnico_repository.dart';
import '../validations/tecnico_validation.dart';

class TecnicoService
    extends BaseService<TecnicoModel, TecnicoRepository, TecnicoValidation> {
  TecnicoService(super.validation, super.repository);

  @override
  TecnicoModel cloneModelWithId(TecnicoModel model, int id) {
    return TecnicoModel(
      id: id,
      createdAt: model.createdAt,
      isSync: model.isSync,
      ativo: model.ativo,
      nome: model.nome,
      especialidade: model.especialidade,
    );
  }

  @override
  void beforeUpdate(TecnicoModel model) {
    model.isSync = 0;
  }
}
