import 'dart:typed_data';

class ServiceOrder {
  final String clienteNome;
  final String descricao;
  final double valor;
  final String status;
  final String? fotoAntesPath;
  final String? fotoDepoisPath;
  final Uint8List? assinatura;

  ServiceOrder({
    required this.clienteNome,
    required this.descricao,
    required this.valor,
    required this.status,
    this.fotoAntesPath,
    this.fotoDepoisPath,
    this.assinatura,
  });

  ServiceOrder.fromMap(Map<String, dynamic> map)
      : clienteNome = map['clienteNome'] as String,
        descricao = map['descricao'] as String,
        valor = map['valor'] as double,
        status = map['status'] as String,
        fotoAntesPath = map['fotoAntesPath'] as String?,
        fotoDepoisPath = map['fotoDepoisPath'] as String?,
        assinatura = null;

  Map<String, dynamic> toMap() {
    return {
      'clienteNome': clienteNome,
      'descricao': descricao,
      'valor': valor,
      'status': status,
      'fotoAntesPath': fotoAntesPath,
      'fotoDepoisPath': fotoDepoisPath,
    };
  }
}