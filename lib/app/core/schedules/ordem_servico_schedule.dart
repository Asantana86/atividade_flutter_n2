import '../models/ordem_servico_model.dart';
import '../providers/ordem_servico_provider.dart';
import '../repositories/ordem_servico_repository.dart';
import '../base/base_schedule.dart';

class OrdemServicoSchedule extends BaseSchedule<OrdemServicoModel, OrdemServicoRepository, OrdemServicoProvider> {
  OrdemServicoSchedule(super.repository, super.provider);

  @override
  String get featureName => 'ordens_servico';
  
  @override
  Duration get syncInterval => const Duration(minutes: 2);
}