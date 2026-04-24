import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final Color? cor;
  final double altura;
  final double largura;
  final IconData? icon;
  final bool iconLeading; // true = ícone antes do texto, false = depois

  const CustomButton({
    super.key,
    required this.texto,
    required this.onPressed,
    this.cor,
    this.altura = 50,
    this.largura = double.infinity,
    this.icon,
    this.iconLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = cor ?? theme.colorScheme.primary;

    Widget buttonChild;

    if (icon != null) {
      final iconWidget = Icon(icon, size: 20);
      if (iconLeading) {
        buttonChild = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 8),
            Text(
              texto,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else {
        buttonChild = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              texto,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            iconWidget,
          ],
        );
      }
    } else {
      buttonChild = Text(
        texto,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );
    }

    return SizedBox(
      height: altura,
      width: largura,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: buttonChild,
      ),
    );
  }
}
