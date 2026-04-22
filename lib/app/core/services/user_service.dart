import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  UserModel? _usuarioLogado;

  UserModel? get usuario => _usuarioLogado;
  
  bool get isLogged => _usuarioLogado != null;

  void setUsuario(UserModel usuario) {
    _usuarioLogado = usuario;
  }

  void limpar() {
    _usuarioLogado = null;
  }
}