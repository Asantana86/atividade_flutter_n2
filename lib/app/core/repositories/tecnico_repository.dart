import '../models/tecnico_model.dart';
import '../base/base_repository.dart';

class TecnicoRepository extends BaseRepository<TecnicoModel> {

  @override
  String get tableName => 'tecnicos';

  @override
  TecnicoModel fromMap(Map<String, dynamic> map) {
    return TecnicoModel.fromMap(map);
  }
}