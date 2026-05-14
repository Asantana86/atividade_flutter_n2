import 'package:flutter/foundation.dart';

import '../models/ordem_servico_model.dart';
import '../models/cliente_model.dart';
import '../models/tecnico_model.dart';
import '../models/servico_model.dart';
import '../services/ordem_servico_service.dart';
import '../services/cliente_service.dart';
import '../services/tecnico_service.dart';
import '../services/servico_service.dart';

class OrdemServicoDetalhesController {
  OrdemServicoDetalhesController({
    required this.ordemServicoId,
    required this.ordemServicoService,
    required this.clienteService,
    required this.tecnicoService,
    required this.servicoService,
  });

  final dynamic ordemServicoId;
  final OrdemServicoService ordemServicoService;
  final ClienteService clienteService;
  final TecnicoService tecnicoService;
  final ServicoService servicoService;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final ValueNotifier<OrdemServicoModel?> _ordemServico = ValueNotifier(null);
  ValueNotifier<OrdemServicoModel?> get ordemServico => _ordemServico;

  final ValueNotifier<ClienteModel?> _cliente = ValueNotifier(null);
  ValueNotifier<ClienteModel?> get cliente => _cliente;

  final ValueNotifier<TecnicoModel?> _tecnico = ValueNotifier(null);
  ValueNotifier<TecnicoModel?> get tecnico => _tecnico;

  final ValueNotifier<ServicoModel?> _servico = ValueNotifier(null);
  ValueNotifier<ServicoModel?> get servico => _servico;

  Future<void> carregarOrdemServico({void Function(String)? onError}) async {
    try {
      isLoading.value = true;
      final ordemServicoCarregada = await ordemServicoService.repository
          .findById(ordemServicoId);
      if (ordemServicoCarregada != null) {
        _ordemServico.value = ordemServicoCarregada;

        // Carregar dados relacionados
        try {
          final clienteCarregado = await clienteService.repository.findById(
            ordemServicoCarregada.clienteId,
          );
          _cliente.value = clienteCarregado;

          final tecnicoCarregado = await tecnicoService.repository.findById(
            ordemServicoCarregada.tecnicoId,
          );
          _tecnico.value = tecnicoCarregado;

          final servicoCarregado = await servicoService.repository.findById(
            ordemServicoCarregada.servicoId,
          );
          _servico.value = servicoCarregado;
        } catch (e) {
          // Se não conseguir carregar relacionados, continua sem erro
          debugPrint('Erro ao carregar dados relacionados: $e');
        }
      } else {
        onError?.call('Ordem de serviço não encontrada.');
      }
    } catch (e) {
      onError?.call('Erro ao carregar ordem de serviço: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    isLoading.dispose();
    _ordemServico.dispose();
    _cliente.dispose();
    _tecnico.dispose();
    _servico.dispose();
  }
}
