import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../core/models/tecnico_model.dart';
import '../../../shared/widgets/custom_card.dart';

import '../../../core/controllers/tecnico_list_controller.dart';
import '../../../core/controllers/tecnico_form_controller.dart';

import './tecnico_form_page.dart';

class TecnicoListPage extends StatefulWidget {
  final TecnicoListController controller;

  const TecnicoListPage({super.key, required this.controller});

  @override
  State<TecnicoListPage> createState() => _TecnicoListPageState();
}

class _TecnicoListPageState extends BaseState<TecnicoListPage, TecnicoListController> {
  
  @override
  TecnicoListController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.carregarTecnicos(onError: onError);
    });
  }

  Future<void> _excluirTecnico(TecnicoModel tecnico) async {
    final confirmed = await showConfirmation(
      context,
      'Excluir Técnico',
      'Tem certeza que deseja excluir o técnico ${tecnico.nome}?',
    );

    if (confirmed == true) {
      await controller.excluirTecnico(
        tecnico.id!,
        onSuccess: onSuccess,
        onError: onError,
      );
    }
  }

  void _navegarParaFormulario([TecnicoModel? model]) async {
    final recarregar = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TecnicoFormPage(
          controller: TecnicoFormController(controller.service, model: model),
        ),
      ),
    );

    if (recarregar == true) {
      controller.carregarTecnicos(onError: onError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Técnicos'), centerTitle: true),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<List<TecnicoModel>>(
            valueListenable: controller.tecnicos,
            builder: (context, tecnicos, _) {
              if (tecnicos.isEmpty) {
                return const Center(child: Text('Nenhum técnico encontrado.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
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