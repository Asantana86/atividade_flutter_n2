import '../base/base_validation.dart';
import '../models/ordem_servico_model.dart';
import '../repositories/ordem_servico_repository.dart';

class OrdemServicoValidation
    extends BaseValidation<OrdemServicoModel, OrdemServicoRepository> {
  OrdemServicoValidation(super.repository);

  @override
  void validateFields(OrdemServicoModel? model) {
    super.validateFields(model);
    final os = model!;

    if (os.clienteId <= 0) throw Exception("Cliente inválido.");
    if (os.tecnicoId <= 0) throw Exception("Técnico inválido.");
    if (os.servicoId <= 0) throw Exception("Serviço inválido.");

    if (os.fotoAntes.trim().isEmpty) {
      throw Exception("A foto inicial (Antes) é obrigatória.");
    }

    final limiteFuturo = DateTime.now().add(const Duration(minutes: 1));
    if (os.dataInicio.isAfter(limiteFuturo)) {
      throw Exception("A data de início não pode ser uma data futura.");
    }
  }

  @override
  Future<void> validateFieldUpdate(OrdemServicoModel model) async {
    await super.validateFieldUpdate(model);

    if (model.status == StatusOS.finalizado) {
      if (model.dataFim == null) {
        throw Exception("A data de término é obrigatória para finalizar a OS.");
      }
      if (model.dataFim!.isBefore(model.dataInicio)) {
        throw Exception(
          "A data de término não pode ser menor que a data de início.",
        );
      }

      if (model.fotoDepois == null || model.fotoDepois!.trim().isEmpty) {
        throw Exception(
          "A foto final (Depois) é obrigatória para finalizar a OS.",
        );
      }

      if (model.assinatura == null || model.assinatura!.trim().isEmpty) {
        throw Exception(
          "A assinatura do cliente é obrigatória para finalizar a OS.",
        );
      }
    }
  }

  @override
  Future<void> validateRulesCreate(OrdemServicoModel model) async {}

  @override
  Future<void> validateRulesUpdate(OrdemServicoModel model) async {}
}
