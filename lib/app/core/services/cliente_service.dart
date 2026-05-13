import '../base/base_service.dart';
import '../models/cliente_model.dart';
import '../repositories/cliente_repository.dart';
import '../validations/cliente_validation.dart';

class ClienteService
    extends BaseService<ClienteModel, ClienteRepository, ClienteValidation> {
  ClienteService(super.validation, super.repository);

  @override
  ClienteModel cloneModelWithId(ClienteModel model, dynamic id) {
    return ClienteModel(
      id: id,
      createdAt: model.createdAt,
      isSync: model.isSync,
      ativo: model.ativo,
      nome: model.nome,
      documento: model.documento,
      telefone: model.telefone,
      email: model.email,
    );
  }

  @override
  void beforeUpdate(ClienteModel model) {
    model.isSync = 0;
  }
}
