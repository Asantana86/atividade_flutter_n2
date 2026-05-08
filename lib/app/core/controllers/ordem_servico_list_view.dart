import 'package:flutter/material.dart';

import '../models/ordem_servico_model.dart';
import 'ordem_servico_dashboard_controller.dart';
import 'ordem_servico_finalizar_form_controller.dart';

import '../../shared/widgets/custom_card.dart';

class OrdemServicoListView extends StatefulWidget {
  final OrdemServicoDashboardController controller;
  final StatusOS? status;

  const OrdemServicoListView({
    super.key,
    required this.controller,
    this.status,
  });

  @override
  State<OrdemServicoListView> createState() => _OrdemServicoListViewState();
}

class _OrdemServicoListViewState extends State<OrdemServicoListView> {
  List<OrdemServicoModel> ordens = [];

  @override
  void initState() {
    super.initState();
    _carregarOrdens();
  }

  Future<void> _carregarOrdens() async {
    final todas = await widget.controller.executeListOperation(
      context,
      widget.controller.service.findAllActive(),
    );

    if (mounted) {
      setState(() {
        if (widget.status == null) {
          ordens = todas;
        } else {
          ordens = todas.where((os) => os.status == widget.status).toList();
        }
      });
    }
  }

  Future<void> _cancelarOS(OrdemServicoModel os) async {
    final sucesso = await widget.controller.executeCrudOperation(
      context,
      widget.controller.service.softDelete(os.id!),
      requiresConfirmation: true,
      confirmTitle: 'Cancelar Ordem',
      confirmMessage: 'Deseja realmente cancelar a OS #${os.id}?\nIsso marcará o status como Cancelado.',
      successMessage: 'Ordem de serviço cancelada.',
    );

    if (sucesso) _carregarOrdens();
  }

  void _irParaFinalizacao(OrdemServicoModel os) async {
    final recarregar = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => OrdemServicoFinalizarFormController(
          widget.controller.service, 
          clienteService: widget.controller.clienteService,
          model: os,
        ),
      ),
    );

    if (recarregar == true) _carregarOrdens();
  }

  @override
  Widget build(BuildContext context) {
    if (ordens.isEmpty) {
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
      itemCount: ordens.length,
      itemBuilder: (context, index) {
        final os = ordens[index];
        
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
  }
}