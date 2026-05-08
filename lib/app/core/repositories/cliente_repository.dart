import '../models/cliente_model.dart';
import '../base/base_repository.dart';

class ClienteRepository extends BaseRepository<ClienteModel> {

  @override
  String get tableName => 'clientes';

  @override
  ClienteModel fromMap(Map<String, dynamic> map) {
    return ClienteModel.fromMap(map);
  }
}