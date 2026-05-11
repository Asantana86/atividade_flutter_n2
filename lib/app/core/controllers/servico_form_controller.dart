import '../base/base_controller.dart';
import '../models/servico_model.dart';
import '../repositories/servico_repository.dart';
import '../services/servico_service.dart';
import '../validations/servico_validation.dart';

class ServicoFormController extends BaseController<
    ServicoModel,
    ServicoRepository,
    ServicoValidation,
    ServicoService> {
      
  ServicoFormController(super.service, {super.model});

  bool get isEditing => model != null;

  Future<bool> salvarServico({
    required String descricao,
    required String precoStr,
    required String tempoEstimado,
    void Function(String)? onSuccess,
    void Function(String)? onError,
  }) async {
    
    final precoDouble = double.tryParse(precoStr.replaceAll(',', '.')) ?? 0.0;

    final servico = ServicoModel(
      id: model?.id,
      createdAt: model?.createdAt,
      isSync: model?.isSync ?? 0,
      ativo: model?.ativo ?? true,
      descricao: descricao.trim(),
      preco: precoDouble,
      tempoEstimado: tempoEstimado.trim().isEmpty ? null : tempoEstimado.trim(),
    );

    final operation = isEditing 
        ? service.update(servico) 
        : service.create(servico);

    return await executeCrudOperation(
      operation,
      onSuccess: onSuccess,
      onError: onError,
      successMessage: 'Serviço gravado com sucesso!',
    );
  }
}