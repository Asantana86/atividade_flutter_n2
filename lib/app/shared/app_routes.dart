import 'package:flutter/material.dart';

import '../modules/splash/pages/splash_page.dart';
import '../modules/auth/pages/login_page.dart';
import '../modules/auth/pages/register_page.dart';
import '../modules/dashboard/pages/dashboard_page.dart';

import '../core/controllers/cliente_list_controller.dart';
import '../core/repositories/cliente_repository.dart';
import '../core/validations/cliente_validation.dart';
import '../core/services/cliente_service.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';

  static const gerenciarClientes = '/clientes';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    dashboard: (_) => const DashboardPage(),

    gerenciarClientes: (_) => ClienteListController(
      ClienteService(
        ClienteValidation(ClienteRepository()),
        ClienteRepository(),
      ),
    ),
  };
}
