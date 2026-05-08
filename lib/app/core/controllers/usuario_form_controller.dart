import 'package:flutter/material.dart';

import '../base/base_controller.dart';
import '../models/usuario_model.dart';
import '../repositories/usuario_repository.dart';
import '../services/usuario_service.dart';
import '../validations/usuario_validation.dart';

import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/custom_elevated_button.dart';

class UsuarioFormController
    extends
        BaseController<
          UsuarioModel,
          UsuarioRepository,
          UsuarioValidation,
          UsuarioService
        > {
  // Recebe o model de forma opcional (se vier nulo, é cadastro; se vier preenchido, é edição)
  UsuarioFormController(super.service, {super.model});

  @override
  Widget buildPage(BuildContext context, UsuarioService service) {
    return _UsuarioFormPage(controller: this, service: service, model: model);
  }
}

class _UsuarioFormPage extends StatefulWidget {
  final UsuarioFormController controller;
  final UsuarioService service;
  final UsuarioModel? model;

  const _UsuarioFormPage({
    required this.controller,
    required this.service,
    this.model,
  });

  @override
  State<_UsuarioFormPage> createState() => _UsuarioFormPageState();
}

class _UsuarioFormPageState extends State<_UsuarioFormPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  // Getter para saber o modo da tela
  bool get isEditing => widget.model != null;

  @override
  void initState() {
    super.initState();
    // Preenche os campos se for edição
    if (isEditing) {
      _nomeController.text = widget.model!.nome;
      _emailController.text = widget.model!.email;
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
    final usuario = UsuarioModel(
      id: widget.model?.id,
      createdAt: widget.model?.createdAt,
      isSync: widget.model?.isSync ?? 0,
      ativo: widget.model?.ativo ?? true,
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
    );

    final operation = isEditing
        ? widget.service.update(usuario)
        : widget.service.create(usuario);

    final success = await widget.controller.executeCrudOperation(
      context,
      operation,
      loadingMessage: isEditing
          ? 'Atualizando usuário...'
          : 'Salvando usuário...',
      successMessage: 'Usuário salvo com sucesso!',
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Usuário' : 'Novo Usuário'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              label: 'Nome',
              controller: _nomeController,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'E-mail',
              controller: _emailController,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Senha',
              hint: isEditing
                  ? 'Digite para alterar a senha'
                  : 'Crie uma senha forte',
              controller: _senhaController,
              prefixIcon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 32),
            CustomElevatedButton(
              text: 'Salvar',
              icon: Icons.save,
              onPressed: _salvar,
            ),
          ],
        ),
      ),
    );
  }
}
