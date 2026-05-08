import '../models/servico_model.dart';
import '../providers/servico_provider.dart';
import '../repositories/servico_repository.dart';
import '../base/base_schedule.dart';

class ServicoSchedule extends BaseSchedule<ServicoModel, ServicoRepository, ServicoProvider> {
  ServicoSchedule(super.repository, super.provider);

  @override
  String get featureName => 'servicos';
}