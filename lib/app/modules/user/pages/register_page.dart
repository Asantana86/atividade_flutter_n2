import 'package:atividade_flutter_n2/app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:atividade_flutter_n2/app/shared/widgets/app_logo.dart';
import 'package:atividade_flutter_n2/app/core/services/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController nomeController;
  late TextEditingController emailController;
  late TextEditingController senhaController;
  late TextEditingController confirmaSenhaController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController();
    emailController = TextEditingController();
    senhaController = TextEditingController();
    confirmaSenhaController = TextEditingController();
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmaSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Registrar"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AppLogo(width: double.infinity, height: 200),
              ),
              const SizedBox(height: 32),
              CustomTextField(label: "Nome", controller: nomeController),
              const SizedBox(height: 16),
              CustomTextField(label: "Email", controller: emailController),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Senha",
                isPassword: true,
                controller: senhaController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Confirmar Senha",
                isPassword: true,
                controller: confirmaSenhaController,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (nomeController.text.isNotEmpty) {
                    UserService().setNomeUsuario(nomeController.text);
                    Navigator.pushNamed(context, '/dashboard');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Por favor, preencha o nome"),
                      ),
                    );
                  }
                },
                child: const Text("Registrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
