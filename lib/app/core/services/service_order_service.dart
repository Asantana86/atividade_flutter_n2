

import 'package:atividade_flutter_n2/app/core/models/service_order_model.dart';

class ServiceOrderService {
  final List<ServiceOrder> _mock = [
    ServiceOrder(descricao: "Troca de tela", valor: 250, status: "aberto"),
    ServiceOrder(descricao: "Formatação", valor: 150, status: "execucao"),
    ServiceOrder(descricao: "Limpeza interna", valor: 120, status: "executada"),
    ServiceOrder(descricao: "Troca de bateria", valor: 300, status: "executada"),
  ];

  List<ServiceOrder> getAll() => _mock;

  List<ServiceOrder> byStatus(String status) =>
      _mock.where((os) => os.status == status).toList();
}