import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../core/models/servico_model.dart';
import '../../../shared/widgets/custom_card.dart';

import '../../../core/controllers/servico_list_controller.dart';
import '../../../core/controllers/servico_form_controller.dart';

import './servico_form_page.dart';

class ServicoListPage extends StatefulWidget {
  final ServicoListController controller;

  const ServicoListPage({super.key, required this.controller});

  @override
  State<ServicoListPage> createState() => _ServicoListPageState();
}

class _ServicoListPageState extends BaseState<ServicoListPage, ServicoListController> {
  
  @override
  ServicoListController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.carregarServicos(onError: onError);
    });
  }

  Future<void> _excluirServico(ServicoModel servico) async {
    final confirmed = await showConfirmation(
      context,
      'Excluir Serviço',
      'Deseja remover o serviço: ${servico.descricao}?',
    );

    if (confirmed == true) {
      await controller.excluirServico(
        servico.id!,
        onSuccess: onSuccess,
        onError: onError,
      );
    }
  }

  void _navegarParaFormulario([ServicoModel? model]) async {
    final recarregar = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ServicoFormPage(
          controller: ServicoFormController(controller.service, model: model),
        ),
      ),
    );

    if (recarregar == true) {
      controller.carregarServicos(onError: onError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Serviços'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<List<ServicoModel>>(
            valueListenable: controller.servicos,
            builder: (context, servicos, _) {
              if (servicos.isEmpty) {
                return const Center(child: Text('Nenhum serviço cadastrado.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
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
                        fontSize: 16,
                      ),
                    ),
                    onEdit: () => _navegarParaFormulario(servico),
                    onDelete: () => _excluirServico(servico),
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