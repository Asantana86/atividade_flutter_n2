import '../models/servico_model.dart';
import '../repositories/servico_repository.dart';
import '../validations/servico_validation.dart';

class ServicoService {
  final _repository = ServicoRepository();
  final _validation = ServicoValidation();

  Future<void> salvarServico(ServicoModel servico) async {

    final erroValidacao = _validation.validar(servico);
    if (erroValidacao != null) {
      throw Exception(erroValidacao);
    }

    servico.isSync = false;
    await _repository.insert(servico);
  }

  Future<List<ServicoModel>> buscarTodos() async {
    return await _repository.getAll();
  }
}