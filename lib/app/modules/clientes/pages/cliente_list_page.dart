import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../core/models/cliente_model.dart';
import '../../../shared/widgets/custom_card.dart';

import '../../../core/controllers/cliente_list_controller.dart';
import '../../../core/controllers/cliente_form_controller.dart';

import './cliente_form_page.dart';

class ClienteListPage extends StatefulWidget {
  final ClienteListController controller;

  const ClienteListPage({super.key, required this.controller});

  @override
  State<ClienteListPage> createState() => _ClienteListPageState();
}

class _ClienteListPageState extends BaseState<ClienteListPage, ClienteListController> {
  
  @override
  ClienteListController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.carregarClientes(onError: onError); 
    });
  }

  Future<void> _excluirCliente(ClienteModel cliente) async {
    final confirmed = await showConfirmation(
      context,
      'Excluir Cliente',
      'Tem certeza que deseja excluir o cliente ${cliente.nome}?',
    );

    if (confirmed == true) {
      await controller.excluirCliente(
        cliente.id!,
        onSuccess: onSuccess,
        onError: onError,
      );
    }
  }

  void _navegarParaFormulario([ClienteModel? model]) async {
    final recarregar = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ClienteFormPage(
          controller: ClienteFormController(controller.service, model: model),
        ),
      ),
    );

    if (recarregar == true) {
      controller.carregarClientes(onError: onError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes'), centerTitle: true),
      
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, _) {
          
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<List<ClienteModel>>(
            valueListenable: controller.clientes,
            builder: (context, clientes, _) {
              
              if (clientes.isEmpty) {
                return const Center(child: Text('Nenhum cliente encontrado.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: clientes.length,
                itemBuilder: (context, index) {
                  final cliente = clientes[index];
                  
                  return CustomCard(
                    title: cliente.nome,
                    subtitle: 'Doc: ${cliente.documento}\nTel: ${cliente.telefone}',
                    icon: Icons.business_center,
                    onEdit: () => _navegarParaFormulario(cliente),
                    onDelete: () => _excluirCliente(cliente),
                  );
                },
              );
            },
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