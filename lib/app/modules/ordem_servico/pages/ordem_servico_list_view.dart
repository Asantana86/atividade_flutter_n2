import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../core/models/ordem_servico_model.dart';
import '../../../shared/widgets/custom_card.dart';

import '../../../core/controllers/ordem_servico_list_controller.dart';
import '../../../core/controllers/ordem_servico_finalizar_form_controller.dart';

import './ordem_servico_finalizar_form_page.dart';

class OrdemServicoListView extends StatefulWidget {
  final OrdemServicoListController controller;
  final StatusOS? status;

  const OrdemServicoListView({
    super.key,
    required this.controller,
    this.status,
  });

  @override
  State<OrdemServicoListView> createState() => _OrdemServicoListViewState();
}

class _OrdemServicoListViewState extends BaseState<OrdemServicoListView, OrdemServicoListController> {
  
  @override
  OrdemServicoListController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.carregarOrdens(onError: onError);
    });
  }

  Future<void> _cancelarOS(OrdemServicoModel os) async {
    final confirmed = await showConfirmation(
      context,
      'Cancelar Ordem',
      'Deseja realmente cancelar a OS #${os.id}?\nIsso marcará a ordem como Cancelada.',
    );

    if (confirmed == true) {
      await controller.cancelarOS(
        os.id!,
        onSuccess: onSuccess,
        onError: onError,
      );
    }
  }

  void _irParaFinalizacao(OrdemServicoModel os) async {
    final recarregar = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => OrdemServicoFinalizarFormPage(
          controller: OrdemServicoFinalizarFormController(
            controller.service, 
            clienteService: controller.clienteService,
            model: os,
          ),
        ),
      ),
    );

    if (recarregar == true) {
      controller.carregarOrdens(onError: onError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ValueListenableBuilder<List<OrdemServicoModel>>(
          valueListenable: controller.ordens,
          builder: (context, todasOrdens, _) {
            
            final ordensFiltradas = widget.status == null
                ? todasOrdens
                : todasOrdens.where((os) => os.status == widget.status).toList();

            if (ordensFiltradas.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_late_outlined, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma ordem ${widget.status?.label ?? ""} encontrada.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: ordensFiltradas.length,
              itemBuilder: (context, index) {
                final os = ordensFiltradas[index];
                
                Color statusColor;
                switch (os.status) {
                  case StatusOS.emAndamento: statusColor = Colors.blue; break;
                  case StatusOS.finalizado: statusColor = Colors.green; break;
                  case StatusOS.cancelado: statusColor = Colors.red; break;
                }

                return CustomCard(
                  title: 'Ordem #${os.id}',
                  subtitle: 'Início: ${os.dataInicio.day}/${os.dataInicio.month}/${os.dataInicio.year}\nCliente ID: ${os.clienteId}',
                  icon: Icons.assignment,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      os.status.label,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  onView: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Detalhes da OS #${os.id}'),
                        content: Text('Status: ${os.status.label}\nData: ${os.dataInicio}'),
                      ),
                    );
                  },
                  onEdit: os.status == StatusOS.emAndamento 
                      ? () => _irParaFinalizacao(os) 
                      : null,
                  onDelete: os.status == StatusOS.emAndamento 
                      ? () => _cancelarOS(os) 
                      : null,
                );
              },
            );
          },
        );
      },
    );
  }
}