import 'base_model.dart';

class ServicoModel extends BaseModel {
  String descricao;
  double preco;
  String? tempoEstimado;

  ServicoModel({super.id, super.isSync, required this.descricao, required this.preco, this.tempoEstimado});

  @override
  Map<String, dynamic> toMap() => {
    'id': id, 'descricao': descricao, 'preco': preco, 'tempo_estimado': tempoEstimado, 'is_sync': isSync ? 1 : 0,
  };

  factory ServicoModel.fromMap(Map<String, dynamic> map) => ServicoModel(
    id: map['id'] as int?, descricao: map['descricao'], preco: (map['preco'] as num).toDouble(), tempoEstimado: map['tempo_estimado'], isSync: map['is_sync'] == 1,
  );
}