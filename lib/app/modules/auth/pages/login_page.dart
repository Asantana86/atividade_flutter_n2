import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/mixins/loader.mixin.dart';
import '../../../core/mixins/messages.mixin.dart';
import '../../../core/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoaderMixin, MessagesMixin {
  late TextEditingController emailController;
  late TextEditingController senhaController;
  
  final AuthService _authService = AuthService();

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

  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final senha = senhaController.text;

    // Validação básica de tela
    if (email.isEmpty || senha.isEmpty) {
      showError(context, 'Preencha e-mail e senha.');
      return;
    }

    showLoading(context);

    try {
      // Faz o login direto no Supabase. 
      // Se a senha estiver errada ou e-mail não existir, ele cai no AuthException.
      await _authService.login(email, senha);
      
      if (mounted) {
        hideLoading(context);
        showSuccess(context, 'Login realizado com sucesso!');
        Navigator.pushReplacementNamed(context, '/dashboard'); 
      }
    } on AuthException {
      if (mounted) {
        hideLoading(context);
        showError(context, 'Credenciais inválidas ou usuário não encontrado.');
      }
    } catch (e) {
      if (mounted) {
        hideLoading(context);
        showError(context, 'Erro inesperado: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: AppLogo(width: 120, height: 120),
                  ),
                  Text(
                    "Bem-vindo",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Acesse sua conta para continuar",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  CustomTextField(
                    label: "E-mail",
                    controller: emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),

                  // Removidos os parâmetros textInputAction e onFieldSubmitted
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
                        showInfo(context, 'Recuperação de senha em breve.');
                      },
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
                    altura: 56,
                  ),
                  const SizedBox(height: 24),

                  Divider(color: colorScheme.outlineVariant),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Não tem conta? ",
                        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
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