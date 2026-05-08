import 'package:flutter/material.dart';
import '../models/ordem_servico_model.dart';
import '../services/service_order_service.dart';

class ServiceOrderController extends ChangeNotifier {
  final _service = OrdemServicoService();

  // ESTADOS DA TELA
  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;
  
  List<OrdemServicoModel> ordensCadastradas = [];

  // AÇÕES DA TELA

  Future<void> salvarOrdemServico({
    required int clienteId,
    required int tecnicoId,
    String? observacao,
    String? pecasAplicadas,
    double valorPecas = 0.0,
    String? fotoAntes,
    String? fotoDepois,
    String? assinatura,
  }) async {
    isLoading = true;
    errorMessage = null;
    isSuccess = false;
    notifyListeners();

    try {
      final novaOS = OrdemServicoModel(
        clienteId: clienteId,
        tecnicoId: tecnicoId,
        observacao: observacao,
        pecasAplicadas: pecasAplicadas,
        valorPecas: valorPecas,
        fotoAntes: fotoAntes,
        fotoDepois: fotoDepois,
        assinatura: assinatura,
      );

      // Manda para o Service [S]
      await _service.salvarNovaOS(novaOS);
      
      isSuccess = true;
      await carregarOrdens();
      
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> finalizarOrdemServico({
    required OrdemServicoModel ordem,
    String? fotoDepois,
    required String assinatura,
  }) async {
    isLoading = true;
    errorMessage = null;
    isSuccess = false;
    notifyListeners();

    try {
      ordem.fotoDepois = fotoDepois;
      ordem.assinatura = assinatura;
      ordem.status = 'Executada';
      
      await _service.atualizarOS(ordem);
      
      isSuccess = true;
      await carregarOrdens(); 
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarOrdens() async {
    isLoading = true;
    notifyListeners();

    try {
      ordensCadastradas = await _service.buscarTodasOS();
    } catch (e) {
      errorMessage = 'Erro ao carregar as Ordens de Serviço.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}