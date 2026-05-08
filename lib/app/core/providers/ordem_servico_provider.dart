import '../base/base_provider.dart';
import '../models/ordem_servico_model.dart';

class OrdemServicoProvider extends BaseProvider<OrdemServicoModel> {
  
  @override
  String get endpoint => '/rest/v1/ordens_servico';

  @override
  Map<String, dynamic> toExternalFormat(OrdemServicoModel entity) {
    return {
      'id': entity.id,
      'cliente_id': entity.clienteId,
      'tecnico_id': entity.tecnicoId,
      'servico_id': entity.servicoId,
      'data_inicio': entity.dataInicio.toIso8601String(),
      'data_fim': entity.dataFim?.toIso8601String(),
      'observacao_final': entity.observacaoFinal,
      'foto_antes': entity.fotoAntes,
      'foto_depois': entity.fotoDepois,
      'assinatura': entity.assinatura,
      'status': entity.status.name, 
      'ativo': entity.ativo,
      'created_at': entity.createdAt?.toIso8601String(),
    };
  }

  @override
  OrdemServicoModel fromExternalFormat(Map<String, dynamic> data) {
    // Busca o status correspondente no Enum ou assume 'cancelado' como fallback
    final statusEnum = StatusOS.values.firstWhere(
      (e) => e.name == data['status'],
      orElse: () => StatusOS.cancelado,
    );

    return OrdemServicoModel(
      id: data['id'],
      clienteId: data['cliente_id'],
      tecnicoId: data['tecnico_id'],
      servicoId: data['servico_id'],
      dataInicio: DateTime.parse(data['data_inicio']),
      dataFim: data['data_fim'] != null ? DateTime.parse(data['data_fim']) : null,
      observacaoFinal: data['observacao_final'],
      fotoAntes: data['foto_antes'] ?? '',
      fotoDepois: data['foto_depois'],
      assinatura: data['assinatura'],
      status: statusEnum,
      ativo: data['ativo'] ?? true,
      isSync: 1,
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at']) 
          : null,
    );
  }
}