import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_elevated_button.dart';

import '../../../core/controllers/usuario_form_controller.dart';

class UsuarioFormPage extends StatefulWidget {
  final UsuarioFormController controller;

  const UsuarioFormPage({super.key, required this.controller});

  @override
  State<UsuarioFormPage> createState() => _UsuarioFormPageState();
}

class _UsuarioFormPageState extends BaseState<UsuarioFormPage, UsuarioFormController> {
  
  @override
  UsuarioFormController get controller => widget.controller;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (controller.isEditing) {
      final modelo = controller.model!;
      _nomeController.text = modelo.nome;
      _emailController.text = modelo.email;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    FocusScope.of(context).unfocus();

    final sucesso = await controller.salvarUsuario(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      onSuccess: onSuccess, 
      onError: onError,     
    );

    if (sucesso && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Editar Perfil' : 'Novo Usuário'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomTextField(
              label: 'Nome',
              controller: _nomeController,
              prefixIcon: Icons.person_outline,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'E-mail',
              controller: _emailController,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              // Desativa a edição do e-mail no Supabase para não quebrar o login
              enabled: !controller.isEditing, 
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Senha',
              hint: controller.isEditing
                  ? 'Preencha apenas se quiser alterar a senha atual'
                  : 'Crie uma senha forte (Maiúscula, número e símbolo)',
              controller: _senhaController,
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 32),
            ValueListenableBuilder<bool>(
              valueListenable: controller.isLoading,
              builder: (context, isLoading, _) {
                if (isLoading) {
                  return const CircularProgressIndicator();
                }
                
                return CustomElevatedButton(
                  text: 'Salvar',
                  icon: Icons.save,
                  onPressed: _salvar,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}