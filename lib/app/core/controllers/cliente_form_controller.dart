import 'package:flutter/material.dart';

import '../base/base.controller.dart';
import '../models/cliente_model.dart';
import '../repositories/cliente_repository.dart';
import '../validations/cliente_validation.dart';
import '../services/cliente_service.dart';

import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/custom_elevated_button.dart';

class ClienteFormController extends BaseController<ClienteModel, ClienteRepository, ClienteValidation, ClienteService> {
  
  ClienteFormController(super.service, {super.model});

  @override
  Widget buildPage(BuildContext context, ClienteService service) {
    return _ClienteFormPage(controller: this, service: service, model: model);
  }
}

class _ClienteFormPage extends StatefulWidget {
  final ClienteFormController controller;
  final ClienteService service;
  final ClienteModel? model;

  const _ClienteFormPage({
    required this.controller,
    required this.service,
    this.model,
  });

  @override
  State<_ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<_ClienteFormPage> {
  final _nomeController = TextEditingController();
  final _documentoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool get isEditing => widget.model != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nomeController.text = widget.model!.nome;
      _documentoController.text = widget.model!.documento;
      _telefoneController.text = widget.model!.telefone;
      _emailController.text = widget.model!.email ?? '';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _documentoController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final cliente = ClienteModel(
      id: widget.model?.id,
      createdAt: widget.model?.createdAt,
      isSync: widget.model?.isSync ?? 0,
      ativo: widget.model?.ativo ?? true,
      nome: _nomeController.text,
      documento: _documentoController.text,
      telefone: _telefoneController.text,
      email: _emailController.text.trim().isEmpty ? null : _emailController.text,
    );

    final operation = isEditing 
        ? widget.service.update(cliente) 
        : widget.service.create(cliente);

    final success = await widget.controller.executeCrudOperation(
      context,
      operation,
      loadingMessage: isEditing ? 'Atualizando cliente...' : 'Salvando cliente...',
      successMessage: 'Cliente salvo com sucesso!',
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Cliente' : 'Novo Cliente'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              label: 'Nome Completo / Razão Social',
              controller: _nomeController,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Documento (CPF ou CNPJ)',
              hint: 'Apenas números',
              controller: _documentoController,
              prefixIcon: Icons.badge,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Telefone',
              hint: '(DDD) 99999-9999',
              controller: _telefoneController,
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'E-mail (Opcional)',
              controller: _emailController,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
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