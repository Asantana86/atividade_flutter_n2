import 'package:flutter/material.dart';
import 'package:atividade_flutter_n2/app/shared/widgets/custom_text_field.dart';
import 'package:atividade_flutter_n2/app/shared/widgets/app_logo.dart';
import 'package:atividade_flutter_n2/app/shared/widgets/custom_button.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(),

            const SizedBox(height: 32),

            CustomTextField(
              controller: emailController,
              label: "Email",
              hint: "Digite seu email",
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              controller: senhaController,
              label: "Senha",
              hint: "Digite sua senha",
              prefixIcon: Icons.lock,
              isPassword: true,
            ),

            const SizedBox(height: 32),

            CustomButton(
              texto: "Entrar",
              cor: Colors.blue,
              onPressed: () {
                print("Login clicado");
              },
            ),
          ],
        ),
      ),
    );
  }
}
