import '../models/cliente_model.dart';
import '../providers/cliente_provider.dart';
import '../repositories/cliente_repository.dart';
import '../base/base_schedule.dart';

class ClienteSchedule extends BaseSchedule<ClienteModel, ClienteRepository, ClienteProvider> {
  ClienteSchedule(super.repository, super.provider);

  @override
  String get featureName => 'clientes';
}