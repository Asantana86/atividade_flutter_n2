class Cliente {
  final String nome;
  final String email;
  final String senha;

  Cliente({required this.nome, required this.email, required this.senha});

  Cliente.fromMap(Map<String, dynamic> map)
    : nome = map['nome'] as String,
      email = map['email'] as String,
      senha = map['senha'] as String;

  @override
  Map<String, dynamic> toMap() {
    return {'nome': nome, 'email': email, 'senha': senha};
  }
}
