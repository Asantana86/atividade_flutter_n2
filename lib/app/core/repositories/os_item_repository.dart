import '../models/os_item_model.dart';
import 'base_repository.dart';

class OsItemRepository extends BaseRepository<OsItemModel> {

  OsItemRepository() : super('os_itens');

  @override
  OsItemModel fromMap(Map<String, dynamic> map) {
    return OsItemModel.fromMap(map);
  }
}