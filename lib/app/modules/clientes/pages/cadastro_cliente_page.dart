import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../core/mixins/loader.mixin.dart';
import '../../../core/mixins/messages.mixin.dart';
import '../../../core/models/cliente_model.dart';
import '../../../core/services/cliente_service.dart';
import '../../../../app/shared/widgets/custom_button.dart';
import '../../../../app/shared/widgets/custom_text_field.dart';

class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({super.key});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> with LoaderMixin, MessagesMixin {
  final _formKey = GlobalKey<FormState>();
  
  final _nomeController = TextEditingController();
  final _documentoController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final _documentoMask = MaskTextInputFormatter(
    mask: '###.###.###-##', 
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void dispose() {
    _nomeController.dispose();
    _documentoController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _salvarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    showLoading(context);
    
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final novoCliente = ClienteModel(
      nome: _nomeController.text.trim(),
      documento: _documentoController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim(),
    );

    ClienteService().add(novoCliente);

    hideLoading(context);

    showSuccess(context, 'Cliente cadastrado com sucesso!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Cliente'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dados do Cliente",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Preencha as informações para vincular futuras ordens de serviço.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                CustomTextField(
                  label: "Nome ou Razão Social",
                  controller: _nomeController,
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O nome é obrigatório.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: "CPF",
                  hint: "000.000.000-00",
                  controller: _documentoController,
                  prefixIcon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [_documentoMask], // Aplicando a máscara
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O documento é obrigatório.';
                    }
                    if (value.length < 14) {
                      return 'CPF incompleto.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: "E-mail",
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O e-mail é obrigatório.';
                    }
                    if (!value.contains('@')) {
                      return 'Informe um e-mail válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: "Telefone / WhatsApp",
                  hint: "(00) 00000-0000",
                  controller: _telefoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [_telefoneMask], // Aplicando a máscara
                  onFieldSubmitted: _salvarCliente, // Salva ao dar "Enter" no teclado
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O telefone é obrigatório.';
                    }
                    if (value.length < 14) {
                      return 'Telefone incompleto.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 48),

                CustomButton(
                  texto: "Salvar Cliente",
                  onPressed: _salvarCliente,
                  altura: 56,
                  cor: colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}