import '../models/tecnico_model.dart';
import '../providers/tecnico_provider.dart';
import '../repositories/tecnico_repository.dart';
import '../base/base_schedule.dart';

class TecnicoSchedule extends BaseSchedule<TecnicoModel, TecnicoRepository, TecnicoProvider> {
  TecnicoSchedule(super.repository, super.provider);

  @override
  String get featureName => 'tecnicos';
}