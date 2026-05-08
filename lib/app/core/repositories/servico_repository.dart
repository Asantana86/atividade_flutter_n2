import '../models/servico_model.dart';
import '../base/base_repository.dart';

class ServicoRepository extends BaseRepository<ServicoModel> {

  @override
  String get tableName => 'servicos';

  @override
  ServicoModel fromMap(Map<String, dynamic> map) {
    return ServicoModel.fromMap(map);
  }
}