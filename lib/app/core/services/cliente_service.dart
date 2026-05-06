import '../models/cliente_model.dart';
import '../repositories/cliente_repository.dart';
import '../validations/cliente_validation.dart';

class ClienteService {
  final _repository = ClienteRepository();
  final _validation = ClienteValidation();

  Future<void> salvar(ClienteModel cliente) async {

    final erroValidacao = await _validation.validar(cliente);
    
    if (erroValidacao != null) {
      throw Exception(erroValidacao);
    }

    cliente.isSync = false;
    await _repository.insert(cliente);
  }

  Future<List<ClienteModel>> buscarTodos() async {
    return await _repository.getAll();
  }
}