import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../core/models/cliente_model.dart';
import '../../../shared/widgets/custom_text_field.dart';

import '../../../core/controllers/cliente_detalhes_controller.dart';

class ClienteDetalhesPage extends StatefulWidget {
  final ClienteDetalhesController controller;

  const ClienteDetalhesPage({super.key, required this.controller});

  @override
  State<ClienteDetalhesPage> createState() => _ClienteDetalhesPageState();
}

class _ClienteDetalhesPageState
    extends BaseState<ClienteDetalhesPage, ClienteDetalhesController> {
  @override
  ClienteDetalhesController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.carregarCliente(onError: onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Cliente'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<ClienteModel?>(
            valueListenable: controller.cliente,
            builder: (context, cliente, _) {
              if (cliente == null) {
                return const Center(child: Text('Cliente não encontrado.'));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Nome Completo / Razão Social',
                      controller: TextEditingController(text: cliente.nome),
                      prefixIcon: Icons.person,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Documento (CPF ou CNPJ)',
                      controller: TextEditingController(
                        text: cliente.documento,
                      ),
                      prefixIcon: Icons.badge,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Telefone',
                      controller: TextEditingController(text: cliente.telefone),
                      prefixIcon: Icons.phone,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'E-mail',
                      controller: TextEditingController(
                        text: cliente.email ?? 'Não informado',
                      ),
                      prefixIcon: Icons.email,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Data de Cadastro',
                      controller: TextEditingController(
                        text: cliente.createdAt?.toString() ?? 'Não informado',
                      ),
                      prefixIcon: Icons.calendar_today,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Status',
                      controller: TextEditingController(
                        text: cliente.ativo ? 'Ativo' : 'Inativo',
                      ),
                      prefixIcon: Icons.check_circle,
                      enabled: false,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
