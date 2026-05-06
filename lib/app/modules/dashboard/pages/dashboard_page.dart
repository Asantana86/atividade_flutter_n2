import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/service_order_model.dart';
import '../../../core/controllers/service_order_controller.dart';
import '../../../core/controllers/cliente_controller.dart';
import '../../../core/controllers/tecnico_controller.dart';
import '../../../../app/core/services/user_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceOrderController>().carregarOrdens();
      context.read<ClienteController>().carregarClientes();
      context.read<TecnicoController>().carregarTecnicos();
    });
  }

  double _calcularTotal(List<ServiceOrderModel> lista) {
    return lista.fold(0.0, (sum, item) => sum + item.valorPecas);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final usuarioLogado = UserService().usuario;

    final controller = context.watch<ServiceOrderController>();
    final os = controller.ordensCadastradas;

    final abertos = os.where((item) => item.status == "Em aberto").toList();
    final execucao = os.where((item) => item.status == "Em execução").toList();
    final executadas = os.where((item) => item.status == "Executada").toList();

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
                Navigator.pushNamed(context, '/cadastro_cliente');
              },
            ),
            ListTile(
              leading: const Icon(Icons.engineering),
              title: const Text('Novo Técnico'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cadastro_tecnico');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_add),
              title: const Text('Início Ordem de Serviço'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/iniciar_os');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_add),
              title: const Text('Fim Ordem de Serviço'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/finalizar_os');
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

      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                    valor: _calcularTotal(os),
                    color: colorScheme.primary,
                    list: os,
                  ),
                  _buildCard(
                    context,
                    title: "Em Aberto",
                    quantidade: abertos.length,
                    valor: _calcularTotal(abertos),
                    color: colorScheme.error,
                    list: abertos,
                  ),
                  _buildCard(
                    context,
                    title: "Em Execução",
                    quantidade: execucao.length,
                    valor: _calcularTotal(execucao),
                    color: Colors.orange,
                    list: execucao,
                  ),
                  _buildCard(
                    context,
                    title: "Executadas",
                    quantidade: executadas.length,
                    valor: _calcularTotal(executadas),
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
