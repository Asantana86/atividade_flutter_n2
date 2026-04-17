import 'package:atividade_flutter_n2/app/shared/app_widget.dart';
import 'package:flutter/material.dart';

void main() {
  // 1. Garante a inicialização da comunicação com o sistema nativo
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Exemplo: Aqui deve-se carregar o Banco de Dados ou as Configurações
  // await DatabaseHelper.instance.init();

  runApp(const AppEntry());
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    
    return AppWidget();
  }
}
