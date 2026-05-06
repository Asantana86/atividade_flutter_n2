import 'package:flutter/material.dart';
import '../models/tecnico_model.dart';
import '../services/tecnico_service.dart';

class TecnicoController extends ChangeNotifier {
  final _service = TecnicoService();

  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;
  
  List<TecnicoModel> tecnicosCadastrados = [];

  Future<void> salvarTecnico({
    required String nome,
    String? especialidade,
  }) async {
    isLoading = true;
    errorMessage = null;
    isSuccess = false;
    notifyListeners(); 

    try {
      final novoTecnico = TecnicoModel(
        nome: nome,
        especialidade: especialidade,
      );

      await _service.salvarTecnico(novoTecnico);
      
      isSuccess = true;
      await carregarTecnicos(); 
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarTecnicos() async {
    isLoading = true;
    notifyListeners();
    try {
      tecnicosCadastrados = await _service.buscarTodos();
    } catch (e) {
      errorMessage = 'Erro ao carregar técnicos.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}