import '../models/tecnico_model.dart';
import 'base_repository.dart';

class TecnicoRepository extends BaseRepository<TecnicoModel> {

  TecnicoRepository() : super('tecnicos');

  @override
  TecnicoModel fromMap(Map<String, dynamic> map) {
    return TecnicoModel.fromMap(map);
  }
}