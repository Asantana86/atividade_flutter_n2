import '../models/ordem_servico_model.dart';
import '../base/base_repository.dart';

class OrdemServicoRepository extends BaseRepository<OrdemServicoModel> {

  @override
  String get tableName => 'ordens_servico';

  @override
  OrdemServicoModel fromMap(Map<String, dynamic> map) {
    return OrdemServicoModel.fromMap(map);
  }
}