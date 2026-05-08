import '../base/base_validation.dart';
import '../models/cliente_model.dart';
import '../repositories/cliente_repository.dart';

class ClienteValidation
    extends BaseValidation<ClienteModel, ClienteRepository> {
  ClienteValidation(super.repository);

  @override
  void validateFields(ClienteModel? model) {
    super.validateFields(model);
    final cliente = model!;

    if (cliente.nome.trim().isEmpty) {
      throw Exception("O nome do cliente é obrigatório.");
    }

    final docLimpo = cliente.documento.replaceAll(RegExp(r'[^0-9a-zA-Z]'), '');
    if (docLimpo.isEmpty) {
      throw Exception("O documento (RG ou CPF) é obrigatório.");
    }
    if (docLimpo.length < 5) {
      throw Exception("Informe um documento válido.");
    }

    final telLimpo = cliente.telefone.replaceAll(RegExp(r'[^0-9]'), '');
    if (telLimpo.isEmpty) {
      throw Exception("O telefone é obrigatório.");
    }
    if (telLimpo.length < 10) {
      throw Exception("Informe um telefone válido com DDD.");
    }

    if (cliente.email != null && cliente.email!.trim().isNotEmpty) {
      final emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      );
      if (!emailRegex.hasMatch(cliente.email!)) {
        throw Exception("Informe um e-mail válido.");
      }
    }
  }

  @override
  Future<void> validateRulesCreate(ClienteModel model) async {
    final docExiste = await repository.exists("documento = ?", [
      model.documento,
    ]);
    if (docExiste) {
      throw Exception("Já existe um cliente cadastrado com este documento.");
    }

    if (model.email != null && model.email!.trim().isNotEmpty) {
      final emailExiste = await repository.exists("email = ?", [model.email]);
      if (emailExiste) {
        throw Exception("Já existe um cliente cadastrado com este e-mail.");
      }
    }
  }

  @override
  Future<void> validateRulesUpdate(ClienteModel model) async {
    final docExiste = await repository.exists("documento = ? AND id != ?", [
      model.documento,
      model.id,
    ]);
    if (docExiste) {
      throw Exception(
        "Este documento já está sendo utilizado por outro cliente.",
      );
    }

    if (model.email != null && model.email!.trim().isNotEmpty) {
      final emailExiste = await repository.exists("email = ? AND id != ?", [
        model.email,
        model.id,
      ]);
      if (emailExiste) {
        throw Exception(
          "Este e-mail já está sendo utilizado por outro cliente.",
        );
      }
    }
  }
}
