import '../base/base_provider.dart';
import '../models/tecnico_model.dart';

class TecnicoProvider extends BaseProvider<TecnicoModel> {
  
  @override
  String get endpoint => '/rest/v1/tecnicos';

  @override
  Map<String, dynamic> toExternalFormat(TecnicoModel entity) {
    return {
      'id': entity.id,
      'nome': entity.nome,
      'especialidade': entity.especialidade,
      'ativo': entity.ativo,
      'created_at': entity.createdAt?.toIso8601String(),
    };
  }

  @override
  TecnicoModel fromExternalFormat(Map<String, dynamic> data) {
    return TecnicoModel(
      id: data['id'],
      nome: data['nome'],
      especialidade: data['especialidade'],
      ativo: data['ativo'] ?? true,
      isSync: 1, 
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at']) 
          : null,
    );
  }
}