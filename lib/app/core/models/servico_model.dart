import '../base/base_model.dart';

class ServicoModel extends BaseModel {
  String descricao;
  double preco;
  String? tempoEstimado;

  ServicoModel({
    super.id,
    super.createdAt,
    super.isSync = 0,
    super.ativo = true,
    required this.descricao,
    required this.preco,
    this.tempoEstimado,
  });

  ServicoModel.fromMap(super.map)
      : descricao = map['descricao'] ?? '',
        preco = (map['preco'] as num?)?.toDouble() ?? 0.0, 
        tempoEstimado = map['tempo_estimado'],
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    
    map.addAll({
      'descricao': descricao,
      'preco': preco,
      'tempo_estimado': tempoEstimado,
    });
    
    return map;
  }
}