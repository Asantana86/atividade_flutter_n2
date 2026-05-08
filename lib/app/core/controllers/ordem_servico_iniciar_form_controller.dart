import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../base/base.controller.dart';
import '../models/cliente_model.dart';
import '../models/ordem_servico_model.dart';
import '../models/servico_model.dart';
import '../models/tecnico_model.dart';
import '../validations/ordem_servico_validation.dart';
import '../repositories/ordem_servico_repository.dart';
import '../services/cliente_service.dart';
import '../services/ordem_servico_service.dart';
import '../services/servico_service.dart';
import '../services/tecnico_service.dart';

import '../../shared/widgets/custom_dropdown.dart';
import '../../shared/widgets/custom_elevated_button.dart';
import '../../shared/widgets/custom_image_picker.dart';
import '../../shared/widgets/custom_date_picker.dart';

class OrdemServicoIniciarFormController extends BaseController<
    OrdemServicoModel,
    OrdemServicoRepository,
    OrdemServicoValidation,
    OrdemServicoService> {

  final ClienteService clienteService;
  final TecnicoService tecnicoService;
  final ServicoService servicoService;

  OrdemServicoIniciarFormController(
    super.service, {
    required this.clienteService,
    required this.tecnicoService,
    required this.servicoService,
    super.model,
  });

  @override
  Widget buildPage(BuildContext context, OrdemServicoService service) {
    return _OrdemServicoStartPage(controller: this);
  }
}

class _OrdemServicoStartPage extends StatefulWidget {
  final OrdemServicoIniciarFormController controller;

  const _OrdemServicoStartPage({required this.controller});

  @override
  State<_OrdemServicoStartPage> createState() => _OrdemServicoStartPageState();
}

class _OrdemServicoStartPageState extends State<_OrdemServicoStartPage> {

  final _dataInicioController = TextEditingController();

  List<ClienteModel> clientes = [];
  List<TecnicoModel> tecnicos = [];
  List<ServicoModel> servicos = [];

  ClienteModel? clienteSelecionado;
  TecnicoModel? tecnicoSelecionado;
  ServicoModel? servicoSelecionado;
  String? fotoAntesPath;
  DateTime dataInicio = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dataInicioController.text = DateFormat('dd/MM/yyyy').format(dataInicio);
    _carregarDados();
  }

  @override
  void dispose() {
    _dataInicioController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    final result = await widget.controller.executeOperation(
      context,
      Future.wait([
        widget.controller.clienteService.findAllActive(),
        widget.controller.tecnicoService.findAllActive(),
        widget.controller.servicoService.findAllActive(),
      ]),
      loadingMessage: 'Carregando cadastros...',
    );

    if (result != null && mounted) {
      setState(() {
        clientes = result[0] as List<ClienteModel>;
        tecnicos = result[1] as List<TecnicoModel>;
        servicos = result[2] as List<ServicoModel>;

        if (widget.controller.model != null) {
          final m = widget.controller.model!;
          clienteSelecionado = clientes.where((c) => c.id == m.clienteId).firstOrNull;
          tecnicoSelecionado = tecnicos.where((t) => t.id == m.tecnicoId).firstOrNull;
          servicoSelecionado = servicos.where((s) => s.id == m.servicoId).firstOrNull;
          fotoAntesPath = m.fotoAntes;
          dataInicio = m.dataInicio;
          
          _dataInicioController.text = DateFormat('dd/MM/yyyy').format(dataInicio);
        }
      });
    }
  }

  Future<void> _salvar() async {
    if (clienteSelecionado == null || tecnicoSelecionado == null || servicoSelecionado == null) {
      widget.controller.showError(context, 'Campos Obrigatórios', 
          details: 'Selecione o cliente, técnico e serviço para continuar.');
      return;
    }

    final os = OrdemServicoModel(
      id: widget.controller.model?.id,
      createdAt: widget.controller.model?.createdAt,
      clienteId: clienteSelecionado!.id!,
      tecnicoId: tecnicoSelecionado!.id!,
      servicoId: servicoSelecionado!.id!,
      dataInicio: dataInicio,
      fotoAntes: fotoAntesPath ?? '',
      status: StatusOS.emAndamento,
    );

    final operation = widget.controller.model != null
        ? widget.controller.service.update(os)
        : widget.controller.service.create(os);

    final success = await widget.controller.executeCrudOperation(
      context,
      operation,
      loadingMessage: 'Iniciando Ordem de Serviço...',
      successMessage: 'Ordem de Serviço iniciada!',
    );

    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Ordem de Serviço'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomDatePicker(
              label: 'Data de Início',
              controller: _dataInicioController,
              initialDate: dataInicio,
              onDateSelected: (date) => setState(() => dataInicio = date),
            ),
            const SizedBox(height: 16),
            CustomDropdown<ClienteModel>(
              label: 'Selecione o Cliente',
              items: clientes,
              value: clienteSelecionado,
              itemLabel: (c) => c.nome,
              prefixIcon: Icons.person,
              onChanged: (val) => setState(() => clienteSelecionado = val),
            ),
            const SizedBox(height: 16),
            CustomDropdown<TecnicoModel>(
              label: 'Selecione o Técnico',
              items: tecnicos,
              value: tecnicoSelecionado,
              itemLabel: (t) => t.nome,
              prefixIcon: Icons.engineering,
              onChanged: (val) => setState(() => tecnicoSelecionado = val),
            ),
            const SizedBox(height: 16),
            CustomDropdown<ServicoModel>(
              label: 'Selecione o Serviço',
              items: servicos,
              value: servicoSelecionado,
              itemLabel: (s) => s.descricao,
              prefixIcon: Icons.settings,
              onChanged: (val) => setState(() => servicoSelecionado = val),
            ),
            const SizedBox(height: 24),
            CustomImagePicker(
              label: 'Foto comprovando Início do Serviço',
              initialImagePath: fotoAntesPath,
              onImageSelected: (path) => setState(() => fotoAntesPath = path),
            ),
            const SizedBox(height: 32),
            CustomElevatedButton(
              text: widget.controller.model != null ? 'Atualizar Ordem' : 'Abrir Ordem de Serviço',
              icon: Icons.play_arrow,
              onPressed: _salvar,
            ),
          ],
        ),
      ),
    );
  }
}