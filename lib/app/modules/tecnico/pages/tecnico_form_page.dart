import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../core/controllers/tecnico_form_controller.dart';

import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_elevated_button.dart';

class TecnicoFormPage extends StatefulWidget {
  final TecnicoFormController controller;

  const TecnicoFormPage({super.key, required this.controller});

  @override
  State<TecnicoFormPage> createState() => _TecnicoFormPageState();
}

class _TecnicoFormPageState extends BaseState<TecnicoFormPage, TecnicoFormController> {
  
  @override
  TecnicoFormController get controller => widget.controller;

  final _nomeController = TextEditingController();
  final _especialidadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (controller.isEditing) {
      final modelo = controller.model!;
      _nomeController.text = modelo.nome;
      _especialidadeController.text = modelo.especialidade ?? '';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _especialidadeController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    FocusScope.of(context).unfocus();

    final sucesso = await controller.salvarTecnico(
      nome: _nomeController.text,
      especialidade: _especialidadeController.text,
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
        title: Text(controller.isEditing ? 'Editar Técnico' : 'Novo Técnico'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomTextField(
              label: 'Nome do Técnico',
              controller: _nomeController,
              prefixIcon: Icons.person_outline,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Especialidade (Opcional)',
              hint: 'Ex: Fibra Óptica, Instalação, Reparo',
              controller: _especialidadeController,
              prefixIcon: Icons.build,
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