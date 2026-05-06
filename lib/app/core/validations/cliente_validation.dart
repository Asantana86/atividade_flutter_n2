import '../models/cliente_model.dart';
import '../repositories/cliente_repository.dart';

class ClienteValidation {
  final _repo = ClienteRepository();

  Future<String?> validar(ClienteModel entity) async {
    if (entity.nome.trim().isEmpty) {
      return "O nome do cliente é obrigatório.";
    }

    if (entity.documento != null && entity.documento!.isNotEmpty) {
      final docLimpo = entity.documento!.replaceAll(RegExp(r'[^0-9]'), '');
      if (docLimpo.length != 11 && docLimpo.length != 14) {
        return "Documento inválido. Informe um CPF (11) ou CNPJ (14).";
      }

      final todos = await _repo.getAll();
      final existe = todos.any((c) => c.documento == entity.documento);
      if (existe) {
        return "Já existe um cliente cadastrado com este documento.";
      }
    }

    return null;
  }
}