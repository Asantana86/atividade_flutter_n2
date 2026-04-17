import 'package:atividade_flutter_n2/app/core/models/user.model.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  Cliente? _usuario;
  String? _nomeUsuario;

  Cliente? get usuario => _usuario;

  String? get nomeUsuario => _usuario?.nome ?? _nomeUsuario;

  void setUsuario(Cliente usuario) {
    _usuario = usuario;
    _nomeUsuario = usuario.nome;
  }

  void setNomeUsuario(String nome) {
    _nomeUsuario = nome;
  }

  void limpar() {
    _usuario = null;
    _nomeUsuario = null;
  }
}
