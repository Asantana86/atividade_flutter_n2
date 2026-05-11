import '../base/base_controller.dart';
import '../models/cliente_model.dart';
import '../repositories/cliente_repository.dart';
import '../services/cliente_service.dart';
import '../validations/cliente_validation.dart';

class ClienteFormController extends BaseController<
    ClienteModel,
    ClienteRepository,
    ClienteValidation,
    ClienteService> {
      
  ClienteFormController(super.service, {super.model});

  bool get isEditing => model != null;

  Future<bool> salvarCliente({
    required String nome,
    required String documento,
    required String telefone,
    required String email,
    void Function(String)? onSuccess,
    void Function(String)? onError,
  }) async {
    
    final cliente = ClienteModel(
      id: model?.id,
      createdAt: model?.createdAt,
      isSync: model?.isSync ?? 0,
      ativo: model?.ativo ?? true,
      nome: nome.trim(),
      documento: documento.trim(),
      telefone: telefone.trim(),
      email: email.trim().isEmpty ? null : email.trim(),
    );

    final operation = isEditing 
        ? service.update(cliente) 
        : service.create(cliente);

    return await executeCrudOperation(
      operation,
      onSuccess: onSuccess,
      onError: onError,
      successMessage: isEditing ? 'Cliente atualizado com sucesso!' : 'Cliente salvo com sucesso!',
    );
  }
}