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
    super.isSync,
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
      isSync: map['isSync'] == 1,
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
      'isSync': isSync ? 1 : 0,
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