import 'package:flutter/material.dart';

mixin LoaderMixin {
  bool _isLoaderOpen = false;

  void showLoading(BuildContext context) {
    if (_isLoaderOpen) return;
    _isLoaderOpen = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ]
              ),
              child: const CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }

  void hideLoading(BuildContext context) {
    if (_isLoaderOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      _isLoaderOpen = false;
    }
  }
}