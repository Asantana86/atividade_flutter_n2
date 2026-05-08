import '../base/base_provider.dart';
import '../models/servico_model.dart';

class ServicoProvider extends BaseProvider<ServicoModel> {
  
  @override
  String get endpoint => '/rest/v1/servicos';

  @override
  Map<String, dynamic> toExternalFormat(ServicoModel entity) {
    return {
      'id': entity.id,
      'descricao': entity.descricao,
      'preco': entity.preco,
      'tempo_estimado': entity.tempoEstimado,
      'ativo': entity.ativo,
      'created_at': entity.createdAt?.toIso8601String(),
    };
  }

  @override
  ServicoModel fromExternalFormat(Map<String, dynamic> data) {
    return ServicoModel(
      id: data['id'],
      descricao: data['descricao'],
      preco: (data['preco'] as num).toDouble(), 
      tempoEstimado: data['tempo_estimado'],
      ativo: data['ativo'] ?? true,
      isSync: 1,
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at']) 
          : null,
    );
  }
}