import 'package:flutter/material.dart';
import '../../../core/models/service_order_model.dart';
import '../../../shared/app_routes.dart';

class OSListPage extends StatelessWidget {
  const OSListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String title = args['title'];
    final List<ServiceOrderModel> lista = args['lista'];

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: lista.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma ordem de serviço encontrada.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: lista.length,
              itemBuilder: (_, i) {
                final os = lista[i];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      child: const Icon(Icons.assignment),
                    ),
                    title: Text(
                      os.descricao,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("Cliente: ${os.clienteNome}"),
                        Text("Status: ${os.status}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "R\$ ${os.valor.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.visibility,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.detalhesOs,
                              arguments: os,
                            );
                          },
                          tooltip: 'Ver detalhes',
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
