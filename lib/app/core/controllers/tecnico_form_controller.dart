import 'package:flutter/material.dart';

import '../base/base.controller.dart';
import '../models/tecnico_model.dart';
import '../repositories/tecnico_repository.dart';
import '../services/tecnico_service.dart';
import '../validations/tecnico_validation.dart';

import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/custom_elevated_button.dart';

class TecnicoFormController extends BaseController<TecnicoModel, TecnicoRepository, TecnicoValidation, TecnicoService> {
  
  TecnicoFormController(super.service, {super.model});

  @override
  Widget buildPage(BuildContext context, TecnicoService service) {
    return _TecnicoFormPage(controller: this, service: service, model: model);
  }
}

class _TecnicoFormPage extends StatefulWidget {
  final TecnicoFormController controller;
  final TecnicoService service;
  final TecnicoModel? model;

  const _TecnicoFormPage({
    required this.controller,
    required this.service,
    this.model,
  });

  @override
  State<_TecnicoFormPage> createState() => _TecnicoFormPageState();
}

class _TecnicoFormPageState extends State<_TecnicoFormPage> {
  final _nomeController = TextEditingController();
  final _especialidadeController = TextEditingController();

  bool get isEditing => widget.model != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nomeController.text = widget.model!.nome;
      _especialidadeController.text = widget.model!.especialidade ?? '';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _especialidadeController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final tecnico = TecnicoModel(
      id: widget.model?.id,
      createdAt: widget.model?.createdAt,
      isSync: widget.model?.isSync ?? 0,
      ativo: widget.model?.ativo ?? true,
      nome: _nomeController.text,
      especialidade: _especialidadeController.text.trim().isEmpty ? null : _especialidadeController.text,
    );

    final operation = isEditing 
        ? widget.service.update(tecnico) 
        : widget.service.create(tecnico);

    final success = await widget.controller.executeCrudOperation(
      context,
      operation,
      loadingMessage: isEditing ? 'Atualizando técnico...' : 'Salvando técnico...',
      successMessage: 'Técnico salvo com sucesso!',
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Técnico' : 'Novo Técnico'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              label: 'Nome do Técnico',
              controller: _nomeController,
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Especialidade (Opcional)',
              hint: 'Ex: Fibra Óptica, Instalação, Reparo',
              controller: _especialidadeController,
              prefixIcon: Icons.build,
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