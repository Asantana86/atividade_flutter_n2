import 'package:flutter/material.dart';
import '../models/cliente_model.dart';
import '../services/cliente_service.dart';

class ClienteController extends ChangeNotifier {
  final _service = ClienteService();

  // ESTADOS DA TELA
  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;
  
  List<ClienteModel> clientesCadastrados = [];

  // AÇÕES DA TELA

  Future<void> salvarCliente({
    required String nome,
    required String documento,
    required String telefone,
    String? email,
  }) async {
    isLoading = true;
    errorMessage = null;
    isSuccess = false;
    notifyListeners();

    try {
      final novoCliente = ClienteModel(
        nome: nome,
        documento: documento,
        telefone: telefone,
        email: email,
      );

      await _service.salvar(novoCliente);
      
      isSuccess = true;
      await carregarClientes();
      
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarClientes() async {
    isLoading = true;
    notifyListeners();

    try {
      clientesCadastrados = await _service.buscarTodos();
    } catch (e) {
      errorMessage = 'Erro ao carregar clientes do banco local.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}