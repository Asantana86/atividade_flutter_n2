import 'base_model.dart';

class ServiceOrderModel extends BaseModel {
  final int clienteId;
  final int tecnicoId;
  final String? observacao;
  final String? pecasAplicadas;
  final double valorPecas;
  String? fotoAntes;
  String? fotoDepois;
  String? assinatura;
  String status; 

  ServiceOrderModel({
    super.id,
    super.isSync,
    required this.clienteId,
    required this.tecnicoId,
    this.observacao,
    this.pecasAplicadas,
    this.valorPecas = 0.0,
    this.fotoAntes,
    this.fotoDepois,
    this.assinatura,
    this.status = 'Em aberto',
  });

  factory ServiceOrderModel.fromMap(Map<String, dynamic> map) {
    return ServiceOrderModel(
      id: map['id'] as int?,
      isSync: map['is_sync'] == 1 || map['is_sync'] == true,
      clienteId: map['cliente_id'] as int,
      tecnicoId: map['tecnico_id'] as int,
      observacao: map['observacao'] as String?,
      pecasAplicadas: map['pecas_aplicadas'] as String?,
      valorPecas: (map['valor_pecas'] as num?)?.toDouble() ?? 0.0,
      fotoAntes: map['foto_antes'] as String?,
      fotoDepois: map['foto_depois'] as String?,
      assinatura: map['assinatura'] as String?,
      status: map['status_os'] as String? ?? 'Em aberto',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'is_sync': isSync ? 1 : 0,
      'cliente_id': clienteId,
      'tecnico_id': tecnicoId,
      'observacao': observacao,
      'pecas_aplicadas': pecasAplicadas,
      'valor_pecas': valorPecas,
      'foto_antes': fotoAntes,
      'foto_depois': fotoDepois,
      'assinatura': assinatura,
      'status_os': status,
    };
  }
}