import 'package:flutter/foundation.dart';

import 'base_service.dart';
import 'base_validation.dart';
import 'base_model.dart';
import 'base_repository.dart';

/// INTERFACE PURA PARA A UI
abstract class IBaseController {
  ValueNotifier<bool> get isLoading;

  void dispose();

  Future<T?> executeOperation<T>(
    Future<T> operation, {
    void Function(String)? onSuccess,
    void Function(String)? onError,
    String? successMessage,
  });

  Future<List<T>> executeListOperation<T>(
    Future<List<T>> operation, {
    void Function(String)? onError,
    String? customErrorMessage,
  });

  Future<bool> executeCrudOperation(
    Future<void> operation, {
    void Function(String)? onSuccess,
    void Function(String)? onError,
    String? successMessage,
  });
}

abstract class BaseController<
  E extends BaseModel,
  R extends BaseRepository<E>,
  V extends BaseValidation<E, R>,
  S extends BaseService<E, R, V>
>
    implements IBaseController {
  final S service;
  final E? model;

  // Estado universal de carregamento que pode ser escutado pela Page
  @override
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  bool _isDisposed = false;

  BaseController(this.service, {this.model});

  /// Fecha/limpa os recursos do Controller quando a Page é destruída
  @override
  @mustCallSuper
  void dispose() {
    _isDisposed = true;
    isLoading.dispose();
  }

  /// Executa uma operação genérica gerenciando o estado de loading e erros.
  /// Retorna o resultado da operação ou null em caso de falha.
  @override
  Future<T?> executeOperation<T>(
    Future<T> operation, {
    void Function(String)? onSuccess,
    void Function(String)? onError,
    String? successMessage,
  }) async {
    try {
      if (!_isDisposed) isLoading.value = true;
      final result = await operation;

      if (successMessage != null && onSuccess != null) {
        onSuccess(successMessage);
      }
      return result;
    } catch (e) {
      _handleException(e, onError);
      return null;
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }

  /// Executa operação de listagem, retornando lista vazia em caso de falha.
  @override
  Future<List<T>> executeListOperation<T>(
    Future<List<T>> operation, {
    void Function(String)? onError,
    String? customErrorMessage,
  }) async {
    try {
      if (!_isDisposed) isLoading.value = true;
      return await operation;
    } catch (e) {
      _handleException(e, onError, customMessage: customErrorMessage);
      return [];
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }

  /// Executa operação CRUD (Create, Update, Delete) gerenciando o loading
  /// e retornando um booleano de sucesso. (A confirmação (Dialog) fica na Page).
  @override
  Future<bool> executeCrudOperation(
    Future<void> operation, {
    void Function(String)? onSuccess,
    void Function(String)? onError,
    String? successMessage,
  }) async {
    try {
      if (!_isDisposed) isLoading.value = true;
      await operation;

      if (successMessage != null && onSuccess != null) {
        onSuccess(successMessage);
      }
      return true;
    } catch (e) {
      _handleException(e, onError);
      return false;
    } finally {
      if (!_isDisposed) isLoading.value = false;
    }
  }

  /// Tratamento centralizado de exceções que devolve a mensagem formatada
  /// para o callback [onError], que será responsável por mostrá-la na UI.
  void _handleException(
    dynamic exception,
    void Function(String)? onError, {
    String? customMessage,
  }) {
    if (onError == null)
      return; // Se a tela não pediu pra ser avisada, não faz nada

    String errorMessage;

    if (exception is FormatException) {
      errorMessage = 'Erro de formato de dados: ${exception.message}';
    } else if (exception is ArgumentError) {
      errorMessage = 'Parâmetro inválido: ${exception.message}';
    } else if (exception is StateError) {
      errorMessage = 'Erro de estado da aplicação: ${exception.message}';
    } else if (exception.toString().contains('SQL') ||
        exception.toString().contains('sqlite')) {
      errorMessage = 'Erro no banco de dados local. Tente novamente.';
    } else if (exception.toString().contains('HTTP') ||
        exception.toString().contains('network')) {
      errorMessage = 'Erro de conexão com o servidor.';
    } else if (exception.toString().contains('Exception:')) {
      // Limpa o prefixo "Exception: " gerado pelas nossas validações
      errorMessage = exception.toString().replaceAll('Exception: ', '');
    } else {
      errorMessage = customMessage ?? 'Ocorreu um erro inesperado: $exception';
    }

    onError(errorMessage);
  }
}
