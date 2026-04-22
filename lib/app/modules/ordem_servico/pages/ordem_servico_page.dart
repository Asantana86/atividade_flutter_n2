import 'dart:io';
import 'dart:typed_data';
import 'dart:convert'; // Necessário para o base64Encode

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import '../../../core/mixins/loader.mixin.dart';
import '../../../core/mixins/messages.mixin.dart';
import '../../../core/models/service_order_model.dart';
import '../../../core/models/cliente_model.dart';
import '../../../core/services/cliente_service.dart';
import '../../../core/services/service_order_service.dart';
import '../../../../app/shared/widgets/custom_button.dart';
import '../../../../app/shared/widgets/custom_text_field.dart';

class OrdemServicoPage extends StatefulWidget {
  const OrdemServicoPage({super.key});

  @override
  State<OrdemServicoPage> createState() => _OrdemServicoPageState();
}

class _OrdemServicoPageState extends State<OrdemServicoPage> with LoaderMixin, MessagesMixin {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  final _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  ClienteModel? _clienteSelecionado;
  XFile? _fotoAntes;
  XFile? _fotoDepois;
  Uint8List? _assinatura;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _pickFoto({required bool isAntes}) async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked != null) {
      setState(() {
        if (isAntes) {
          _fotoAntes = picked;
        } else {
          _fotoDepois = picked;
        }
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
        height: 130,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withAlpha(102),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: foto == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined, size: 32, color: colorScheme.primary),
                  const SizedBox(height: 8),
                  Text(label,
                      style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600)),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(File(foto.path), fit: BoxFit.cover),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black54,
                        child: const Icon(Icons.edit, size: 14, color: Colors.white),
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

    if (_signatureController.isEmpty) {
      showError(context, 'A assinatura é obrigatória');
      return;
    }

    _assinatura = await _signatureController.toPngBytes();
    
    String? assinaturaBase64;
    if (_assinatura != null) {
      assinaturaBase64 = base64Encode(_assinatura!);
    }

    showLoading(context);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    ServiceOrderService().add(
      ServiceOrderModel(
        clienteNome: _clienteSelecionado!.nome,
        descricao: _descricaoController.text.trim(),
        valor: double.parse(_valorController.text.trim().replaceAll(',', '.')),
        status: 'Em aberto',
        fotoAntesPath: _fotoAntes?.path,
        fotoDepoisPath: _fotoDepois?.path,
        assinaturaBase64: assinaturaBase64,
      ),
    );

    hideLoading(context);
    showSuccess(context, 'Ordem de serviço salva com sucesso');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final clientes = ClienteService().getAll();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Ordem de Serviço'),
        backgroundColor: Colors.transparent, // Tema limpo
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

              _sectionLabel('Valor (R\$)', Icons.attach_money),
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

              _sectionLabel('Evidências Fotográficas', Icons.photo_camera_outlined),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _fotoCard(
                      label: 'Foto Antes',
                      foto: _fotoAntes,
                      onTap: () => _pickFoto(isAntes: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _fotoCard(
                      label: 'Foto Depois',
                      foto: _fotoDepois,
                      onTap: () => _pickFoto(isAntes: false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _sectionLabel('Assinatura do Cliente', Icons.draw_outlined),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(16),
                  color: colorScheme.surfaceContainerHighest.withAlpha(51), // Usando withAlpha
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Signature(
                    controller: _signatureController,
                    height: 160,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _signatureController.clear(),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Limpar assinatura'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              CustomButton(
                texto: 'Salvar Ordem de Serviço',
                onPressed: _salvar,
                altura: 56,
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