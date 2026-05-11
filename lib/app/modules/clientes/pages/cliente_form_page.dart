import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_elevated_button.dart';

import '../../../core/controllers/cliente_form_controller.dart';

class ClienteFormPage extends StatefulWidget {
  final ClienteFormController controller;

  const ClienteFormPage({super.key, required this.controller});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends BaseState<ClienteFormPage, ClienteFormController> {
  
  @override
  ClienteFormController get controller => widget.controller;

  final _nomeController = TextEditingController();
  final _documentoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (controller.isEditing) {
      final modelo = controller.model!;
      _nomeController.text = modelo.nome;
      _documentoController.text = modelo.documento;
      _telefoneController.text = modelo.telefone;
      _emailController.text = modelo.email ?? '';
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

    FocusScope.of(context).unfocus();

    final sucesso = await controller.salvarCliente(
      nome: _nomeController.text,
      documento: _documentoController.text,
      telefone: _telefoneController.text,
      email: _emailController.text,
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
        title: Text(controller.isEditing ? 'Editar Cliente' : 'Novo Cliente'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CustomTextField(
              label: 'Nome Completo / Razão Social',
              controller: _nomeController,
              prefixIcon: Icons.person,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Documento (CPF ou CNPJ)',
              hint: 'Apenas números',
              controller: _documentoController,
              prefixIcon: Icons.badge,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Telefone',
              hint: '(DDD) 99999-9999',
              controller: _telefoneController,
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'E-mail (Opcional)',
              controller: _emailController,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
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