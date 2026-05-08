import '../models/usuario_model.dart';
import '../base/base_repository.dart';

class UsuarioRepository extends BaseRepository<UsuarioModel> {
  @override
  String get tableName => 'usuarios';

  @override
  UsuarioModel fromMap(Map<String, dynamic> map) {
    return UsuarioModel.fromMap(map);
  }
}