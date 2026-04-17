import 'package:flutter/material.dart';
import 'package:atividade_flutter_n2/app/core/models/service_order_model.dart';

class OSListPage extends StatelessWidget {
  final String title;
  final List<ServiceOrder> lista;

  const OSListPage({
    super.key,
    required this.title,
    required this.lista,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (_, i) {
          final os = lista[i];
          return ListTile(
            title: Text(os.descricao),
            subtitle: Text("Status: ${os.status}"),
            trailing: Text("R\$ ${os.valor.toStringAsFixed(2)}"),
          );
        },
      ),
    );
  }
}
