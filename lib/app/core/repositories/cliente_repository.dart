import '../models/cliente_model.dart';
import 'base_repository.dart';

class ClienteRepository extends BaseRepository<ClienteModel> {

  ClienteRepository() : super('clientes');

  @override
  ClienteModel fromMap(Map<String, dynamic> map) {
    return ClienteModel.fromMap(map);
  }
}