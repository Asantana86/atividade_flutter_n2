import 'package:atividade_flutter_n2/app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:atividade_flutter_n2/app/shared/widgets/app_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController senhaController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    senhaController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: AppLogo(width: double.infinity, height: 250),
              ),

              const SizedBox(height: 48),

              CustomTextField(label: "Email", controller: emailController),

              const SizedBox(height: 16),

              CustomTextField(
                label: "Senha",
                isPassword: true,
                controller: senhaController,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/dashboard'),
                child: const Text("Enter"),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Não tem conta? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/auth/register'),
                    child: const Text(
                      "Registre-se",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
