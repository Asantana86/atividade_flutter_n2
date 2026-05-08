import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/app_logo.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/mixins/loader.mixin.dart';
import '../../../core/mixins/messages.mixin.dart';
import '../../../core/services/auth_service.dart';

// Imports necessários para chamar sua validação
import '../../../core/models/usuario_model.dart';
import '../../../core/validations/usuario_validation.dart';
import '../../../core/repositories/usuario_repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with LoaderMixin, MessagesMixin {
  late TextEditingController nomeController;
  late TextEditingController emailController;
  late TextEditingController senhaController;
  late TextEditingController confirmaSenhaController;
  
  final AuthService _authService = AuthService();

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
    } else if (senha.length <= 6) {
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

  Future<void> _handleRegister() async {
    final nome = nomeController.text.trim();
    final email = emailController.text.trim();
    final senha = senhaController.text;

    if (!_senhasCorrespondem) {
      showError(context, "As senhas não correspondem.");
      return;
    }

    showLoading(context);

    try {
      final usuarioTemporario = UsuarioModel(
        nome: nome,
        email: email,
        senha: senha,
        ativo: true,
      );

      final validation = UsuarioValidation(UsuarioRepository());
      
      validation.validateFields(usuarioTemporario); 

      await validation.validateRulesCreate(usuarioTemporario); 

      await _authService.cadastrar(
        email: email, 
        senha: senha, 
        nomeCompleto: nome,
      );
      
      if (mounted) {
        hideLoading(context);
        showSuccess(context, "Cadastro realizado! Faça login para continuar.");
        Navigator.pop(context); 
      }
    } on AuthException catch (e) {
      if (mounted) {
        hideLoading(context);
        showError(context, 'Falha no cadastro: ${e.message}');
      }
    } catch (e) {
      if (mounted) {
        hideLoading(context);
        showError(context, e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Conta"),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: AppLogo(width: 100, height: 100),
                  ),
                  Text(
                    "Crie sua conta",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Junte-se ao ServiceFlow agora",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  CustomTextField(
                    label: "Nome completo",
                    controller: nomeController,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "E-mail",
                    controller: emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: "Senha",
                    isPassword: true,
                    controller: senhaController,
                    prefixIcon: Icons.lock_outline,
                  ),

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
                                backgroundColor: colorScheme.surfaceContainerHighest,
                                valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor()),
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

                  // Removidos os parâmetros textInputAction e onFieldSubmitted
                  CustomTextField(
                    label: "Confirmar Senha",
                    isPassword: true,
                    controller: confirmaSenhaController,
                    prefixIcon: Icons.lock_outline,
                  ),

                  if (confirmaSenhaController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            _senhasCorrespondem ? Icons.check_circle : Icons.cancel,
                            color: _senhasCorrespondem ? Colors.green : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _senhasCorrespondem ? "Senhas correspondem" : "Senhas não correspondem",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _senhasCorrespondem ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 32),

                  CustomButton(
                    texto: "Registrar",
                    onPressed: _handleRegister,
                    altura: 56,
                  ),
                  const SizedBox(height: 16),

                  Divider(color: colorScheme.outlineVariant),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Já tem conta? ",
                        style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Faça login",
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