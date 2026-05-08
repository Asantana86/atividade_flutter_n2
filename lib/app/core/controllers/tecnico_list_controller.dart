import 'package:flutter/material.dart';

import '../base/base.controller.dart';
import '../models/tecnico_model.dart';
import '../repositories/tecnico_repository.dart';
import '../services/tecnico_service.dart';
import '../validations/tecnico_validation.dart';
import 'tecnico_form_controller.dart';

import '../../shared/widgets/custom_card.dart';


class TecnicoListController extends BaseController<TecnicoModel, TecnicoRepository, TecnicoValidation, TecnicoService> {
  
  TecnicoListController(super.service);

  @override
  Widget buildPage(BuildContext context, TecnicoService service) {
    return _TecnicoListPage(controller: this, service: service);
  }
}

class _TecnicoListPage extends StatefulWidget {
  final TecnicoListController controller;
  final TecnicoService service;

  const _TecnicoListPage({required this.controller, required this.service});

  @override
  State<_TecnicoListPage> createState() => _TecnicoListPageState();
}

class _TecnicoListPageState extends State<_TecnicoListPage> {
  List<TecnicoModel> tecnicos = [];

  @override
  void initState() {
    super.initState();
    _carregarTecnicos();
  }

  Future<void> _carregarTecnicos() async {
    final result = await widget.controller.executeListOperation(
      context,
      widget.service.findAllActive(),
    );
    
    if (mounted) {
      setState(() => tecnicos = result);
    }
  }

  Future<void> _excluirTecnico(TecnicoModel tecnico) async {
    final success = await widget.controller.executeCrudOperation(
      context,
      widget.service.softDelete(tecnico.id!),
      requiresConfirmation: true,
      confirmTitle: 'Excluir Técnico',
      confirmMessage: 'Tem certeza que deseja excluir o técnico ${tecnico.nome}?',
      successMessage: 'Técnico excluído com sucesso!',
    );

    if (success) {
      _carregarTecnicos();
    }
  }

  void _navegarParaFormulario([TecnicoModel? model]) async {
    final recarregar = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TecnicoFormController(widget.service, model: model),
      ),
    );

    if (recarregar == true) {
      _carregarTecnicos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Técnicos'),
        centerTitle: true,
      ),
      body: tecnicos.isEmpty
          ? const Center(child: Text('Nenhum técnico encontrado.'))
          : ListView.builder(
              itemCount: tecnicos.length,
              itemBuilder: (context, index) {
                final tecnico = tecnicos[index];
                return CustomCard(
                  title: tecnico.nome,
                  subtitle: tecnico.especialidade?.isNotEmpty == true 
                      ? tecnico.especialidade! 
                      : 'Sem especialidade definida',
                  icon: Icons.engineering,
                  onEdit: () => _navegarParaFormulario(tecnico),
                  onDelete: () => _excluirTecnico(tecnico),
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