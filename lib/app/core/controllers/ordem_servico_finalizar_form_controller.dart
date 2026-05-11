import '../base/base_controller.dart';
import '../models/cliente_model.dart';
import '../models/ordem_servico_model.dart';
import '../repositories/ordem_servico_repository.dart';
import '../services/cliente_service.dart';
import '../services/ordem_servico_service.dart';
import '../validations/ordem_servico_validation.dart';

class OrdemServicoFinalizarFormController extends BaseController<
    OrdemServicoModel,
    OrdemServicoRepository,
    OrdemServicoValidation,
    OrdemServicoService> {
      
  final ClienteService clienteService;

  // Listas para o dropdown e para mostrar o nome do cliente
  List<OrdemServicoModel> ordensAbertas = [];
  List<ClienteModel> clientes = [];

  OrdemServicoFinalizarFormController(
    super.service, {
    required this.clienteService,
    super.model,
  });

  /// Busca as ordens de serviço ativas e os clientes
  Future<void> carregarDependencias({void Function(String)? onError}) async {
    final result = await executeOperation(
      Future.wait([
        service.findAllActive(),
        clienteService.findAllActive(),
      ]),
      onError: onError,
    );

    if (result != null) {
      final todasAsOrdens = result[0] as List<OrdemServicoModel>;
      clientes = result[1] as List<ClienteModel>;
      
      // Filtra apenas as que estão em andamento para exibir no Dropdown
      ordensAbertas = todasAsOrdens
          .where((os) => os.status == StatusOS.emAndamento)
          .toList();
    }
  }

  /// Monta a ordem de serviço atualizada com foto, assinatura e observações
  Future<bool> finalizarOrdem({
    required OrdemServicoModel ordemSelecionada,
    required DateTime dataFim,
    required String observacaoFinal,
    String? fotoDepoisPath,
    String? assinaturaBase64,
    void Function(String)? onSuccess,
    void Function(String)? onError,
  }) async {
    
    final osFinalizada = OrdemServicoModel(
      id: ordemSelecionada.id,
      createdAt: ordemSelecionada.createdAt,
      clienteId: ordemSelecionada.clienteId,
      tecnicoId: ordemSelecionada.tecnicoId,
      servicoId: ordemSelecionada.servicoId,
      dataInicio: ordemSelecionada.dataInicio,
      fotoAntes: ordemSelecionada.fotoAntes,
      dataFim: dataFim,
      fotoDepois: fotoDepoisPath ?? '',
      assinatura: assinaturaBase64 ?? '',
      observacaoFinal: observacaoFinal.trim(),
      status: StatusOS.finalizado,
    );

    return await executeCrudOperation(
      service.update(osFinalizada),
      onSuccess: onSuccess,
      onError: onError,
      successMessage: 'Ordem de serviço finalizada com sucesso!',
    );
  }
}