import 'package:flutter/material.dart';
import '../../../core/services/service_order_service.dart';
import '../../../core/models/service_order_model.dart';
import '../../../../app/core/services/user_service.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final service = ServiceOrderService();

  @override
  Widget build(BuildContext context) {
    final os = service.getAll();
    final abertos = service.byStatus("Em aberto");
    final execucao = service.byStatus("Em execução");
    final executadas = service.byStatus("Executada");

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Pega o usuário logado para mostrar no menu
    final usuarioLogado = UserService().usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primary),
              accountName: Text(
                usuarioLogado?.nome ?? 'Técnico',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                usuarioLogado?.email ?? 'tecnico@serviceflow.com',
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Novo Cliente'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/cadastro_cliente');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_add),
              title: const Text('Nova Ordem de Serviço'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/nova_os').then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_add),
              title: const Text('Início Ordem de Serviço'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/iniciar_os').then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_add),
              title: const Text('Fim Ordem de Serviço'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/finalizar_os').then((_) {
                  setState(() {});
                });
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair', style: TextStyle(color: Colors.red)),
              onTap: () {
                UserService().limpar();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
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
              quantidade: os.length,
              valor: service.totalValor(),
              color: colorScheme.primary,
              list: os,
            ),
            _buildCard(
              context,
              title: "Em Aberto",
              quantidade: abertos.length,
              valor: service.totalValorByStatus("Em aberto"),
              color: colorScheme.error,
              list: abertos,
            ),
            _buildCard(
              context,
              title: "Em Execução",
              quantidade: execucao.length,
              valor: service.totalValorByStatus("Em execução"),
              color: Colors.orange,
              list: execucao,
            ),
            _buildCard(
              context,
              title: "Executadas",
              quantidade: executadas.length,
              valor: service.totalValorByStatus("Executada"),
              color: Colors.green,
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
    required List<ServiceOrderModel> list,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/os_list',
          arguments: {'title': title, 'lista': list},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withAlpha(38),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "$quantidade OS",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "R\$ ${valor.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
