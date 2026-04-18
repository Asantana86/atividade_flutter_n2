class ClienteItem {
  final String nome;
  final String documento;
  final String email;
  final String telefone;

  ClienteItem({
    required this.nome,
    required this.documento,
    required this.email,
    required this.telefone,
  });

  @override
  String toString() => nome;
}

class ClienteService {
  static final ClienteService _instance = ClienteService._internal();
  factory ClienteService() => _instance;
  ClienteService._internal();

  final List<ClienteItem> _clientes = [
    ClienteItem(nome: 'João Silva', documento: '123.456.789-00', email: 'joao@email.com', telefone: '(62) 99999-0001'),
    ClienteItem(nome: 'Maria Souza', documento: '987.654.321-00', email: 'maria@email.com', telefone: '(62) 99999-0002'),
    ClienteItem(nome: 'Carlos Lima', documento: '11.222.333/0001-44', email: 'carlos@email.com', telefone: '(62) 99999-0003'),
    ClienteItem(nome: 'Ana Costa', documento: '55.666.777/0001-88', email: 'ana@email.com', telefone: '(62) 99999-0004'),
  ];

  List<ClienteItem> getAll() => List.unmodifiable(_clientes);

  void add(ClienteItem cliente) => _clientes.add(cliente);
}
