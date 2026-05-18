import 'package:flutter/material.dart';

import '../mixins/loader.mixin.dart';
import '../mixins/messages.mixin.dart';
import 'base_controller.dart'; 

/// Uma classe base para os States do aplicativo.
abstract class BaseState<T extends StatefulWidget, C extends IBaseController>
    extends State<T> with LoaderMixin, MessagesMixin {
  
  C get controller;

  /// Quando false, o State não descarta o controller (ex.: controller compartilhado no dashboard).
  bool get disposeControllerOnDispose => true;

  @override
  void dispose() {
    if (disposeControllerOnDispose) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Callback padrão de SUCESSO para plugar nas operações do Controller
  void onSuccess(String message) {
    if (mounted) showSuccess(context, message);
  }

  /// Callback padrão de ERRO para plugar nas operações do Controller
  void onError(String message) {
    if (mounted) showError(context, message);
  }
}