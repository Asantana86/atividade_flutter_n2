import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import '../../../core/models/ordem_servico_model.dart';
import '../../../core/models/cliente_model.dart';
import '../../../core/models/tecnico_model.dart';
import '../../../core/models/servico_model.dart';
import '../../../shared/widgets/custom_text_field.dart';

import '../../../core/controllers/ordem_servico_detalhes_controller.dart';

class OrdemServicoDetalhesPage extends StatefulWidget {
  final OrdemServicoDetalhesController controller;

  const OrdemServicoDetalhesPage({super.key, required this.controller});

  @override
  State<OrdemServicoDetalhesPage> createState() =>
      _OrdemServicoDetalhesPageState();
}

class _OrdemServicoDetalhesPageState extends State<OrdemServicoDetalhesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.carregarOrdemServico(onError: _onError);
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  void _onError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Ordem de Serviço'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: widget.controller.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ValueListenableBuilder<OrdemServicoModel?>(
            valueListenable: widget.controller.ordemServico,
            builder: (context, ordemServico, _) {
              if (ordemServico == null) {
                return const Center(
                  child: Text('Ordem de serviço não encontrada.'),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informações Gerais
                    _buildSectionTitle('Informações Gerais'),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Número da OS',
                      controller: TextEditingController(
                        text: '#${ordemServico.id}',
                      ),
                      prefixIcon: Icons.assignment,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Status',
                      controller: TextEditingController(
                        text: ordemServico.status.label,
                      ),
                      prefixIcon: Icons.info,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Data de Início',
                      controller: TextEditingController(
                        text: _formatDate(ordemServico.dataInicio),
                      ),
                      prefixIcon: Icons.calendar_today,
                      enabled: false,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Data de Fim',
                      controller: TextEditingController(
                        text: ordemServico.dataFim != null
                            ? _formatDate(ordemServico.dataFim!)
                            : 'Não finalizada',
                      ),
                      prefixIcon: Icons.calendar_today,
                      enabled: false,
                    ),

                    const SizedBox(height: 24),

                    // Cliente
                    _buildSectionTitle('Cliente'),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<ClienteModel?>(
                      valueListenable: widget.controller.cliente,
                      builder: (context, cliente, _) {
                        return CustomTextField(
                          label: 'Nome do Cliente',
                          controller: TextEditingController(
                            text:
                                cliente?.nome ??
                                'Cliente #${ordemServico.clienteId}',
                          ),
                          prefixIcon: Icons.person,
                          enabled: false,
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Técnico
                    _buildSectionTitle('Técnico Responsável'),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<TecnicoModel?>(
                      valueListenable: widget.controller.tecnico,
                      builder: (context, tecnico, _) {
                        return Column(
                          children: [
                            CustomTextField(
                              label: 'Nome do Técnico',
                              controller: TextEditingController(
                                text:
                                    tecnico?.nome ??
                                    'Técnico #${ordemServico.tecnicoId}',
                              ),
                              prefixIcon: Icons.engineering,
                              enabled: false,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Especialidade',
                              controller: TextEditingController(
                                text: tecnico?.especialidade ?? 'Não informado',
                              ),
                              prefixIcon: Icons.build,
                              enabled: false,
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Serviço
                    _buildSectionTitle('Serviço'),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<ServicoModel?>(
                      valueListenable: widget.controller.servico,
                      builder: (context, servico, _) {
                        return Column(
                          children: [
                            CustomTextField(
                              label: 'Descrição do Serviço',
                              controller: TextEditingController(
                                text:
                                    servico?.descricao ??
                                    'Serviço #${ordemServico.servicoId}',
                              ),
                              prefixIcon: Icons.miscellaneous_services,
                              enabled: false,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Preço',
                              controller: TextEditingController(
                                text: servico != null
                                    ? 'R\$ ${servico.preco.toStringAsFixed(2)}'
                                    : 'Não informado',
                              ),
                              prefixIcon: Icons.attach_money,
                              enabled: false,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Tempo Estimado',
                              controller: TextEditingController(
                                text: servico?.tempoEstimado ?? 'Não informado',
                              ),
                              prefixIcon: Icons.access_time,
                              enabled: false,
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Observações
                    if (ordemServico.observacaoFinal != null &&
                        ordemServico.observacaoFinal!.isNotEmpty) ...[
                      _buildSectionTitle('Observações Finais'),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'Observação',
                        controller: TextEditingController(
                          text: ordemServico.observacaoFinal,
                        ),
                        prefixIcon: Icons.note,
                        enabled: false,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Fotos
                    _buildSectionTitle('Fotos'),
                    const SizedBox(height: 16),
                    _buildImageSection('Foto Antes', ordemServico.fotoAntes),
                    const SizedBox(height: 16),
                    if (ordemServico.fotoDepois != null &&
                        ordemServico.fotoDepois!.isNotEmpty)
                      _buildImageSection(
                        'Foto Depois',
                        ordemServico.fotoDepois!,
                      ),

                    const SizedBox(height: 24),

                    // Assinatura
                    if (ordemServico.assinatura != null &&
                        ordemServico.assinatura!.isNotEmpty) ...[
                      _buildSectionTitle('Assinatura'),
                      const SizedBox(height: 16),
                      _buildSignatureSection(ordemServico.assinatura!),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildImageSection(String label, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImage(imagePath),
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureSection(String signatureBase64) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assinatura do Cliente',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildSignatureImage(signatureBase64),
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureImage(String signatureBase64) {
    try {
      final decodedBytes = base64Decode(signatureBase64);
      return Image.memory(
        decodedBytes,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
          );
        },
      );
    } catch (e) {
      return const Center(
        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
      );
    }
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
          );
        },
      );
    } else {
      // Assume é um caminho de arquivo local
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              );
            },
          );
        },
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
