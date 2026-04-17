import 'package:atividade_flutter_n2/app/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:atividade_flutter_n2/app/shared/widgets/app_logo.dart';
import 'package:atividade_flutter_n2/app/shared/widgets/custom_button.dart';
import 'package:atividade_flutter_n2/app/core/mixins/loader.mixin.dart';
import 'package:atividade_flutter_n2/app/core/mixins/messages.mixin.dart';
import 'package:atividade_flutter_n2/app/core/models/user.model.dart';
import 'package:atividade_flutter_n2/app/core/services/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
  with LoaderMixin, MessagesMixin {
  late TextEditingController nomeController;
  late TextEditingController emailController;
  late TextEditingController senhaController;
  late TextEditingController confirmaSenhaController;
  double _passwordStrength = 0;
  bool _senhasCorrespondem = false;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController();
    emailController = TextEditingController();
    senhaController = TextEditingController();
    confirmaSenhaController = TextEditingController();
    senhaController.addListener(_updatePasswordStrength);
    confirmaSenhaController.addListener(_checkSenhasCorrespondem);
  }

  void _updatePasswordStrength() {
    final senha = senhaController.text;
    double strength = 0;
    if (senha.isEmpty) {
      strength = 0;
    } else if (senha.length < 6) {
      strength = 0.33;
    } else if (senha.length < 10) {
      strength = 0.66;
    } else {
      strength = 1;
    }
    setState(() => _passwordStrength = strength);
  }

  void _checkSenhasCorrespondem() {
    setState(() {
      _senhasCorrespondem = senhaController.text == confirmaSenhaController.text &&
          senhaController.text.isNotEmpty;
    });
  }

  Color _getStrengthColor() {
    if (_passwordStrength < 0.34) return Colors.red;
    if (_passwordStrength < 0.67) return Colors.orange;
    return Colors.green;
  }

  String _getStrengthText() {
    if (_passwordStrength < 0.34) return "Fraca";
    if (_passwordStrength < 0.67) return "Média";
    return "Forte";
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmaSenhaController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (nomeController.text.isEmpty) {
      showError(context, "Por favor, preencha o nome");
      return;
    }
    if (emailController.text.isEmpty) {
      showError(context, "Por favor, preencha o email");
      return;
    }
    if (senhaController.text.isEmpty) {
      showError(context, "Por favor, preencha a senha");
      return;
    }
    if (!_senhasCorrespondem) {
      showError(context, "As senhas não correspondem");
      return;
    }

    showLoading(context);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      final novoUsuario = Cliente(
        nome: nomeController.text.trim(),
        email: emailController.text.trim(),
        senha: senhaController.text,
      );
      UserService().setUsuario(novoUsuario);
      hideLoading(context);
      showSuccess(context, "Cadastro realizado com sucesso");
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Criar Conta"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                      width: 100,
                      height: 100,
                      child: const AppLogo(),
                    ),
                  ),

                  // Título
                  Text(
                    "Crie sua conta",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Junte-se a ServiceFlow agora",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Nome Field
                  CustomTextField(
                    label: "Nome completo",
                    controller: nomeController,
                    prefixIcon: Icons.person_outline,
                  ),

                  const SizedBox(height: 16),

                  // Email Field
                  CustomTextField(
                    label: "Email",
                    controller: emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  // Senha Field
                  CustomTextField(
                    label: "Senha",
                    isPassword: true,
                    controller: senhaController,
                    prefixIcon: Icons.lock_outline,
                  ),

                  // Indicador de Força da Senha
                  if (senhaController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: _passwordStrength,
                                minHeight: 4,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getStrengthColor(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getStrengthText(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getStrengthColor(),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Confirmar Senha Field
                  CustomTextField(
                    label: "Confirmar Senha",
                    isPassword: true,
                    controller: confirmaSenhaController,
                    prefixIcon: Icons.lock_outline,
                  ),

                  // Indicador se as senhas correspondem
                  if (confirmaSenhaController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            _senhasCorrespondem
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: _senhasCorrespondem
                                ? Colors.green
                                : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _senhasCorrespondem
                                ? "Senhas correspondem"
                                : "Senhas não correspondem",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _senhasCorrespondem
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Botão Registrar
                  CustomButton(
                    texto: "Registrar",
                    onPressed: _handleRegister,
                    cor: theme.colorScheme.primary,
                    altura: 56,
                    largura: double.infinity,
                  ),

                  const SizedBox(height: 16),

                  // Divider
                  Divider(color: Colors.grey[300]),

                  const SizedBox(height: 16),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Já tem conta? ",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Faça login",
                          style: TextStyle(
                            color: theme.colorScheme.primary,
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
