import '../models/servico_model.dart';
import 'base_repository.dart';

class ServicoRepository extends BaseRepository<ServicoModel> {

  ServicoRepository() : super('servicos');

  @override
  ServicoModel fromMap(Map<String, dynamic> map) {
    return ServicoModel.fromMap(map);
  }
}