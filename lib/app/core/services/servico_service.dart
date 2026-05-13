import '../base/base_service.dart';
import '../models/servico_model.dart';
import '../repositories/servico_repository.dart';
import '../validations/servico_validation.dart';

class ServicoService
    extends BaseService<ServicoModel, ServicoRepository, ServicoValidation> {
  ServicoService(super.validation, super.repository);

  @override
  ServicoModel cloneModelWithId(ServicoModel model, dynamic id) {
    return ServicoModel(
      id: id,
      createdAt: model.createdAt,
      isSync: model.isSync,
      ativo: model.ativo,
      descricao: model.descricao,
      preco: model.preco,
      tempoEstimado: model.tempoEstimado,
    );
  }

  @override
  void beforeUpdate(ServicoModel model) {
    model.isSync = 0;
  }
}
