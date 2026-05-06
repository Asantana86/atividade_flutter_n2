import 'package:connectivity_plus/connectivity_plus.dart';
import '../repositories/ordem_servico_repository.dart';
import '../providers/supabase_provider.dart';

class AgendadorWorker {
  static final AgendadorWorker _instance = AgendadorWorker._internal();
  factory AgendadorWorker() => _instance;
  AgendadorWorker._internal();

  final _osRepo = OrdemServicoRepository();
  final _provider = SupabaseProvider();

  void iniciar() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!results.contains(ConnectivityResult.none)) {
        executarSincronizacao();
      }
    });
  }

  Future<void> executarSincronizacao() async {
    try {
      final pendentes = await _osRepo.getUnsyncedOrders();

      for (var os in pendentes) {
        final json = os.toMap();
        json.remove('id');
        json.remove('is_sync');

        await _provider.inserir('ordens_servico', json);

        os.isSync = true;
        await _osRepo.update(os);
      }
    } catch (e) {
      print('Falha no agendador: $e');
    }
  }
}