import 'package:flutter/material.dart';

import '../base/base_controller.dart';
import '../models/servico_model.dart';
import '../repositories/servico_repository.dart';
import '../services/servico_service.dart';
import '../validations/servico_validation.dart';

import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/custom_elevated_button.dart';

class ServicoFormController
    extends
        BaseController<
          ServicoModel,
          ServicoRepository,
          ServicoValidation,
          ServicoService
        > {
  ServicoFormController(super.service, {super.model});

  @override
  Widget buildPage(BuildContext context, ServicoService service) {
    return _ServicoFormPage(controller: this, service: service, model: model);
  }
}

class _ServicoFormPage extends StatefulWidget {
  final ServicoFormController controller;
  final ServicoService service;
  final ServicoModel? model;

  const _ServicoFormPage({
    required this.controller,
    required this.service,
    this.model,
  });

  @override
  State<_ServicoFormPage> createState() => _ServicoFormPageState();
}

class _ServicoFormPageState extends State<_ServicoFormPage> {
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _tempoController = TextEditingController();

  bool get isEditing => widget.model != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _descricaoController.text = widget.model!.descricao;
      _precoController.text = widget.model!.preco.toString();
      _tempoController.text = widget.model!.tempoEstimado ?? '';
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _precoController.dispose();
    _tempoController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final precoDouble =
        double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0.0;

    final servico = ServicoModel(
      id: widget.model?.id,
      createdAt: widget.model?.createdAt,
      isSync: widget.model?.isSync ?? 0,
      ativo: widget.model?.ativo ?? true,
      descricao: _descricaoController.text,
      preco: precoDouble,
      tempoEstimado: _tempoController.text.trim().isEmpty
          ? null
          : _tempoController.text,
    );

    final operation = isEditing
        ? widget.service.update(servico)
        : widget.service.create(servico);

    final success = await widget.controller.executeCrudOperation(
      context,
      operation,
      loadingMessage: isEditing
          ? 'A atualizar serviço...'
          : 'A gravar serviço...',
      successMessage: 'Serviço gravado com sucesso!',
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Serviço' : 'Novo Serviço'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              label: 'Descrição do Serviço',
              controller: _descricaoController,
              prefixIcon: Icons.description_outlined,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Preço (R\$)',
              hint: '0.00',
              controller: _precoController,
              prefixIcon: Icons.attach_money,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Tempo Estimado (Opcional)',
              hint: 'Ex: 2 horas, 30 min, 2 dias',
              controller: _tempoController,
              prefixIcon: Icons.timer_outlined,
            ),
            const SizedBox(height: 32),
            CustomElevatedButton(
              text: 'Gravar',
              icon: Icons.check,
              onPressed: _salvar,
            ),
          ],
        ),
      ),
    );
  }
}
