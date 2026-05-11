import 'package:flutter/material.dart';

import '../modules/splash/pages/splash_page.dart';
import '../modules/auth/pages/login_page.dart';
import '../modules/auth/pages/register_page.dart';
import '../modules/dashboard/pages/dashboard_page.dart';

import '../core/repositories/cliente_repository.dart';
import '../core/validations/cliente_validation.dart';
import '../core/services/cliente_service.dart';
import '../core/controllers/cliente_list_controller.dart';
import '../modules/clientes/pages/cliente_list_page.dart';

import '../core/repositories/tecnico_repository.dart';
import '../core/validations/tecnico_validation.dart';
import '../core/services/tecnico_service.dart';
import '../modules/tecnico/pages/tecnico_list_page.dart';
import '../core/controllers/tecnico_list_controller.dart';

import '../core/repositories/servico_repository.dart';
import '../core/validations/servico_validation.dart';
import '../core/services/servico_service.dart';
import '../modules/servico/pages/servico_list_page.dart';
import '../core/controllers/servico_list_controller.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';

  static const gerenciarClientes = '/clientes';
  static const gerenciarTecnicos = '/tecnicos';
  static const gerenciarServicos = '/servicos';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    dashboard: (_) => const DashboardPage(),

    gerenciarClientes: (_) => ClienteListPage(
      controller: ClienteListController(
        ClienteService(ClienteValidation(ClienteRepository()), ClienteRepository()),
      ),
    ),

    gerenciarTecnicos: (_) => TecnicoListPage(
      controller: TecnicoListController(
        TecnicoService(TecnicoValidation(TecnicoRepository()), TecnicoRepository()),
      ),
    ),

    gerenciarServicos: (_) => ServicoListPage(
      controller: ServicoListController(
        ServicoService(ServicoValidation(ServicoRepository()), ServicoRepository()),
      ),
    ),
  };
}
