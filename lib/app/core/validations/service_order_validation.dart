import '../models/service_order_model.dart';

class ServiceOrderValidation {
  String? validar(ServiceOrderModel os) {
    if (os.clienteId <= 0) {
      return 'Erro: Cliente inválido ou não selecionado.';
    }
    if (os.tecnicoId <= 0) {
      return 'Erro: Técnico não identificado.';
    }
    if (os.valorPecas < 0) {
      return 'Erro: O valor das peças não pode ser negativo.';
    }
    if (os.assinatura == null || os.assinatura!.isEmpty) {
      return 'Erro: A assinatura do cliente é obrigatória por lei.';
    }

    return null;
  }
}