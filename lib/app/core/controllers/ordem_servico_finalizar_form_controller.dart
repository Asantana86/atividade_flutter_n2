import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import '../base/base.controller.dart';
import '../models/cliente_model.dart';
import '../models/ordem_servico_model.dart';
import '../repositories/ordem_servico_repository.dart';
import '../validations/ordem_servico_validation.dart';
import '../services/cliente_service.dart';
import '../services/ordem_servico_service.dart';

import '../../shared/widgets/custom_date_picker.dart';
import '../../shared/widgets/custom_dropdown.dart';
import '../../shared/widgets/custom_elevated_button.dart';
import '../../shared/widgets/custom_image_picker.dart';
import '../../shared/widgets/custom_signature_pad.dart';
import '../../shared/widgets/custom_text_field.dart';

class OrdemServicoFinalizarFormController extends BaseController<
    OrdemServicoModel,
    OrdemServicoRepository,
    OrdemServicoValidation,
    OrdemServicoService> {
  
  final ClienteService clienteService;

  OrdemServicoFinalizarFormController(
    super.service, {
    required this.clienteService,
    super.model,
  });

  @override
  Widget buildPage(BuildContext context, OrdemServicoService service) {
    return _OrdemServicoFinishPage(controller: this);
  }
}

class _OrdemServicoFinishPage extends StatefulWidget {
  final OrdemServicoFinalizarFormController controller;

  const _OrdemServicoFinishPage({required this.controller});

  @override
  State<_OrdemServicoFinishPage> createState() => _OrdemServicoFinishPageState();
}

class _OrdemServicoFinishPageState extends State<_OrdemServicoFinishPage> {
  final _dataFimController = TextEditingController();
  final _obsController = TextEditingController();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  List<OrdemServicoModel> ordensAbertas = [];
  List<ClienteModel> clientes = [];
  
  OrdemServicoModel? ordemSelecionada;
  DateTime dataFim = DateTime.now();
  String? fotoDepoisPath;

  @override
  void initState() {
    super.initState();
    _dataFimController.text = DateFormat('dd/MM/yyyy').format(dataFim);
    _carregarDadosIniciais();
  }

  @override
  void dispose() {
    _dataFimController.dispose();
    _obsController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _carregarDadosIniciais() async {

    final result = await widget.controller.executeOperation(
      context,
      Future.wait([
        widget.controller.service.findAllActive(),
        widget.controller.clienteService.findAllActive(),
      ]),
      loadingMessage: 'Buscando ordens em aberto...',
    );

    if (result != null && mounted) {
      setState(() {
        final todasAsOrdens = result[0] as List<OrdemServicoModel>;
        clientes = result[1] as List<ClienteModel>;

        ordensAbertas = todasAsOrdens.where((os) => os.status == StatusOS.emAndamento).toList();

        if (widget.controller.model != null) {
          ordemSelecionada = ordensAbertas.firstWhere(
            (os) => os.id == widget.controller.model!.id,
            orElse: () => widget.controller.model!,
          );
        }
      });
    }
  }

  String _getLabelOrdem(OrdemServicoModel os) {
    final cliente = clientes.where((c) => c.id == os.clienteId).firstOrNull;
    return 'OS #${os.id} - ${cliente?.nome ?? "Cliente não encontrado"}';
  }

  Future<void> _finalizar() async {
    if (ordemSelecionada == null) {
      widget.controller.showError(context, 'Selecione uma Ordem', 
          details: 'É necessário escolher qual ordem deseja finalizar.');
      return;
    }

    final signatureBytes = await _signatureController.toPngBytes();
    String? assinaturaBase64 = signatureBytes != null ? base64Encode(signatureBytes) : null;

    final osFinalizada = OrdemServicoModel(
      id: ordemSelecionada!.id,
      createdAt: ordemSelecionada!.createdAt,
      clienteId: ordemSelecionada!.clienteId,
      tecnicoId: ordemSelecionada!.tecnicoId,
      servicoId: ordemSelecionada!.servicoId,
      dataInicio: ordemSelecionada!.dataInicio,
      fotoAntes: ordemSelecionada!.fotoAntes,
      dataFim: dataFim,
      fotoDepois: fotoDepoisPath ?? '',
      assinatura: assinaturaBase64 ?? '',
      observacaoFinal: _obsController.text,
      status: StatusOS.finalizado, 
    );

    final success = await widget.controller.executeCrudOperation(
      context,
      widget.controller.service.update(osFinalizada),
      loadingMessage: 'Finalizando...',
      successMessage: 'Ordem de serviço finalizada com sucesso!',
    );

    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Serviço'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomDropdown<OrdemServicoModel>(
              label: 'Ordem de Serviço em Aberto',
              items: ordensAbertas,
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
            CustomElevatedButton(
              text: 'Confirmar Finalização',
              icon: Icons.done_all,
              onPressed: _finalizar,
            ),
          ],
        ),
      ),
    );
  }
}