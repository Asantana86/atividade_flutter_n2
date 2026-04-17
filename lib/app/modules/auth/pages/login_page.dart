import 'package:flutter/material.dart';
import 'package:atividade_flutter_n2/app/shared/widgets/custom_text_field.dart';
import 'package:atividade_flutter_n2/app/shared/widgets/app_logo.dart';
import 'package:atividade_flutter_n2/app/shared/widgets/custom_button.dart';
import 'package:atividade_flutter_n2/app/core/mixins/loader.mixin.dart';
import 'package:atividade_flutter_n2/app/core/mixins/messages.mixin.dart';
import 'package:atividade_flutter_n2/app/core/models/user.model.dart';
import 'package:atividade_flutter_n2/app/core/services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoaderMixin, MessagesMixin {
  late TextEditingController emailController;
  late TextEditingController senhaController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    senhaController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (emailController.text.trim().isEmpty) {
      showError(context, 'Por favor, preencha o email');
      return;
    }

    if (senhaController.text.isEmpty) {
      showError(context, 'Por favor, preencha a senha');
      return;
    }

    final Cliente? usuario = UserService().usuario;
    if (usuario == null) {
      showError(context, 'Nenhum usuario cadastrado. Faca o registro primeiro');
      return;
    }

    final bool credenciaisValidas =
        usuario.email == emailController.text.trim() &&
        usuario.senha == senhaController.text;

    if (!credenciaisValidas) {
      showError(context, 'Email ou senha invalidos');
      return;
    }

    showLoading(context);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      hideLoading(context);
      showSuccess(context, 'Login realizado com sucesso');
      Navigator.pushNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: const AppLogo(),
                    ),
                  ),

                  // Subtítulo
                  Text(
                    "Bem-vindo",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Acesse sua conta para continuar",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 48),

                  // Email Field
                  CustomTextField(
                    label: "Email",
                    controller: emailController,
                    prefixIcon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 24),

                  
                  CustomTextField(
                    label: "Senha",
                    isPassword: true,
                    controller: senhaController,
                    prefixIcon: Icons.lock_outline,
                  ),

                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implementar recuperação de senha
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Esqueceu a senha?",
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  CustomButton(
                    texto: "Entrar",
                    onPressed: _handleLogin,
                    cor: colorScheme.primary,
                    altura: 56,
                    largura: double.infinity,
                  ),

                  const SizedBox(height: 24),

                 
                  Divider(color: Colors.grey[300]),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Não tem conta? ",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/auth/register'),
                        child: Text(
                          "Registre-se",
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
