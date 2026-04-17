import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final Color cor;
  final double altura;
  final double largura;

  const CustomButton({
    super.key,
    required this.texto,
    required this.onPressed,
    this.cor = Colors.blue,
    this.altura = 50,
    this.largura = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: altura,
      width: largura,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
        ),
        onPressed: onPressed,
        child: Text(
          texto,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
