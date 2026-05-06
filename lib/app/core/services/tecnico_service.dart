import '../models/tecnico_model.dart';
import '../repositories/tecnico_repository.dart';
import '../validations/tecnico_validation.dart';

class TecnicoService {
  final _repository = TecnicoRepository();
  final _validation = TecnicoValidation();

  Future<void> salvarTecnico(TecnicoModel tecnico) async {

    final erroValidacao = _validation.validar(tecnico);
    if (erroValidacao != null) {
      throw Exception(erroValidacao);
    }

    tecnico.isSync = false;
    
    await _repository.insert(tecnico);
  }

  Future<List<TecnicoModel>> buscarTodos() async {
    return await _repository.getAll();
  }
}