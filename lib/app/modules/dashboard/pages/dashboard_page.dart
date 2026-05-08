import 'package:flutter/material.dart';

// Importe o serviço de Auth
import '../../../core/services/auth_service.dart';
import '../../../core/models/ordem_servico_model.dart';

// Importe as dependências (Ajuste os caminhos conforme suas pastas)
import '../../../core/repositories/cliente_repository.dart';
import '../../../core/validations/cliente_validation.dart';
import '../../../core/services/cliente_service.dart';

import '../../../core/repositories/tecnico_repository.dart';
import '../../../core/validations/tecnico_validation.dart';
import '../../../core/services/tecnico_service.dart';

import '../../../core/repositories/servico_repository.dart';
import '../../../core/validations/servico_validation.dart';
import '../../../core/services/servico_service.dart';

import '../../../core/repositories/ordem_servico_repository.dart';
import '../../../core/validations/ordem_servico_validation.dart';
import '../../../core/services/ordem_servico_service.dart';

// Importe os Controllers e a ListView que construímos
import '../../../core/controllers/ordem_servico_dashboard_controller.dart';
import '../../../core/controllers/ordem_servico_iniciar_form_controller.dart';
import '../../../core/controllers/ordem_servico_list_view.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final AuthService _authService = AuthService();

  String userName = 'Carregando...';
  String userEmail = 'Carregando...';

  // Declarando nossos serviços
  late final ClienteService clienteService;
  late final TecnicoService tecnicoService;
  late final ServicoService servicoService;
  late final OrdemServicoService osService;

  // O Controller que vai gerenciar a ListView
  late final OrdemServicoDashboardController osController;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initDependencies();
  }

  void _loadUserData() {
    final user = _authService.usuarioSupabase;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? 'tecnico@serviceflow.com';
        userName = user.userMetadata?['nome_completo'] ?? 'Técnico';
      });
    }
  }

  void _initDependencies() {
    // 1. Instanciando toda a nossa arquitetura offline-first limpa
    clienteService = ClienteService(
      ClienteValidation(ClienteRepository()),
      ClienteRepository(),
    );
    tecnicoService = TecnicoService(
      TecnicoValidation(TecnicoRepository()),
      TecnicoRepository(),
    );
    servicoService = ServicoService(
      ServicoValidation(ServicoRepository()),
      ServicoRepository(),
    );
    osService = OrdemServicoService(
      OrdemServicoValidation(OrdemServicoRepository()),
      OrdemServicoRepository(),
    );

    // 2. Criando o controller principal passando as "ferramentas" para ele
    osController = OrdemServicoDashboardController(
      osService,
      clienteService: clienteService,
      tecnicoService: tecnicoService,
      servicoService: servicoService,
    );
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // O DefaultTabController permite transitar entre os status deslizando a tela!
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Minhas Ordens",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Todas'),
              Tab(text: 'Em Aberto'),
              Tab(text: 'Finalizadas'),
              Tab(text: 'Canceladas'),
            ],
          ),
        ),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: colorScheme.primary),
                accountName: Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                accountEmail: Text(userEmail),
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
                leading: const Icon(Icons.people), // Ícone de grupo
                title: const Text('Clientes'),
                onTap: () {
                  Navigator.pop(context); // Fecha o menu lateral
                  Navigator.pushNamed(
                    context,
                    '/clientes',
                  ); // Vai para a Lista!
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Sair', style: TextStyle(color: Colors.red)),
                onTap: _handleLogout,
              ),
            ],
          ),
        ),

        // Cada aba carrega a nossa ListView pronta passando o Status desejado
        body: TabBarView(
          children: [
            OrdemServicoListView(
              controller: osController,
              status: null,
            ), // null = Todas
            OrdemServicoListView(
              controller: osController,
              status: StatusOS.emAndamento,
            ),
            OrdemServicoListView(
              controller: osController,
              status: StatusOS.finalizado,
            ),
            OrdemServicoListView(
              controller: osController,
              status: StatusOS.cancelado,
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navegamos direto para o Controller de Iniciar passando as instâncias
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrdemServicoIniciarFormController(
                  osService,
                  clienteService: clienteService,
                  tecnicoService: tecnicoService,
                  servicoService: servicoService,
                ),
              ),
            );
          },
          label: const Text('Nova Ordem'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
