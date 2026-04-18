import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import 'package:atividade_flutter_n2/app/core/mixins/loader.mixin.dart';
import 'package:atividade_flutter_n2/app/core/mixins/messages.mixin.dart';
import 'package:atividade_flutter_n2/app/core/models/service_order_model.dart';
import 'package:atividade_flutter_n2/app/core/services/cliente_service.dart';
import 'package:atividade_flutter_n2/app/core/services/service_order_service.dart';
import 'package:atividade_flutter_n2/app/shared/widgets/custom_button.dart';
import 'package:atividade_flutter_n2/app/shared/widgets/custom_text_field.dart';

class OrdemServicoPage extends StatefulWidget {
  const OrdemServicoPage({super.key});

  @override
  State<OrdemServicoPage> createState() => _OrdemServicoPageState();
}

class _OrdemServicoPageState extends State<OrdemServicoPage>
    with LoaderMixin, MessagesMixin {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  final _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  ClienteItem? _clienteSelecionado;
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

  // ── Foto helpers ──────────────────────────────────────────────────────────

  Future<void> _pickFoto({required bool isAntes}) async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: foto == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo_outlined,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 8),
                  Text(label,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
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
                        child: const Icon(Icons.edit,
                            size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // ── Save ──────────────────────────────────────────────────────────────────

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

    showLoading(context);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    ServiceOrderService().add(
      ServiceOrder(
        clienteNome: _clienteSelecionado!.nome,
        descricao: _descricaoController.text.trim(),
        valor: double.parse(
            _valorController.text.trim().replaceAll(',', '.')),
        status: 'aberto',
        fotoAntesPath: _fotoAntes?.path,
        fotoDepoisPath: _fotoDepois?.path,
        assinatura: _assinatura,
      ),
    );

    hideLoading(context);
    showSuccess(context, 'Ordem de serviço salva com sucesso');
    Navigator.pop(context);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final clientes = ClienteService().getAll();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Nova Ordem de Serviço'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Seleção de Cliente ────────────────────────────────────────
              _sectionLabel('Cliente', Icons.person_outline),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ClienteItem>(
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
                    onChanged: (val) =>
                        setState(() => _clienteSelecionado = val),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Descrição ─────────────────────────────────────────────────
              _sectionLabel('Descrição do Serviço', Icons.description_outlined),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descricaoController,
                maxLines: 4,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe a descrição' : null,
                decoration: InputDecoration(
                  hintText: 'Descreva o serviço a ser realizado...',
                  filled: true,
                  fillColor:
                      colorScheme.surfaceContainerHighest.withOpacity(0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        BorderSide(color: colorScheme.error, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 24),

              // ── Valor ─────────────────────────────────────────────────────
              _sectionLabel('Valor (R\$)', Icons.attach_money),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _valorController,
                label: 'Valor estipulado',
                prefixIcon: Icons.attach_money,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o valor';
                  final parsed =
                      double.tryParse(v.trim().replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) return 'Valor inválido';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ── Fotos ─────────────────────────────────────────────────────
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

              // ── Assinatura ────────────────────────────────────────────────
              _sectionLabel('Assinatura do Cliente', Icons.draw_outlined),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                  color:
                      colorScheme.surfaceContainerHighest.withOpacity(0.2),
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

              // ── Botão Salvar ──────────────────────────────────────────────
              CustomButton(
                texto: 'Salvar Ordem de Serviço',
                onPressed: _salvar,
                cor: colorScheme.primary,
                altura: 56,
                largura: double.infinity,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
      ],
    );
  }
}
