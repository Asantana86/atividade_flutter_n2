class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  String? _nomeUsuario;

  String? get nomeUsuario => _nomeUsuario;

  void setNomeUsuario(String nome) {
    _nomeUsuario = nome;
  }

  void limpar() {
    _nomeUsuario = null;
  }
}
