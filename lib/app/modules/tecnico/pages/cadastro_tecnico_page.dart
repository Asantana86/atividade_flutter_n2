import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/mixins/loader.mixin.dart';
import '../../../core/mixins/messages.mixin.dart';
import '../../../core/controllers/tecnico_controller.dart';
import '../../../../app/shared/widgets/custom_button.dart';
import '../../../../app/shared/widgets/custom_text_field.dart';

class CadastroTecnicoPage extends StatefulWidget {
  const CadastroTecnicoPage({super.key});

  @override
  State<CadastroTecnicoPage> createState() => _CadastroTecnicoPageState();
}

class _CadastroTecnicoPageState extends State<CadastroTecnicoPage> with LoaderMixin, MessagesMixin {
  final _formKey = GlobalKey<FormState>();
  
  final _nomeController = TextEditingController();
  final _especialidadeController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _especialidadeController.dispose();
    super.dispose();
  }

  Future<void> _salvarTecnico() async {
    if (!_formKey.currentState!.validate()) return;

    showLoading(context);
    
    final controller = context.read<TecnicoController>();

    await controller.salvarTecnico(
      nome: _nomeController.text.trim(),
      especialidade: _especialidadeController.text.trim(),
    );

    if (!mounted) return;
    
    hideLoading(context);

    if (controller.errorMessage != null) {
      showError(context, controller.errorMessage!);
    } else if (controller.isSuccess) {
      showSuccess(context, 'Técnico cadastrado com sucesso!');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Técnico'),
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
                  "Dados do Técnico",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Cadastre os profissionais que irão executar as ordens de serviço.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                CustomTextField(
                  label: "Nome Completo",
                  controller: _nomeController,
                  prefixIcon: Icons.badge_outlined,
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
                  label: "Especialidade (Opcional)",
                  hint: "Ex: Eletricista, Encanador, TI...",
                  controller: _especialidadeController,
                  prefixIcon: Icons.engineering_outlined,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: () => _salvarTecnico(),
                ),
                const SizedBox(height: 48),

                CustomButton(
                  texto: "Salvar Técnico",
                  onPressed: _salvarTecnico,
                  altura: 56,
                  cor: colorScheme.primary,
                  icon: Icons.check,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}