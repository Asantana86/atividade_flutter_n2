import 'package:flutter/material.dart';

import '../base/base_controller.dart';
import '../models/cliente_model.dart';
import '../repositories/cliente_repository.dart';
import '../services/cliente_service.dart';
import '../validations/cliente_validation.dart';
import 'cliente_form_controller.dart';

import '../../shared/widgets/custom_card.dart';

class ClienteListController
    extends
        BaseController<
          ClienteModel,
          ClienteRepository,
          ClienteValidation,
          ClienteService
        > {
  ClienteListController(super.service);

  @override
  Widget buildPage(BuildContext context, ClienteService service) {
    return _ClienteListPage(controller: this, service: service);
  }
}

class _ClienteListPage extends StatefulWidget {
  final ClienteListController controller;
  final ClienteService service;

  const _ClienteListPage({required this.controller, required this.service});

  @override
  State<_ClienteListPage> createState() => _ClienteListPageState();
}

class _ClienteListPageState extends State<_ClienteListPage> {
  List<ClienteModel> clientes = [];

  @override
  void initState() {
    super.initState();
    // Pede para o Flutter esperar a tela ser desenhada para só então carregar os dados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarClientes();
    });
  }

  Future<void> _carregarClientes() async {
    final result = await widget.controller.executeListOperation(
      context,
      widget.service.findAllActive(),
    );

    if (mounted) {
      setState(() => clientes = result);
    }
  }

  Future<void> _excluirCliente(ClienteModel cliente) async {
    final success = await widget.controller.executeCrudOperation(
      context,
      widget.service.softDelete(cliente.id!),
      requiresConfirmation: true,
      confirmTitle: 'Excluir Cliente',
      confirmMessage:
          'Tem certeza que deseja excluir o cliente ${cliente.nome}?',
      successMessage: 'Cliente excluído com sucesso!',
    );

    if (success) {
      _carregarClientes();
    }
  }

  void _navegarParaFormulario([ClienteModel? model]) async {
    final recarregar = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ClienteFormController(widget.service, model: model),
      ),
    );

    if (recarregar == true) {
      _carregarClientes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes'), centerTitle: true),
      body: clientes.isEmpty
          ? const Center(child: Text('Nenhum cliente encontrado.'))
          : ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return CustomCard(
                  title: cliente.nome,
                  subtitle:
                      'Doc: ${cliente.documento}\nTel: ${cliente.telefone}',
                  icon: Icons.business_center,
                  onEdit: () => _navegarParaFormulario(cliente),
                  onDelete: () => _excluirCliente(cliente),
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
