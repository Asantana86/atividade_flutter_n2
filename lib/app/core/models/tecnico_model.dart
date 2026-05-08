import '../base/base_model.dart';

class TecnicoModel extends BaseModel {
  String nome;
  String? especialidade;

  TecnicoModel({
    super.id,
    super.createdAt,
    super.isSync = 0,
    super.ativo = true,
    required this.nome,
    this.especialidade,
  });

  TecnicoModel.fromMap(super.map)
      : nome = map['nome'] ?? '',
        especialidade = map['especialidade'],
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    
    map.addAll({
      'nome': nome,
      'especialidade': especialidade,
    });
    
    return map;
  }
}