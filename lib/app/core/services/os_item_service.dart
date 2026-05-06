import '../models/os_item_model.dart';
import '../repositories/os_item_repository.dart';
import '../validations/os_item_validation.dart';

class OsItemService {
  final _repository = OsItemRepository();
  final _validation = OsItemValidation();

  Future<void> adicionarItemNaOS(OsItemModel item) async {
    final erroValidacao = _validation.validar(item);
    if (erroValidacao != null) {
      throw Exception(erroValidacao);
    }

    item.isSync = false;
    await _repository.insert(item);
  }

  Future<List<OsItemModel>> buscarItensDaOS(int osId) async {
    final todosOsItens = await _repository.getAll();
    return todosOsItens.where((item) => item.osId == osId).toList();
  }
}