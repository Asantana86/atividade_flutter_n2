import '../models/tecnico_model.dart';

class TecnicoValidation {

  String? validar(TecnicoModel tecnico) {
    if (tecnico.nome.trim().isEmpty) {
      return 'O nome do técnico é obrigatório.';
    }

    return null;
  }
}