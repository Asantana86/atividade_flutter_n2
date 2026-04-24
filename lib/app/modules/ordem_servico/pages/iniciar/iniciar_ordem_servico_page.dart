import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/mixins/loader.mixin.dart';
import '../../../../core/mixins/messages.mixin.dart';
import '../../../../core/models/service_order_model.dart';
import '../../../../core/models/cliente_model.dart';
import '../../../../core/services/cliente_service.dart';
import '../../../../core/services/service_order_service.dart';
import '../../../../../app/shared/widgets/custom_button.dart';
import '../../../../../app/shared/widgets/custom_text_field.dart';

class IniciarOrdemServicoPage extends StatefulWidget {
  const IniciarOrdemServicoPage({super.key});

  @override
  State<IniciarOrdemServicoPage> createState() => _IniciarOrdemServicoPageState();
}

class _IniciarOrdemServicoPageState extends State<IniciarOrdemServicoPage> with LoaderMixin, MessagesMixin {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  ClienteModel? _clienteSelecionado;
  XFile? _fotoAntes;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _tirarFotoAntes() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _fotoAntes = image;
      });
    }
  }

  Widget _fotoCard({
    required String label,
    required XFile? foto,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withAlpha(102),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: foto == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, size: 48, color: colorScheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Toque para capturar',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(File(foto.path), fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: onTap,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_clienteSelecionado == null) {
      showError(context, 'Selecione um cliente');
      return;
    }

    showLoading(context);
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    ServiceOrderService().add(
      ServiceOrderModel(
        clienteNome: _clienteSelecionado!.nome,
        descricao: _descricaoController.text.trim(),
        valor: double.parse(_valorController.text.trim().replaceAll(',', '.')),
        status: 'Em aberto',
        fotoAntesPath: _fotoAntes?.path,
      ),
    );

    hideLoading(context);
    showSuccess(context, 'Ordem de serviço iniciada com sucesso!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final clientes = ClienteService().getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Ordem de Serviço'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel('Cliente', Icons.person_outline),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withAlpha(102),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ClienteModel>(
                    value: _clienteSelecionado,
                    isExpanded: true,
                    hint: const Text('Selecione o cliente'),
                    borderRadius: BorderRadius.circular(12),
                    items: clientes
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.nome),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => _clienteSelecionado = val),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _sectionLabel('Descrição do Serviço', Icons.description_outlined),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _descricaoController,
                label: 'Descreva o serviço a ser realizado...',
                maxLines: 4,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe a descrição' : null,
              ),

              const SizedBox(height: 24),

              _sectionLabel('Valor (R)', Icons.attach_money),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _valorController,
                label: 'Valor estipulado',
                prefixIcon: Icons.attach_money,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o valor';
                  final parsed = double.tryParse(v.trim().replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) return 'Valor inválido';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              _sectionLabel('Foto Antes', Icons.photo_camera_outlined),
              const SizedBox(height: 8),
              _fotoCard(
                label: 'Tirar Foto Antes',
                foto: _fotoAntes,
                onTap: _tirarFotoAntes,
              ),

              const SizedBox(height: 32),

              CustomButton(
                texto: 'Iniciar Ordem de Serviço',
                onPressed: _salvar,
                altura: 56,
                icon: Icons.play_arrow,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
        ),
      ],
    );
  }
}