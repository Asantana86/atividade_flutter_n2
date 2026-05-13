import '../base/base_service.dart';
import '../models/ordem_servico_model.dart';
import '../repositories/ordem_servico_repository.dart';
import '../validations/ordem_servico_validation.dart';

class OrdemServicoService extends BaseService<OrdemServicoModel, OrdemServicoRepository, OrdemServicoValidation> {
  
  OrdemServicoService(super.validation, super.repository);

  @override
  OrdemServicoModel cloneModelWithId(OrdemServicoModel model, dynamic id) {
    return OrdemServicoModel(
      id: id,
      createdAt: model.createdAt,
      isSync: model.isSync,
      ativo: model.ativo,
      clienteId: model.clienteId,
      tecnicoId: model.tecnicoId,
      servicoId: model.servicoId,
      dataInicio: model.dataInicio,
      dataFim: model.dataFim,
      observacaoFinal: model.observacaoFinal,
      fotoAntes: model.fotoAntes,
      fotoDepois: model.fotoDepois,
      assinatura: model.assinatura,
      status: model.status,
    );
  }

  @override
  void beforeCreate(OrdemServicoModel model) {
    model.status = StatusOS.emAndamento;
  }

  @override
  void beforeUpdate(OrdemServicoModel model) {
    model.isSync = 0;

    final isFinalizando = model.dataFim != null && 
                          model.fotoDepois != null && 
                          model.assinatura != null;

    if (isFinalizando && model.status != StatusOS.cancelado) {
      model.status = StatusOS.finalizado;
    }
  }

  @override
  Future<void> softDelete(dynamic id) async {

    final model = await findById(id);
    
    if (model != null) {
      beforeDelete(model);
      
      if (model.status != StatusOS.finalizado) {
        model.status = StatusOS.cancelado;
      }
      
      model.ativo = false;
      model.isSync = 0;
      
      await repository.update(model);
      
      afterDelete(model);
    }
  }

  Future<List<OrdemServicoModel>> findByStatus(StatusOS status) async {
    final all = await repository.findAllActive();
    return all.where((os) => os.status == status).toList();
  }
}