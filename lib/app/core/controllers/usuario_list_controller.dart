import 'package:flutter/material.dart';

import '../base/base_controller.dart';
import '../models/usuario_model.dart';
import '../repositories/usuario_repository.dart';
import '../validations/usuario_validation.dart';
import '../services/usuario_service.dart';
import 'usuario_form_controller.dart';

import '../../shared/widgets/custom_card.dart';

class UsuarioListController
    extends
        BaseController<
          UsuarioModel,
          UsuarioRepository,
          UsuarioValidation,
          UsuarioService
        > {
  UsuarioListController(super.service);

  @override
  Widget buildPage(BuildContext context, UsuarioService service) {
    // Retorna a view stateful para gerenciar o estado da lista
    return _UsuarioListPage(controller: this, service: service);
  }
}

class _UsuarioListPage extends StatefulWidget {
  final UsuarioListController controller;
  final UsuarioService service;

  const _UsuarioListPage({required this.controller, required this.service});

  @override
  State<_UsuarioListPage> createState() => _UsuarioListPageState();
}

class _UsuarioListPageState extends State<_UsuarioListPage> {
  List<UsuarioModel> usuarios = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async {
    // Usa o wrapper do BaseController para gerenciar loading e erros automaticamente
    final result = await widget.controller.executeListOperation(
      context,
      widget.service.findAllActive(),
    );

    if (mounted) {
      setState(() => usuarios = result);
    }
  }

  Future<void> _excluirUsuario(UsuarioModel usuario) async {
    // Usa o wrapper de CRUD que já possui Dialog de confirmação embutido
    final success = await widget.controller.executeCrudOperation(
      context,
      widget.service.softDelete(usuario.id!),
      requiresConfirmation: true,
      confirmTitle: 'Excluir Usuário',
      confirmMessage:
          'Tem certeza que deseja excluir o usuário ${usuario.nome}?',
      successMessage: 'Usuário excluído com sucesso!',
    );

    if (success) {
      _carregarUsuarios();
    }
  }

  void _navegarParaFormulario([UsuarioModel? model]) async {
    // Navega para a tela de form e aguarda o retorno.
    // Se retornar true (salvou), recarrega a lista.
    final recarregar = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => UsuarioFormController(widget.service, model: model),
      ),
    );

    if (recarregar == true) {
      _carregarUsuarios();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários'), centerTitle: true),
      body: usuarios.isEmpty
          ? const Center(child: Text('Nenhum usuário encontrado.'))
          : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return CustomCard(
                  title: usuario.nome,
                  subtitle: usuario.email,
                  icon: Icons.person,
                  onEdit: () => _navegarParaFormulario(usuario),
                  onDelete: () => _excluirUsuario(usuario),
                  // onView: () => ... (Pode adicionar se tiver uma tela de detalhes no futuro)
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
