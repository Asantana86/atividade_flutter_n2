import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CustomCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withAlpha(100)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do Card (Ícone, Título, Subtítulo e Trailing)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withAlpha(150),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ]
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(height: 1),
            
            // Rodapé com os Botões de Ação
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Visualizar
                IconButton(
                  icon: const Icon(Icons.visibility_outlined),
                  color: onView != null ? Colors.blue : Colors.grey,
                  tooltip: 'Visualizar Detalhes',
                  onPressed: onView,
                ),
                
                // Editar
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  color: onEdit != null ? Colors.orange : Colors.grey,
                  tooltip: onEdit != null ? 'Editar' : 'Edição bloqueada',
                  onPressed: onEdit,
                ),
                
                // Excluir (Soft Delete)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: onDelete != null ? Colors.red : Colors.grey,
                  tooltip: 'Remover',
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}