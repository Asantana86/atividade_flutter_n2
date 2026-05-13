import '../models/usuario_model.dart';

/// Singleton para guardar os dados do usuário atualmente logado em memória
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  UsuarioModel? _usuarioLogado;

  UsuarioModel? get usuario => _usuarioLogado;
  
  bool get isLogged => _usuarioLogado != null;

  void setUsuario(UsuarioModel usuario) {
    _usuarioLogado = usuario;
  }

  void limpar() {
    _usuarioLogado = null;
  }
}