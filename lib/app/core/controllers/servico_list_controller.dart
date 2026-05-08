import 'package:flutter/material.dart';

import '../base/base.controller.dart';
import '../models/servico_model.dart';
import '../repositories/servico_repository.dart';
import '../services/servico_service.dart';
import '../validations/servico_validation.dart';
import 'servico_form_controller.dart';

import '../../shared/widgets/custom_card.dart';

class ServicoListController extends BaseController<ServicoModel, ServicoRepository, ServicoValidation, ServicoService> {
  
  ServicoListController(super.service);

  @override
  Widget buildPage(BuildContext context, ServicoService service) {
    return _ServicoListPage(controller: this, service: service);
  }
}

class _ServicoListPage extends StatefulWidget {
  final ServicoListController controller;
  final ServicoService service;

  const _ServicoListPage({required this.controller, required this.service});

  @override
  State<_ServicoListPage> createState() => _ServicoListPageState();
}

class _ServicoListPageState extends State<_ServicoListPage> {
  List<ServicoModel> servicos = [];

  @override
  void initState() {
    super.initState();
    _carregarServicos();
  }

  Future<void> _carregarServicos() async {
    final result = await widget.controller.executeListOperation(
      context,
      widget.service.findAllActive(),
    );
    
    if (mounted) {
      setState(() => servicos = result);
    }
  }

  Future<void> _excluirServico(ServicoModel servico) async {
    final success = await widget.controller.executeCrudOperation(
      context,
      widget.service.softDelete(servico.id!),
      requiresConfirmation: true,
      confirmTitle: 'Excluir Serviço',
      confirmMessage: 'Deseja remover o serviço: ${servico.descricao}?',
      successMessage: 'Serviço removido com sucesso!',
    );

    if (success) {
      _carregarServicos();
    }
  }

  void _navegarParaFormulario([ServicoModel? model]) async {
    final recarregar = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ServicoFormController(widget.service, model: model),
      ),
    );

    if (recarregar == true) {
      _carregarServicos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Serviços'),
        centerTitle: true,
      ),
      body: servicos.isEmpty
          ? const Center(child: Text('Nenhum serviço cadastrado.'))
          : ListView.builder(
              itemCount: servicos.length,
              itemBuilder: (context, index) {
                final servico = servicos[index];
                return CustomCard(
                  title: servico.descricao,
                  subtitle: servico.tempoEstimado?.isNotEmpty == true 
                      ? 'Tempo estimado: ${servico.tempoEstimado}' 
                      : 'Tempo não definido',
                  icon: Icons.miscellaneous_services,
                  trailing: Text(
                    'R\$ ${servico.preco.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  onEdit: () => _navegarParaFormulario(servico),
                  onDelete: () => _excluirServico(servico),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegarParaFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}