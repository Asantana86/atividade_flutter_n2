import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../core/models/tecnico_model.dart';
import '../../../shared/widgets/custom_text_field.dart';

import '../../../core/controllers/tecnico_detalhes_controller.dart';

class TecnicoDetalhesPage extends StatefulWidget {
  final TecnicoDetalhesController controller;

  const TecnicoDetalhesPage({super.key, required this.controller});

  @override
  State<TecnicoDetalhesPage> createState() => _TecnicoDetalhesPageState();
}

class _TecnicoDetalhesPageState
    extends BaseState<TecnicoDetalhesPage, TecnicoDetalhesController> {
  @override
  TecnicoDetalhesController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.carregarTecnico(onError: onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Técnico'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<TecnicoModel?>(
            valueListenable: controller.tecnico,
            builder: (context, tecnico, _) {
              if (tecnico == null) {
                return const Center(child: Text('Técnico não encontrado.'));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Nome Completo',
                      controller: TextEditingController(text: tecnico.nome),
                      prefixIcon: Icons.person,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Especialidade',
                      controller: TextEditingController(
                        text: tecnico.especialidade ?? 'Não informado',
                      ),
                      prefixIcon: Icons.build,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Data de Cadastro',
                      controller: TextEditingController(
                        text: tecnico.createdAt?.toString() ?? 'Não informado',
                      ),
                      prefixIcon: Icons.calendar_today,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Status',
                      controller: TextEditingController(
                        text: tecnico.ativo ? 'Ativo' : 'Inativo',
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
