import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/controllers/cliente_controller.dart';
import '../core/controllers/tecnico_controller.dart';
import '../core/controllers/servico_controller.dart';
import '../core/controllers/os_item_controller.dart';
import '../core/controllers/service_order_controller.dart';
import '../core/theme/app_theme.dart';
import 'app_routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClienteController()), 
        ChangeNotifierProvider(create: (_) => TecnicoController()),
        ChangeNotifierProvider(create: (_) => ServicoController()),
        ChangeNotifierProvider(create: (_) => OsItemController()),
        ChangeNotifierProvider(create: (_) => ServiceOrderController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ServiceFlow',
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash, 
        routes: AppRoutes.routes,
      ),
    );
  }
}