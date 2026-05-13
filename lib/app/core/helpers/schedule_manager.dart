import 'package:flutter/foundation.dart';

import '../providers/cliente_provider.dart';
import '../providers/ordem_servico_provider.dart';
import '../providers/servico_provider.dart';
import '../providers/tecnico_provider.dart';
import '../providers/usuario_provider.dart';

import '../repositories/cliente_repository.dart';
import '../repositories/ordem_servico_repository.dart';
import '../repositories/servico_repository.dart';
import '../repositories/tecnico_repository.dart';
import '../repositories/usuario_repository.dart';
import '../schedules/cliente_schedule.dart';
import '../schedules/ordem_servico_schedule.dart';
import '../schedules/servico_schedule.dart';
import '../schedules/tecnico_schedule.dart';
import '../schedules/usuario_schedule.dart';

/// Gerenciador central de schedules
class ScheduleManager {
  static final ScheduleManager _instance = ScheduleManager._init();
  factory ScheduleManager() => _instance;
  ScheduleManager._init();

  final List<dynamic> _schedules = [];
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      _log('ScheduleManager já inicializado');
      return;
    }

    _log('Inicializando ScheduleManager...');

    await _autoRegisterSchedules();

    for (final schedule in _schedules) {
      try {
        await schedule.start();
        _log('Schedule ${schedule.featureName} iniciado');
      } catch (e) {
        _log('Erro ao iniciar schedule ${schedule.featureName}: $e');
      }
    }

    _isInitialized = true;
    _log('ScheduleManager inicializado com ${_schedules.length} schedules');
  }

  Future<void> stopAll() async {
    _log('Parando todos os schedules...');

    for (final schedule in _schedules) {
      try {
        schedule.stop();
        _log('Schedule ${schedule.featureName} parado');
      } catch (e) {
        _log('Erro ao parar schedule ${schedule.featureName}: $e');
      }
    }

    _schedules.clear();
    _isInitialized = false;
    _log('Todos os schedules foram parados');
  }

  Future<Map<String, bool>> syncAll() async {
    _log('Iniciando sincronização forçada de todos os schedules...');
    final results = <String, bool>{};

    for (final schedule in _schedules) {
      try {
        final success = await schedule.syncNow();
        results[schedule.featureName] = success;
        _log('Sync ${schedule.featureName}: ${success ? 'SUCCESS' : 'FAILED'}');
      } catch (e) {
        results[schedule.featureName] = false;
        _log('Erro no sync ${schedule.featureName}: $e');
      }
    }

    final successCount = results.values.where((success) => success).length;
    _log('Sync completo: $successCount/${results.length} sucessos');

    return results;
  }

  Future<bool> syncFeature(String featureName) async {
    final schedule = _schedules.where((s) => s.featureName == featureName).firstOrNull;

    if (schedule == null) {
      _log('Schedule não encontrado: $featureName');
      return false;
    }

    _log('Iniciando sync específico: $featureName');

    try {
      final success = await schedule.syncNow();
      _log('Sync $featureName: ${success ? 'SUCCESS' : 'FAILED'}');
      return success;
    } catch (e) {
      _log('Erro no sync $featureName: $e');
      return false;
    }
  }

  void registerSchedule(dynamic schedule) {
    final existing = _schedules.where((s) => s.featureName == schedule.featureName).firstOrNull;

    if (existing != null) {
      _log('Schedule ${schedule.featureName} já registrado, substituindo...');
      existing.dispose();
      _schedules.remove(existing);
    }

    _schedules.add(schedule);
    _log('Schedule ${schedule.featureName} registrado');

    if (_isInitialized) {
      schedule.start().catchError((e) {
        _log('Erro ao iniciar schedule ${schedule.featureName}: $e');
      });
    }
  }

  /// ✅ Correção Principal: Instanciando e registrando os schedules com as suas dependências
  Future<void> _autoRegisterSchedules() async {
    _schedules.addAll([
      UsuarioSchedule(UsuarioRepository(), UsuarioProvider()),
      ClienteSchedule(ClienteRepository(), ClienteProvider()),
      TecnicoSchedule(TecnicoRepository(), TecnicoProvider()),
      ServicoSchedule(ServicoRepository(), ServicoProvider()),
      OrdemServicoSchedule(OrdemServicoRepository(), OrdemServicoProvider()),
    ]);

    _log('${_schedules.length} schedules auto-registrados');
  }

  Map<String, dynamic> getStatus() {
    return {
      'initialized': _isInitialized,
      'schedules_count': _schedules.length,
      'schedules': _schedules.map((s) => {
        'feature': s.featureName,
        'interval': s.syncInterval.inMinutes,
      }).toList(),
    };
  }

  List<String> getRegisteredFeatures() {
    return _schedules.map((s) => s.featureName as String).toList();
  }

  void dispose() {
    stopAll();
  }

  void _log(String message) {
    debugPrint('[${DateTime.now()}] [SCHEDULE_MANAGER] $message');
  }
}

// O ListExtension pode ser omitido se você estiver usando uma versão recente do Dart (Dart 3+ já tem firstOrNull nativo), mas mantive por segurança.
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}