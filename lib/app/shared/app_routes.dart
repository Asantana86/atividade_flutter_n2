import 'package:flutter/material.dart';
import '../core/models/service_order_model.dart';
import '../modules/splash/pages/splash_page.dart';
import '../modules/auth/pages/login_page.dart';
import '../modules/auth/pages/register_page.dart';
import '../modules/dashboard/pages/dashboard_page.dart';
import '../modules/dashboard/pages/os_list_page.dart';
import '../modules/ordem_servico/pages/ordem_servico_page.dart';
import '../modules/ordem_servico/pages/iniciar/iniciar_ordem_servico_page.dart';
import '../modules/ordem_servico/pages/finalizar/finalizar_ordem_servico_page.dart';
import '../modules/ordem_servico/pages/detalhes/detalhes_ordem_servico_page.dart';
import '../modules/clientes/pages/cadastro_cliente_page.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const osList = '/os_list';
  static const novaOs = '/nova_os';
  static const iniciarOs = '/iniciar_os';
  static const finalizarOs = '/finalizar_os';
  static const detalhesOs = '/detalhes_os';
  static const cadastroCliente = '/cadastro_cliente';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    dashboard: (_) => DashboardPage(),
    osList: (_) => const OSListPage(),
    novaOs: (_) => const OrdemServicoPage(),
    iniciarOs: (_) => const IniciarOrdemServicoPage(),
    finalizarOs: (_) => const FinalizarOrdemServicoPage(),
    detalhesOs: (context) => DetalhesOrdemServicoPage(
      ordem: ModalRoute.of(context)!.settings.arguments as ServiceOrderModel,
    ),
    cadastroCliente: (_) => const CadastroClientePage(),
  };
}
