
import 'package:atividade_flutter_n2/app/core/models/service_order_model.dart';

class ServiceOrderService {
  static final ServiceOrderService _instance = ServiceOrderService._internal();
  factory ServiceOrderService() => _instance;
  ServiceOrderService._internal();

  final List<ServiceOrder> _ordens = [
    ServiceOrder(clienteNome: 'João Silva', descricao: 'Troca de tela', valor: 250, status: 'aberto'),
    ServiceOrder(clienteNome: 'Maria Souza', descricao: 'Formatação', valor: 150, status: 'execucao'),
    ServiceOrder(clienteNome: 'Carlos Lima', descricao: 'Limpeza interna', valor: 120, status: 'executada'),
    ServiceOrder(clienteNome: 'Ana Costa', descricao: 'Troca de bateria', valor: 300, status: 'executada'),
  ];

  List<ServiceOrder> getAll() => List.unmodifiable(_ordens);

  List<ServiceOrder> byStatus(String status) =>
      _ordens.where((os) => os.status == status).toList();

  void add(ServiceOrder ordem) => _ordens.add(ordem);

  double totalValorByStatus(String status) =>
      byStatus(status).fold(0, (sum, os) => sum + os.valor);
}