import 'package:flutter/material.dart';
import '../models/servico_model.dart';
import '../services/servico_service.dart';

class ServicoController extends ChangeNotifier {
  final _service = ServicoService();

  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;
  
  List<ServicoModel> servicosCadastrados = [];

  Future<void> salvarServico({
    required String descricao,
    required double preco,
    String? tempoEstimado,
  }) async {
    isLoading = true;
    errorMessage = null;
    isSuccess = false;
    notifyListeners();

    try {
      final novoServico = ServicoModel(
        descricao: descricao,
        preco: preco,
        tempoEstimado: tempoEstimado,
      );

      await _service.salvarServico(novoServico);
      
      isSuccess = true;
      await carregarServicos();
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarServicos() async {
    isLoading = true;
    notifyListeners();
    try {
      servicosCadastrados = await _service.buscarTodos();
    } catch (e) {
      errorMessage = 'Erro ao carregar o catálogo de serviços.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}