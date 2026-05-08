import '../base/base_model.dart';

enum StatusOS {
  emAndamento('Em Andamento'),
  finalizado('Finalizado'),
  cancelado('Cancelado');

  final String label;
  const StatusOS(this.label);

  static StatusOS fromString(String value) {
    return StatusOS.values.firstWhere(
      (e) => e.label == value,
      orElse: () => StatusOS.emAndamento,
    );
  }
}

class OrdemServicoModel extends BaseModel {
  final int clienteId;
  final int tecnicoId;
  final int servicoId;

  DateTime dataInicio;
  DateTime? dataFim;
  
  String? observacaoFinal;
  
  String fotoAntes;
  String? fotoDepois;
  
  String? assinatura;
  
  StatusOS status;

  OrdemServicoModel({
    super.id,
    super.createdAt,
    super.isSync = 0,
    super.ativo = true,
    required this.clienteId,
    required this.tecnicoId,
    required this.servicoId,
    required this.dataInicio,
    required this.fotoAntes,
    this.dataFim,
    this.observacaoFinal,
    this.fotoDepois,
    this.assinatura,
    this.status = StatusOS.emAndamento,
  });

  OrdemServicoModel.fromMap(super.map)
      : clienteId = map['cliente_id'] as int,
        tecnicoId = map['tecnico_id'] as int,
        servicoId = map['servico_id'] as int,
        dataInicio = DateTime.parse(map['data_inicio'].toString()),
        dataFim = map['data_fim'] != null 
            ? DateTime.tryParse(map['data_fim'].toString()) 
            : null,
        observacaoFinal = map['observacao_final'],
        fotoAntes = map['foto_antes'] ?? '',
        fotoDepois = map['foto_after'],
        assinatura = map['assinatura'],
        status = StatusOS.fromString(map['status'].toString()),
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    
    map.addAll({
      'cliente_id': clienteId,
      'tecnico_id': tecnicoId,
      'servico_id': servicoId,
      'data_inicio': dataInicio.toIso8601String(),
      'data_fim': dataFim?.toIso8601String(),
      'observacao_final': observacaoFinal,
      'foto_antes': fotoAntes,
      'foto_after': fotoDepois,
      'assinatura': assinatura,
      'status': status.label,
    });
    
    return map;
  }
}