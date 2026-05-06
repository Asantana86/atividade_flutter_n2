import 'package:flutter/material.dart';
import '../models/os_item_model.dart';
import '../services/os_item_service.dart';

class OsItemController extends ChangeNotifier {
  final _service = OsItemService();

  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;
  
  List<OsItemModel> itensDaOsAtual = [];

  Future<void> adicionarItem({
    required int osId,
    required int servicoId,
    String? descricaoSnapshot,
    double? precoSnapshot,
  }) async {
    isLoading = true;
    errorMessage = null;
    isSuccess = false;
    notifyListeners();

    try {
      final novoItem = OsItemModel(
        osId: osId,
        servicoId: servicoId,
        descricaoSnapshot: descricaoSnapshot,
        precoSnapshot: precoSnapshot,
      );

      await _service.adicionarItemNaOS(novoItem);
      
      isSuccess = true;
      await carregarItensDaOS(osId);
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> carregarItensDaOS(int osId) async {
    isLoading = true;
    notifyListeners();
    try {
      itensDaOsAtual = await _service.buscarItensDaOS(osId);
    } catch (e) {
      errorMessage = 'Erro ao carregar os itens desta Ordem de Serviço.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}