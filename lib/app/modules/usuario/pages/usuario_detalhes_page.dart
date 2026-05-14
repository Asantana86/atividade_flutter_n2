import 'package:flutter/material.dart';

import '../../../core/base/base_state.dart';
import '../../../core/models/usuario_model.dart';
import '../../../shared/widgets/custom_text_field.dart';

import '../../../core/controllers/usuario_detalhes_controller.dart';

class UsuarioDetalhesPage extends StatefulWidget {
  final UsuarioDetalhesController controller;

  const UsuarioDetalhesPage({super.key, required this.controller});

  @override
  State<UsuarioDetalhesPage> createState() => _UsuarioDetalhesPageState();
}

class _UsuarioDetalhesPageState
    extends BaseState<UsuarioDetalhesPage, UsuarioDetalhesController> {
  @override
  UsuarioDetalhesController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.carregarUsuario(onError: onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Usuário'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: controller.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<UsuarioModel?>(
            valueListenable: controller.usuario,
            builder: (context, usuario, _) {
              if (usuario == null) {
                return const Center(child: Text('Usuário não encontrado.'));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Nome Completo',
                      controller: TextEditingController(text: usuario.nome),
                      prefixIcon: Icons.person,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'E-mail',
                      controller: TextEditingController(text: usuario.email),
                      prefixIcon: Icons.email,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Data de Cadastro',
                      controller: TextEditingController(
                        text: usuario.createdAt?.toString() ?? 'Não informado',
                      ),
                      prefixIcon: Icons.calendar_today,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Status',
                      controller: TextEditingController(
                        text: usuario.ativo ? 'Ativo' : 'Inativo',
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
