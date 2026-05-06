import '../models/os_item_model.dart';

class OsItemValidation {
  String? validar(OsItemModel item) {
    if (item.osId <= 0) {
      return 'Erro: Ordem de Serviço não identificada.';
    }
    if (item.servicoId <= 0) {
      return 'Erro: Serviço não identificado no catálogo.';
    }
    if (item.precoSnapshot != null && item.precoSnapshot! < 0) {
      return 'Erro: O valor do item não pode ser negativo.';
    }

    return null;
  }
}