import 'package:atividade_flutter_n2/app/shared/app_widget.dart';
import 'package:flutter/material.dart';

void main() {
 
  WidgetsFlutterBinding.ensureInitialized();

  
  runApp(const AppEntry());
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    
    return AppWidget();
  }
}
