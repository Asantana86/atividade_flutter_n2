import 'package:flutter/material.dart';
import 'package:atividade_flutter_n2/app/core/services/user_service.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    final nomeUsuario = userService.nomeUsuario ?? "Visitante";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bem-vindo!",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Você logou como $nomeUsuario",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  UserService().limpar();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/auth/login',
                    (route) => false,
                  );
                },
                child: const Text("Sair"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
