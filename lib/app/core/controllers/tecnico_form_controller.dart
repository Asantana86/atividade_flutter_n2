import '../base/base_controller.dart';
import '../models/tecnico_model.dart';
import '../repositories/tecnico_repository.dart';
import '../services/tecnico_service.dart';
import '../validations/tecnico_validation.dart';

class TecnicoFormController extends BaseController<
    TecnicoModel,
    TecnicoRepository,
    TecnicoValidation,
    TecnicoService> {
      
  TecnicoFormController(super.service, {super.model});

  bool get isEditing => model != null;

  Future<bool> salvarTecnico({
    required String nome,
    required String especialidade,
    void Function(String)? onSuccess,
    void Function(String)? onError,
  }) async {
    
    final tecnico = TecnicoModel(
      id: model?.id,
      createdAt: model?.createdAt,
      isSync: model?.isSync ?? 0,
      ativo: model?.ativo ?? true,
      nome: nome.trim(),
      especialidade: especialidade.trim().isEmpty ? null : especialidade.trim(),
    );

    final operation = isEditing 
        ? service.update(tecnico) 
        : service.create(tecnico);

    return await executeCrudOperation(
      operation,
      onSuccess: onSuccess,
      onError: onError,
      successMessage: isEditing ? 'Técnico atualizado com sucesso!' : 'Técnico salvo com sucesso!',
    );
  }
}