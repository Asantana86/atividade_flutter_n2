import '../base/base.validation.dart';
import '../models/servico_model.dart';
import '../repositories/servico_repository.dart';

class ServicoValidation extends BaseValidation<ServicoModel, ServicoRepository> {
  ServicoValidation(super.repository);

  @override
  void validateFields(ServicoModel? model) {
    super.validateFields(model);
    final servico = model!;

    if (servico.descricao.trim().isEmpty) {
      throw Exception("A descrição do serviço é obrigatória.");
    }

    if (servico.preco < 0) {
      throw Exception("O preço do serviço não pode ser negativo.");
    }
  }

  @override
  Future<void> validateRulesCreate(ServicoModel model) async {
    
  }

  @override
  Future<void> validateRulesUpdate(ServicoModel model) async {
    
  }
}