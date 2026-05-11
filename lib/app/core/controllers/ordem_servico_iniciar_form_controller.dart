import '../base/base_controller.dart';
import '../models/cliente_model.dart';
import '../models/ordem_servico_model.dart';
import '../models/servico_model.dart';
import '../models/tecnico_model.dart';
import '../repositories/ordem_servico_repository.dart';
import '../services/cliente_service.dart';
import '../services/ordem_servico_service.dart';
import '../services/servico_service.dart';
import '../services/tecnico_service.dart';
import '../validations/ordem_servico_validation.dart';

class OrdemServicoIniciarFormController extends BaseController<
    OrdemServicoModel,
    OrdemServicoRepository,
    OrdemServicoValidation,
    OrdemServicoService> {
      
  final ClienteService clienteService;
  final TecnicoService tecnicoService;
  final ServicoService servicoService;

  // Listas que vão alimentar os Dropdowns na tela
  List<ClienteModel> clientes = [];
  List<TecnicoModel> tecnicos = [];
  List<ServicoModel> servicos = [];

  OrdemServicoIniciarFormController(
    super.service, {
    required this.clienteService,
    required this.tecnicoService,
    required this.servicoService,
    super.model,
  });

  bool get isEditing => model != null;

  /// Busca Clientes, Técnicos e Serviços em paralelo para otimizar o tempo
  Future<void> carregarDependencias({void Function(String)? onError}) async {
    final result = await executeOperation(
      Future.wait([
        clienteService.findAllActive(),
        tecnicoService.findAllActive(),
        servicoService.findAllActive(),
      ]),
      onError: onError,
    );

    if (result != null) {
      clientes = result[0] as List<ClienteModel>;
      tecnicos = result[1] as List<TecnicoModel>;
      servicos = result[2] as List<ServicoModel>;
    }
  }

  /// Constrói o modelo e delega o salvamento (Create ou Update)
  Future<bool> salvarOrdem({
    required int clienteId,
    required int tecnicoId,
    required int servicoId,
    required DateTime dataInicio,
    String? fotoAntesPath,
    void Function(String)? onSuccess,
    void Function(String)? onError,
  }) async {
    
    final os = OrdemServicoModel(
      id: model?.id,
      createdAt: model?.createdAt,
      clienteId: clienteId,
      tecnicoId: tecnicoId,
      servicoId: servicoId,
      dataInicio: dataInicio,
      fotoAntes: fotoAntesPath ?? '',
      status: StatusOS.emAndamento,
    );

    final operation = isEditing ? service.update(os) : service.create(os);

    return await executeCrudOperation(
      operation,
      onSuccess: onSuccess,
      onError: onError,
      successMessage: isEditing ? 'Ordem atualizada com sucesso!' : 'Ordem de Serviço iniciada!',
    );
  }
}