import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../core/models/servico_model.dart';
import '../../../shared/widgets/custom_text_field.dart';

import '../../../core/controllers/servico_detalhes_controller.dart';

class ServicoDetalhesPage extends StatefulWidget {
  final ServicoDetalhesController controller;

  const ServicoDetalhesPage({super.key, required this.controller});

  @override
  State<ServicoDetalhesPage> createState() => _ServicoDetalhesPageState();
}

class _ServicoDetalhesPageState
    extends BaseState<ServicoDetalhesPage, ServicoDetalhesController> {
  @override
  ServicoDetalhesController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.carregarServico(onError: onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Serviço'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<ServicoModel?>(
            valueListenable: controller.servico,
            builder: (context, servico, _) {
              if (servico == null) {
                return const Center(child: Text('Serviço não encontrado.'));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Descrição',
                      controller: TextEditingController(
                        text: servico.descricao,
                      ),
                      prefixIcon: Icons.description,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Preço',
                      controller: TextEditingController(
                        text: 'R\$ ${servico.preco.toStringAsFixed(2)}',
                      ),
                      prefixIcon: Icons.attach_money,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Tempo Estimado',
                      controller: TextEditingController(
                        text: servico.tempoEstimado ?? 'Não informado',
                      ),
                      prefixIcon: Icons.access_time,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Data de Cadastro',
                      controller: TextEditingController(
                        text: servico.createdAt?.toString() ?? 'Não informado',
                      ),
                      prefixIcon: Icons.calendar_today,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Status',
                      controller: TextEditingController(
                        text: servico.ativo ? 'Ativo' : 'Inativo',
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
