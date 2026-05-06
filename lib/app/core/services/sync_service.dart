import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/ordem_servico_repository.dart';

class SyncService {

  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final _supabase = Supabase.instance.client;
  final _osRepo = OrdemServicoRepository();

  void initialize() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!results.contains(ConnectivityResult.none)) {
        _syncData();
      }
    });
  }

  Future<void> _syncData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) return;

    print('📡 Conexão detectada! Iniciando sincronização em background...');
    await _syncOrdensServico();
    
    // Futuramente adicionar _syncClientes(), _syncTecnicos(), etc.
  }

  Future<void> _syncOrdensServico() async {
    try {
      final unsyncedOrders = await _osRepo.getUnsyncedOrders();

      if (unsyncedOrders.isEmpty) {
        print('✅ Nenhuma Ordem de Serviço pendente de sincronização.');
        return;
      }

      for (var os in unsyncedOrders) {
        final mapToUpload = os.toMap();
        
        mapToUpload.remove('id');
        mapToUpload.remove('is_sync');

        await _supabase.from('ordens_servico').insert(mapToUpload);

        os.isSync = true;
        await _osRepo.update(os);
        
        print('🚀 OS (Cliente ID: ${os.clienteId}) sincronizada com sucesso no Supabase!');
      }
    } catch (e) {
      print('❌ Erro ao sincronizar Ordens de Serviço: $e');
    }
  }
}