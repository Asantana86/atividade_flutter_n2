import 'package:flutter/material.dart';

import '../../../core/helpers/sync_system_initializer.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/models/ordem_servico_model.dart';

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

import '../../../core/controllers/ordem_servico_list_controller.dart';
import '../../ordem_servico/pages/ordem_servico_list_view.dart';

import '../../../core/controllers/ordem_servico_iniciar_form_controller.dart';
import '../../ordem_servico/pages/ordem_servico_iniciar_form_page.dart';

import '../../../core/controllers/ordem_servico_finalizar_form_controller.dart';
import '../../../core/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import '../../ordem_servico/pages/ordem_servico_finalizar_form_page.dart';

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

  late final OrdemServicoListController osController;

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
    osController = OrdemServicoListController(
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
              const Divider(),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () => Navigator.pop(context),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.miscellaneous_services),
                title: const Text('Serviços'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/servicos');
                },
              ),
              ListTile(
                leading: const Icon(Icons.engineering),
                title: const Text('Técnicos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/tecnicos');
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Clientes'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/clientes',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.manage_accounts),
                title: const Text('Usuários'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/usuarios',
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.play_circle_outline, color: Colors.blue),
                title: const Text('Iniciar Nova OS'),
                onTap: () async {
                  Navigator.pop(context);
                  
                  final recarregar = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrdemServicoIniciarFormPage(
                        controller: OrdemServicoIniciarFormController(
                          osService,
                          clienteService: clienteService,
                          tecnicoService: tecnicoService,
                          servicoService: servicoService,
                        ),
                      ),
                    ),
                  );

                  if (recarregar == true) {
                    osController.carregarOrdens();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                title: const Text('Finalizar OS'),
                onTap: () async {
                  Navigator.pop(context);
                  
                  final recarregar = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrdemServicoFinalizarFormPage(
                        controller: OrdemServicoFinalizarFormController(
                          osService,
                          clienteService: clienteService,
                        ),
                      ),
                    ),
                  );

                  if (recarregar == true) {
                    osController.carregarOrdens();
                  }
                },
              ),
              const Divider(),
              Consumer<ThemeManager>(
                builder: (context, themeManager, _) => SwitchListTile(
                  value: themeManager.themeMode == ThemeMode.dark,
                  onChanged: (v) => themeManager.toggleTheme(v),
                  title: const Text('Tema escuro'),
                  secondary: const Icon(Icons.dark_mode),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.sync, color: Colors.blue),
                title: const Text('Forçar Sincronização'),
                onTap: () async {
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sincronizando com a nuvem...'))
                  );
                  
                  await SyncSystemInitializer.forceSyncAll();
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sincronização finalizada!'), 
                        backgroundColor: Colors.green,
                      )
                    );
                  }
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
          onPressed: () async {
            // Aguarda o resultado para saber se precisa recarregar a lista
            final recarregar = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => OrdemServicoIniciarFormPage(
                  controller: OrdemServicoIniciarFormController(
                    osService,
                    clienteService: clienteService,
                    tecnicoService: tecnicoService,
                    servicoService: servicoService,
                  ),
                ),
              ),
            );

            // Se voltar "true" (salvou com sucesso)
            if (recarregar == true) {
              osController.carregarOrdens();
            }
          },
          label: const Text('Nova Ordem'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
