import 'package:flutter/foundation.dart';

import 'schedule_manager.dart';

class SyncSystemInitializer {
  
  static Future<void> initialize() async {
    debugPrint('🔄 Inicializando sistema de sincronização...');

    try {
      final scheduleManager = ScheduleManager();

      await scheduleManager.initialize();

      final status = scheduleManager.getStatus();
      debugPrint('✅ Sistema de sincronização inicializado:');
      debugPrint('   - Features: ${status['schedules_count']}');
      debugPrint('   - Registradas: ${scheduleManager.getRegisteredFeatures().join(', ')}');
    } catch (e) {
      debugPrint('❌ Erro ao inicializar sistema de sincronização: $e');
    }
  }

  static Future<void> dispose() async {
    debugPrint('🛑 Parando sistema de sincronização...');
    final scheduleManager = ScheduleManager();
    await scheduleManager.stopAll();
    debugPrint('✅ Sistema de sincronização parado');
  }

  static Future<Map<String, bool>> forceSyncAll() async {
    debugPrint('🔄 Forçando sincronização completa...');
    final scheduleManager = ScheduleManager();
    final results = await scheduleManager.syncAll();

    final successCount = results.values.where((success) => success).length;
    debugPrint('✅ Sincronização completa: $successCount/${results.length} sucessos');

    return results;
  }
}