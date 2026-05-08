import '../models/usuario_model.dart';
import '../providers/usuario_provider.dart';
import '../repositories/usuario_repository.dart';
import '../base/base_schedule.dart';

class UsuarioSchedule extends BaseSchedule<UsuarioModel, UsuarioRepository, UsuarioProvider> {
  UsuarioSchedule(super.repository, super.provider);

  @override
  String get featureName => 'usuarios';

  @override
  Duration get syncInterval => const Duration(hours: 1);
}