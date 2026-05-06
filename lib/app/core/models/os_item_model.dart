import 'base_model.dart';

class OsItemModel extends BaseModel {
  int osId;
  int servicoId;
  String? descricaoSnapshot;
  double? precoSnapshot;

  OsItemModel({super.id, super.isSync, required this.osId, required this.servicoId, this.descricaoSnapshot, this.precoSnapshot});

  @override
  Map<String, dynamic> toMap() => {
    'id': id, 'os_id': osId, 'servico_id': servicoId, 'descricao_snapshot': descricaoSnapshot, 'preco_snapshot': precoSnapshot, 'is_sync': isSync ? 1 : 0,
  };

  factory OsItemModel.fromMap(Map<String, dynamic> map) => OsItemModel(
    id: map['id'] as int?, osId: map['os_id'] as int, servicoId: map['servico_id'] as int, descricaoSnapshot: map['descricao_snapshot'], precoSnapshot: (map['preco_snapshot'] as num?)?.toDouble(), isSync: map['is_sync'] == 1,
  );
}