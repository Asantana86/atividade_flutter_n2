import '../models/service_order_model.dart';
import '../repositories/ordem_servico_repository.dart';
import '../validations/service_order_validation.dart';

class ServiceOrderService {
  final _repository = OrdemServicoRepository();
  final _validation = ServiceOrderValidation();

  Future<void> salvarNovaOS(ServiceOrderModel os) async {

    final erroValidacao = _validation.validarInicio(os);
    if (erroValidacao != null) {
      throw Exception(erroValidacao);
    }

    final osParaSalvar = ServiceOrderModel(
      clienteId: os.clienteId,
      tecnicoId: os.tecnicoId,
      observacao: os.observacao,
      pecasAplicadas: os.pecasAplicadas,
      valorPecas: os.valorPecas,
      fotoAntes: os.fotoAntes,
      fotoDepois: os.fotoDepois,
      assinatura: os.assinatura,
      status: 'Em aberto',
      isSync: false,
    );

    await _repository.insert(osParaSalvar);
  }

  Future<void> atualizarOS(ServiceOrderModel os) async {

    final erroValidacao = _validation.validarFim(os);
    if (erroValidacao != null) {
      throw Exception(erroValidacao);
    }

    os.isSync = false;
    
    await _repository.update(os);
  }

  Future<List<ServiceOrderModel>> buscarTodasOS() async {
    return await _repository.getAll();
  }

  Future<double> calcularValorTotal() async {
    final lista = await _repository.getAll();
    return lista.fold<double>(0.0, (sum, item) => sum + item.valorPecas);
  }
}