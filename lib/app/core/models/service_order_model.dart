class ServiceOrder {
  //final int id;
  final String descricao;
  final double valor;
  final String status; 

  ServiceOrder({
    //required this.id,
    required this.descricao,
    required this.valor,
    required this.status,
  });

  ServiceOrder.fromMap(Map<String, dynamic> map)
    : //id = map['id'] as int,
      descricao = map['descricao'] as String,
      valor = map['valor'] as double,
      status = map['status'] as String;

 @override
  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'descricao': descricao,
      'valor': valor,
      'status': status,
    };
  }     
}