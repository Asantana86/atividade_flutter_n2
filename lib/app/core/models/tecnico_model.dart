import 'base_model.dart';

class TecnicoModel extends BaseModel {
  String nome;
  String? especialidade;

  TecnicoModel({super.id, super.isSync, required this.nome, this.especialidade});

  @override
  Map<String, dynamic> toMap() => {
    'id': id, 'nome': nome, 'especialidade': especialidade, 'is_sync': isSync ? 1 : 0,
  };

  factory TecnicoModel.fromMap(Map<String, dynamic> map) => TecnicoModel(
    id: map['id'] as int?, nome: map['nome'], especialidade: map['especialidade'], isSync: map['is_sync'] == 1,
  );
}