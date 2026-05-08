import 'package:flutter/material.dart';
mixin LoaderMixin {
  void showLoading(BuildContext context, {String message = 'Carregando...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void hideLoading(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Future<T?> withLoading<T>(
    BuildContext context,
    Future<T> operation, {
    String? loadingMessage,
  }) async {
    try {
      showLoading(context, message: loadingMessage ?? 'Carregando...');
      final result = await operation;
      hideLoading(context);
      return result;
    } catch (e) {
      hideLoading(context);
      rethrow;
    }
  }
}