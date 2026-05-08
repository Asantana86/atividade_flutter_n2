import 'package:flutter/material.dart';

import '../base/base_controller.dart';
import '../models/ordem_servico_model.dart';
import '../repositories/ordem_servico_repository.dart';
import '../services/cliente_service.dart';
import '../services/ordem_servico_service.dart';
import '../services/servico_service.dart';
import '../services/tecnico_service.dart';
import '../validations/ordem_servico_validation.dart';
import 'ordem_servico_list_view.dart';
import 'ordem_servico_iniciar_form_controller.dart';

class OrdemServicoDashboardController
    extends
        BaseController<
          OrdemServicoModel,
          OrdemServicoRepository,
          OrdemServicoValidation,
          OrdemServicoService
        > {
  final ClienteService clienteService;
  final TecnicoService tecnicoService;
  final ServicoService servicoService;

  OrdemServicoDashboardController(
    super.service, {
    required this.clienteService,
    required this.tecnicoService,
    required this.servicoService,
  });

  @override
  Widget buildPage(BuildContext context, OrdemServicoService service) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minhas Ordens'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Todas'),
              Tab(text: 'Em Aberto'),
              Tab(text: 'Finalizadas'),
              Tab(text: 'Canceladas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrdemServicoListView(controller: this, status: null),
            OrdemServicoListView(
              controller: this,
              status: StatusOS.emAndamento,
            ),
            OrdemServicoListView(controller: this, status: StatusOS.finalizado),
            OrdemServicoListView(controller: this, status: StatusOS.cancelado),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrdemServicoIniciarFormController(
                service,
                clienteService: clienteService,
                tecnicoService: tecnicoService,
                servicoService: servicoService,
              ),
            ),
          ),
          label: const Text('Nova Ordem'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
