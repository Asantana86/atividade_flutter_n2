import '../models/service_order_model.dart';

class ServiceOrderService {
  static final ServiceOrderService _instance = ServiceOrderService._internal();
  factory ServiceOrderService() => _instance;
  ServiceOrderService._internal();

  final List<ServiceOrderModel> _ordens = [
    ServiceOrderModel(id: 1, clienteNome: 'João Silva', descricao: 'Troca de tela', valor: 250, status: 'Em aberto', createdAt: DateTime.now()),
    ServiceOrderModel(id: 2, clienteNome: 'Maria Souza', descricao: 'Formatação', valor: 150, status: 'Em execução', createdAt: DateTime.now()),
    ServiceOrderModel(id: 3, clienteNome: 'Carlos Lima', descricao: 'Limpeza interna', valor: 120, status: 'Executada', createdAt: DateTime.now()),
    ServiceOrderModel(id: 4, clienteNome: 'Ana Costa', descricao: 'Troca de bateria', valor: 300, status: 'Executada', createdAt: DateTime.now()),
  ];

  List<ServiceOrderModel> getAll() => List.unmodifiable(_ordens);

  List<ServiceOrderModel> byStatus(String status) =>
      _ordens.where((os) => os.status == status).toList();

  void add(ServiceOrderModel ordem) {
    final int newId = _ordens.isNotEmpty ? _ordens.last.id! + 1 : 1;
    
    final novaOrdem = ServiceOrderModel(
      id: newId,
      clienteNome: ordem.clienteNome,
      descricao: ordem.descricao,
      valor: ordem.valor,
      status: ordem.status,
      fotoAntesPath: ordem.fotoAntesPath,
      fotoDepoisPath: ordem.fotoDepoisPath,
      assinaturaBase64: ordem.assinaturaBase64,
      createdAt: DateTime.now(),
    );
    
    _ordens.add(novaOrdem);
  }

  double totalValorByStatus(String status) =>
      byStatus(status).fold(0, (sum, os) => sum + os.valor);
      
  double totalValor() => 
      _ordens.fold(0, (sum, os) => sum + os.valor);
}