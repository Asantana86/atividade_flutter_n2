import 'package:atividade_flutter_n2/app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'app_routes.dart';
//import 'core/theme/app_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ServiceFlow',
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
