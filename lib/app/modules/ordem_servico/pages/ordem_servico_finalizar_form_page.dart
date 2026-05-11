import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import '../../../core/base/base_state.dart';
import '../../../core/models/ordem_servico_model.dart';
import '../../../shared/widgets/custom_date_picker.dart';
import '../../../shared/widgets/custom_dropdown.dart';
import '../../../shared/widgets/custom_elevated_button.dart';
import '../../../shared/widgets/custom_image_picker.dart';
import '../../../shared/widgets/custom_signature_pad.dart';
import '../../../shared/widgets/custom_text_field.dart';

import '../../../core/controllers/ordem_servico_finalizar_form_controller.dart';

class OrdemServicoFinalizarFormPage extends StatefulWidget {
  final OrdemServicoFinalizarFormController controller;

  const OrdemServicoFinalizarFormPage({super.key, required this.controller});

  @override
  State<OrdemServicoFinalizarFormPage> createState() => _OrdemServicoFinalizarFormPageState();
}

class _OrdemServicoFinalizarFormPageState extends BaseState<OrdemServicoFinalizarFormPage, OrdemServicoFinalizarFormController> {
  
  @override
  OrdemServicoFinalizarFormController get controller => widget.controller;

  final _dataFimController = TextEditingController();
  final _obsController = TextEditingController();
  
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  OrdemServicoModel? ordemSelecionada;
  DateTime dataFim = DateTime.now();
  String? fotoDepoisPath;

  @override
  void initState() {
    super.initState();
    _dataFimController.text = DateFormat('dd/MM/yyyy').format(dataFim);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDadosIniciais();
    });
  }

  @override
  void dispose() {
    _dataFimController.dispose();
    _obsController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _carregarDadosIniciais() async {
    await controller.carregarDependencias(onError: onError);

    if (mounted) {
      setState(() {
        // Se o usuário abriu essa tela clicando direto em uma OS na lista:
        if (controller.model != null) {
          ordemSelecionada = controller.ordensAbertas.where(
            (os) => os.id == controller.model!.id
          ).firstOrNull ?? controller.model!;
        }
      });
    }
  }

  // Helper para mostrar o nome do cliente no Dropdown
  String _getLabelOrdem(OrdemServicoModel os) {
    final cliente = controller.clientes.where((c) => c.id == os.clienteId).firstOrNull;
    return 'OS #${os.id} - ${cliente?.nome ?? "Cliente não encontrado"}';
  }

  Future<void> _finalizar() async {
    if (ordemSelecionada == null) {
      onError('Selecione uma ordem de serviço para finalizar.');
      return;
    }

    // Fecha o teclado antes de processar
    FocusScope.of(context).unfocus();

    // Extrai a assinatura e converte para Base64
    final signatureBytes = await _signatureController.toPngBytes();
    String? assinaturaBase64 = signatureBytes != null ? base64Encode(signatureBytes) : null;

    final sucesso = await controller.finalizarOrdem(
      ordemSelecionada: ordemSelecionada!,
      dataFim: dataFim,
      observacaoFinal: _obsController.text,
      fotoDepoisPath: fotoDepoisPath,
      assinaturaBase64: assinaturaBase64,
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
      appBar: AppBar(title: const Text('Finalizar Serviço'), centerTitle: true),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, _) {
          
          if (isLoading && controller.ordensAbertas.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Buscando ordens em aberto...'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CustomDropdown<OrdemServicoModel>(
                  label: 'Ordem de Serviço em Aberto',
                  items: controller.ordensAbertas,
                  value: ordemSelecionada,
                  itemLabel: _getLabelOrdem,
                  prefixIcon: Icons.assignment_turned_in,
                  onChanged: (val) => setState(() => ordemSelecionada = val),
                ),
                const SizedBox(height: 16),
                CustomDatePicker(
                  label: 'Data de Finalização',
                  controller: _dataFimController,
                  initialDate: dataFim,
                  onDateSelected: (date) => setState(() => dataFim = date),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Relatório / Observações',
                  controller: _obsController,
                  maxLines: 3,
                  prefixIcon: Icons.edit_note,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 24),
                CustomImagePicker(
                  label: 'Foto do Serviço Concluído',
                  onImageSelected: (path) => setState(() => fotoDepoisPath = path),
                ),
                const SizedBox(height: 24),
                CustomSignaturePad(
                  label: 'Assinatura do Cliente',
                  controller: _signatureController,
                ),
                const SizedBox(height: 32),
                
                isLoading 
                  ? const CircularProgressIndicator()
                  : CustomElevatedButton(
                      text: 'Confirmar Finalização',
                      icon: Icons.done_all,
                      onPressed: _finalizar,
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}