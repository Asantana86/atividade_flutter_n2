import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import '../../../../core/mixins/loader.mixin.dart';
import '../../../../core/mixins/messages.mixin.dart';
import '../../../../core/models/service_order_model.dart';
import '../../../../core/services/service_order_service.dart';
import '../../../../../app/shared/widgets/custom_button.dart';

class FinalizarOrdemServicoPage extends StatefulWidget {
  const FinalizarOrdemServicoPage({super.key});

  @override
  State<FinalizarOrdemServicoPage> createState() =>
      _FinalizarOrdemServicoPageState();
}

class _FinalizarOrdemServicoPageState extends State<FinalizarOrdemServicoPage>
    with LoaderMixin, MessagesMixin {
  final _formKey = GlobalKey<FormState>();

  ServiceOrderModel? _ordemSelecionada;
  XFile? _fotoDepois;
  Uint8List? _assinaturaBytes;
  String? _assinaturaBase64;

  final ImagePicker _picker = ImagePicker();
  late SignatureController _signatureController;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _tirarFotoDepois() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _fotoDepois = image;
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
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 48,
                    color: colorScheme.primary,
                  ),
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
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
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

  Future<void> _finalizar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_ordemSelecionada == null) {
      showError(context, 'Selecione uma ordem de serviço');
      return;
    }

    if (_signatureController.isEmpty) {
      showError(context, 'A assinatura é obrigatória');
      return;
    }

    // Converter assinatura para base64
    _assinaturaBytes = await _signatureController.toPngBytes();
    if (_assinaturaBytes != null) {
      _assinaturaBase64 = base64Encode(_assinaturaBytes!);
    }

    showLoading(context);
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Atualizar a ordem de serviço
    final ordemAtualizada = ServiceOrderModel(
      id: _ordemSelecionada!.id,
      clienteNome: _ordemSelecionada!.clienteNome,
      descricao: _ordemSelecionada!.descricao,
      valor: _ordemSelecionada!.valor,
      status: 'Executada',
      fotoAntesPath: _ordemSelecionada!.fotoAntesPath,
      fotoDepoisPath: _fotoDepois?.path,
      assinaturaBase64: _assinaturaBase64,
    );

    ServiceOrderService().update(ordemAtualizada);

    hideLoading(context);
    showSuccess(context, 'Ordem de serviço finalizada com sucesso!');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Filtrar ordens que podem ser finalizadas (Em aberto ou Em execução)
    final ordensPendentes = ServiceOrderService()
        .getAll()
        .where((os) => os.status == 'Em aberto' || os.status == 'Em execução')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Ordem de Serviço'),
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
              _sectionLabel(
                'Selecionar Ordem de Serviço',
                Icons.assignment_outlined,
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withAlpha(102),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ServiceOrderModel>(
                    value: _ordemSelecionada,
                    isExpanded: true,
                    hint: const Text('Selecione a OS'),
                    borderRadius: BorderRadius.circular(12),
                    items: ordensPendentes
                        .map(
                          (os) => DropdownMenuItem(
                            value: os,
                            child: Text('${os.id} - ${os.clienteNome}'),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _ordemSelecionada = val),
                  ),
                ),
              ),

              // Mostrar informações da OS selecionada
              if (_ordemSelecionada != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withAlpha(77),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cliente: ${_ordemSelecionada!.clienteNome}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Descrição: ${_ordemSelecionada!.descricao}',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Valor: R\$ ${_ordemSelecionada!.valor.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              _sectionLabel(
                'Foto Depois do Serviço',
                Icons.photo_camera_outlined,
              ),
              const SizedBox(height: 8),
              _fotoCard(
                label: 'Foto Depois',
                foto: _fotoDepois,
                onTap: _tirarFotoDepois,
              ),

              const SizedBox(height: 24),

              _sectionLabel('Assinatura do Cliente', Icons.draw_outlined),
              const SizedBox(height: 8),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(16),
                  color: colorScheme.surfaceContainerHighest.withAlpha(51),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Signature(
                    controller: _signatureController,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    _signatureController.clear();
                  },
                  icon: const Icon(Icons.clear, size: 18),
                  label: const Text('Limpar Assinatura'),
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: _finalizar,
                  texto: 'Finalizar Ordem de Serviço',
                  icon: Icons.check_circle_outline,
                ),
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
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
