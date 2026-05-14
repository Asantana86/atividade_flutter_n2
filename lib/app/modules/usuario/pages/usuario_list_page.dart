import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../core/models/usuario_model.dart';
import '../../../shared/widgets/custom_card.dart';

import '../../../core/controllers/usuario_list_controller.dart';
import '../../../core/controllers/usuario_form_controller.dart';
import '../../../core/controllers/usuario_detalhes_controller.dart';

import './usuario_form_page.dart';
import './usuario_detalhes_page.dart';

class UsuarioListPage extends StatefulWidget {
  final UsuarioListController controller;

  const UsuarioListPage({super.key, required this.controller});

  @override
  State<UsuarioListPage> createState() => _UsuarioListPageState();
}

class _UsuarioListPageState
    extends BaseState<UsuarioListPage, UsuarioListController> {
  @override
  UsuarioListController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.carregarUsuarios(onError: onError);
    });
  }

  Future<void> _excluirUsuario(UsuarioModel usuario) async {
    final confirmed = await showConfirmation(
      context,
      'Excluir Usuário',
      'Tem certeza que deseja inativar o usuário ${usuario.nome}?',
    );

    if (confirmed == true) {
      await controller.excluirUsuario(
        usuario.id!,
        onSuccess: onSuccess,
        onError: onError,
      );
    }
  }

  void _navegarParaFormulario([UsuarioModel? model]) async {
    final recarregar = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => UsuarioFormPage(
          controller: UsuarioFormController(controller.service, model: model),
        ),
      ),
    );

    if (recarregar == true) {
      controller.carregarUsuarios(onError: onError);
    }
  }

  void _navegarParaDetalhes(UsuarioModel usuario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UsuarioDetalhesPage(
          controller: UsuarioDetalhesController(
            controller.service,
            usuarioId: usuario.id,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuários'), centerTitle: true),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<List<UsuarioModel>>(
            valueListenable: controller.usuarios,
            builder: (context, usuarios, _) {
              if (usuarios.isEmpty) {
                return const Center(child: Text('Nenhum usuário encontrado.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = usuarios[index];
                  return CustomCard(
                    title: usuario.nome,
                    subtitle: usuario.email,
                    icon: Icons.person,
                    onView: () => _navegarParaDetalhes(usuario),
                    onEdit: () => _navegarParaFormulario(usuario),
                    onDelete: () => _excluirUsuario(usuario),
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
