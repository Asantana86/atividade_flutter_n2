import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/models/service_order_model.dart';

class DetalhesOrdemServicoPage extends StatelessWidget {
  final ServiceOrderModel ordem;

  const DetalhesOrdemServicoPage({super.key, required this.ordem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('OS #${ordem.id}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(ordem.status).withAlpha(51),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getStatusColor(ordem.status)),
              ),
              child: Text(
                ordem.status,
                style: TextStyle(
                  color: _getStatusColor(ordem.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Cliente
            _sectionTitle(context, 'Cliente', Icons.person_outline),
            const SizedBox(height: 8),
            _infoCard(ordem.clienteNome, colorScheme),
            const SizedBox(height: 20),

            // Descrição
            _sectionTitle(
              context,
              'Descrição do Serviço',
              Icons.description_outlined,
            ),
            const SizedBox(height: 8),
            _infoCard(ordem.descricao, colorScheme),
            const SizedBox(height: 20),

            // Valor
            _sectionTitle(context, 'Valor', Icons.attach_money),
            const SizedBox(height: 8),
            _infoCard(
              'R\$ ${ordem.valor.toStringAsFixed(2)}',
              colorScheme,
              isHighlight: true,
            ),
            const SizedBox(height: 20),

            // Data de Criação
            if (ordem.createdAt != null) ...[
              _sectionTitle(context, 'Data de Criação', Icons.calendar_today),
              const SizedBox(height: 8),
              _infoCard(_formatDate(ordem.createdAt!), colorScheme),
              const SizedBox(height: 20),
            ],

            // Foto Antes
            if (ordem.fotoAntesPath != null &&
                ordem.fotoAntesPath!.isNotEmpty) ...[
              _sectionTitle(context, 'Foto Antes', Icons.photo_camera_outlined),
              const SizedBox(height: 8),
              _fotoCard(ordem.fotoAntesPath!, colorScheme),
              const SizedBox(height: 20),
            ],

            // Foto Depois
            if (ordem.fotoDepoisPath != null &&
                ordem.fotoDepoisPath!.isNotEmpty) ...[
              _sectionTitle(
                context,
                'Foto Depois',
                Icons.photo_library_outlined,
              ),
              const SizedBox(height: 8),
              _fotoCard(ordem.fotoDepoisPath!, colorScheme),
              const SizedBox(height: 20),
            ],

            // Assinatura
            if (ordem.assinaturaBase64 != null &&
                ordem.assinaturaBase64!.isNotEmpty) ...[
              _sectionTitle(
                context,
                'Assinatura do Cliente',
                Icons.draw_outlined,
              ),
              const SizedBox(height: 8),
              _assinaturaCard(ordem.assinaturaBase64!, colorScheme),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _infoCard(
    String text,
    ColorScheme colorScheme, {
    bool isHighlight = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight
            ? colorScheme.primaryContainer.withAlpha(77)
            : colorScheme.surfaceContainerHighest.withAlpha(102),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: isHighlight ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _fotoCard(String path, ColorScheme colorScheme) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Imagem não encontrada',
                    style: TextStyle(color: colorScheme.error),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _assinaturaCard(String base64, ColorScheme colorScheme) {
    try {
      final bytes = base64Decode(base64);
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(
            bytes,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.draw_outlined,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Assinatura disponível',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withAlpha(102),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Center(
          child: Text(
            'Assinatura não disponível',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Em aberto':
        return Colors.orange;
      case 'Em execução':
        return Colors.blue;
      case 'Executada':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
