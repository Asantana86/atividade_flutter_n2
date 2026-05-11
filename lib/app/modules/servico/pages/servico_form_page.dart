import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_elevated_button.dart';

import '../../../core/controllers/servico_form_controller.dart';

class ServicoFormPage extends StatefulWidget {
  final ServicoFormController controller;

  const ServicoFormPage({super.key, required this.controller});

  @override
  State<ServicoFormPage> createState() => _ServicoFormPageState();
}

class _ServicoFormPageState extends BaseState<ServicoFormPage, ServicoFormController> {
  
  @override
  ServicoFormController get controller => widget.controller;

  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _tempoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (controller.isEditing) {
      final modelo = controller.model!;
      _descricaoController.text = modelo.descricao;
      _precoController.text = modelo.preco.toString();
      _tempoController.text = modelo.tempoEstimado ?? '';
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
    FocusScope.of(context).unfocus();

    final sucesso = await controller.salvarServico(
      descricao: _descricaoController.text,
      precoStr: _precoController.text,
      tempoEstimado: _tempoController.text,
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
        title: Text(controller.isEditing ? 'Editar Serviço' : 'Novo Serviço'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomTextField(
              label: 'Descrição do Serviço',
              controller: _descricaoController,
              prefixIcon: Icons.description_outlined,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Preço (R\$)',
              hint: '0.00',
              controller: _precoController,
              prefixIcon: Icons.attach_money,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Tempo Estimado (Opcional)',
              hint: 'Ex: 2 horas, 30 min, 2 dias',
              controller: _tempoController,
              prefixIcon: Icons.timer_outlined,
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
                  text: 'Gravar',
                  icon: Icons.check,
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