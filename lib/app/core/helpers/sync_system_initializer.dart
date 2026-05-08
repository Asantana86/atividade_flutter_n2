import 'schedule_manager.dart';

class SyncSystemInitializer {
  
  static Future<void> initialize() async {
    print('🔄 Inicializando sistema de sincronização...');

    try {
      final scheduleManager = ScheduleManager();

      await scheduleManager.initialize();

      final status = scheduleManager.getStatus();
      print('✅ Sistema de sincronização inicializado:');
      print('   - Features: ${status['schedules_count']}');
      print('   - Registradas: ${scheduleManager.getRegisteredFeatures().join(', ')}');
    } catch (e) {
      print('❌ Erro ao inicializar sistema de sincronização: $e');
    }
  }

  static Future<void> dispose() async {
    print('🛑 Parando sistema de sincronização...');
    final scheduleManager = ScheduleManager();
    await scheduleManager.stopAll();
    print('✅ Sistema de sincronização parado');
  }

  static Future<Map<String, bool>> forceSyncAll() async {
    print('🔄 Forçando sincronização completa...');
    final scheduleManager = ScheduleManager();
    final results = await scheduleManager.syncAll();

    final successCount = results.values.where((success) => success).length;
    print('✅ Sincronização completa: $successCount/${results.length} sucessos');

    return results;
  }
}