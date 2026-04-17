import 'package:atividade_flutter_n2/app/modules/auth/pages/login_page.dart';
import 'package:atividade_flutter_n2/app/modules/user/pages/register_page.dart';
import 'package:atividade_flutter_n2/app/modules/dashboard/pages/dashboard_page.dart';
import 'package:flutter/material.dart';

//import 'modules/splash/pages/splash_page.dart';

class AppRoutes {
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const dashboard = '/dashboard';

  static Map<String, WidgetBuilder> get routes => {
    //splash: (_) => const SplashPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    dashboard: (_) => const DashboardPage(),
  };
}
