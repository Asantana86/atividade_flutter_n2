import '../models/usuario_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

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