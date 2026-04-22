import 'base_model.dart';

class ServiceOrderModel extends BaseModel {
  final String clienteNome;
  final String descricao;
  final double valor;
  final String status;
  final String? fotoAntesPath;
  final String? fotoDepoisPath;
  final String? assinaturaBase64;

  ServiceOrderModel({
    super.id,
    super.createdAt,
    required this.clienteNome,
    required this.descricao,
    required this.valor,
    this.status = 'P',
    this.fotoAntesPath,
    this.fotoDepoisPath,
    this.assinaturaBase64,
  });

  factory ServiceOrderModel.fromMap(Map<String, dynamic> map) {
    return ServiceOrderModel(
      id: map['id'] as int?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      clienteNome: map['clienteNome'] as String,
      descricao: map['descricao'] as String,
      valor: (map['valor'] as num).toDouble(), 
      status: map['status'] as String? ?? 'P',
      fotoAntesPath: map['fotoAntesPath'] as String?,
      fotoDepoisPath: map['fotoDepoisPath'] as String?,
      assinaturaBase64: map['assinatura'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'clienteNome': clienteNome,
      'descricao': descricao,
      'valor': valor,
      'status': status,
      'fotoAntesPath': fotoAntesPath,
      'fotoDepoisPath': fotoDepoisPath,
      'assinatura': assinaturaBase64,
    };
  }
}