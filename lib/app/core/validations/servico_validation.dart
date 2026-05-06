import '../models/servico_model.dart';

class ServicoValidation {

  String? validar(ServicoModel servico) {
    if (servico.descricao.trim().isEmpty) {
      return 'A descrição do serviço é obrigatória.';
    }
    
    if (servico.preco < 0) {
      return 'O preço do serviço não pode ser negativo.';
    }

    return null;
  }
}