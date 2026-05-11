import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/base/base_state.dart';
import '../../../core/models/cliente_model.dart';
import '../../../core/models/servico_model.dart';
import '../../../core/models/tecnico_model.dart';

import '../../../shared/widgets/custom_date_picker.dart';
import '../../../shared/widgets/custom_dropdown.dart';
import '../../../shared/widgets/custom_elevated_button.dart';
import '../../../shared/widgets/custom_image_picker.dart';

import '../../../core/controllers/ordem_servico_iniciar_form_controller.dart';

class OrdemServicoIniciarFormPage extends StatefulWidget {
  final OrdemServicoIniciarFormController controller;

  const OrdemServicoIniciarFormPage({super.key, required this.controller});

  @override
  State<OrdemServicoIniciarFormPage> createState() => _OrdemServicoIniciarFormPageState();
}

class _OrdemServicoIniciarFormPageState extends BaseState<OrdemServicoIniciarFormPage, OrdemServicoIniciarFormController> {
  
  @override
  OrdemServicoIniciarFormController get controller => widget.controller;

  final _dataInicioController = TextEditingController();

  ClienteModel? clienteSelecionado;
  TecnicoModel? tecnicoSelecionado;
  ServicoModel? servicoSelecionado;
  
  String? fotoAntesPath;
  DateTime dataInicio = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dataInicioController.text = DateFormat('dd/MM/yyyy').format(dataInicio);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarDadosIniciais();
    });
  }

  @override
  void dispose() {
    _dataInicioController.dispose();
    super.dispose();
  }

  Future<void> _carregarDadosIniciais() async {
    // 1. Espera o controller buscar as listas
    await controller.carregarDependencias(onError: onError);

    // 2. Preenche a tela se estivermos editando uma OS existente
    if (mounted && controller.isEditing) {
      setState(() {
        final m = controller.model!;
        
        // Encontra os objetos correspondentes aos IDs salvos
        clienteSelecionado = controller.clientes.where((c) => c.id == m.clienteId).firstOrNull;
        tecnicoSelecionado = controller.tecnicos.where((t) => t.id == m.tecnicoId).firstOrNull;
        servicoSelecionado = controller.servicos.where((s) => s.id == m.servicoId).firstOrNull;
        
        fotoAntesPath = m.fotoAntes;
        dataInicio = m.dataInicio;
        _dataInicioController.text = DateFormat('dd/MM/yyyy').format(dataInicio);
      });
    } else if (mounted) {
      // Se não for edição, apenas recarrega para as listas aparecerem nos dropdowns
      setState(() {}); 
    }
  }

  Future<void> _salvar() async {
    // 1. Validação visual
    if (clienteSelecionado == null || tecnicoSelecionado == null || servicoSelecionado == null) {
      onError('Selecione o cliente, técnico e serviço para continuar.');
      return;
    }

    // 2. Chama a lógica isolada no Controller
    final sucesso = await controller.salvarOrdem(
      clienteId: clienteSelecionado!.id!,
      tecnicoId: tecnicoSelecionado!.id!,
      servicoId: servicoSelecionado!.id!,
      dataInicio: dataInicio,
      fotoAntesPath: fotoAntesPath,
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
        title: Text(controller.isEditing ? 'Editar Ordem' : 'Nova Ordem de Serviço'),
        centerTitle: true,
      ),
      
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, child) {
          
          if (isLoading && controller.clientes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Preparando formulário...'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
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
                  items: controller.clientes,
                  value: clienteSelecionado,
                  itemLabel: (c) => c.nome,
                  prefixIcon: Icons.person,
                  onChanged: (val) => setState(() => clienteSelecionado = val),
                ),
                const SizedBox(height: 16),
                CustomDropdown<TecnicoModel>(
                  label: 'Selecione o Técnico',
                  items: controller.tecnicos,
                  value: tecnicoSelecionado,
                  itemLabel: (t) => t.nome,
                  prefixIcon: Icons.engineering,
                  onChanged: (val) => setState(() => tecnicoSelecionado = val),
                ),
                const SizedBox(height: 16),
                CustomDropdown<ServicoModel>(
                  label: 'Selecione o Serviço',
                  items: controller.servicos,
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
                
                isLoading
                    ? const CircularProgressIndicator()
                    : CustomElevatedButton(
                        text: controller.isEditing ? 'Atualizar Ordem' : 'Abrir Ordem de Serviço',
                        icon: Icons.play_arrow,
                        onPressed: _salvar,
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}