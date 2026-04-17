import 'package:flutter/material.dart';
import 'package:atividade_flutter_n2/app/core/services/service_order_service.dart';
import 'package:atividade_flutter_n2/app/core/models/service_order_model.dart';
import 'package:atividade_flutter_n2/app/modules/dashboard/pages/os_list_page.dart';


class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final service = ServiceOrderService();

  @override
  Widget build(BuildContext context) {
    final os = service.getAll();

    final total = os.length;
    final abertos = service.byStatus("aberto");
    final execucao = service.byStatus("execucao");
    final executadas = service.byStatus("executada");

    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard de Gestão"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(
              context,
              title: "Total de OS",
              quantidade: total,
              valor: os.fold(0, (sum, item) => sum + item.valor),
              color: theme.primary,
              list: os,
            ),
            _buildCard(
              context,
              title: "Em Aberto",
              quantidade: abertos.length,
              valor: abertos.fold(0, (sum, item) => sum + item.valor),
              color: theme.error, // vermelho semântico
              list: abertos,
            ),
            _buildCard(
              context,
              title: "Em Execução",
              quantidade: execucao.length,
              valor: execucao.fold(0, (sum, item) => sum + item.valor),
              color: theme.tertiary, // amarelo/laranja semântico
              list: execucao,
            ),
            _buildCard(
              context,
              title: "Executadas",
              quantidade: executadas.length,
              valor: executadas.fold(0, (sum, item) => sum + item.valor),
              color: theme.secondary, // verde semântico
              list: executadas,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required int quantidade,
    required double valor,
    required Color color,
    required List<ServiceOrder> list,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OSListPage(title: title, lista: list),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("$quantidade OS", style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 8),
            Text("R\$ ${valor.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
