import '../models/cliente_model.dart';

class ClienteService {
  static final ClienteService _instance = ClienteService._internal();
  factory ClienteService() => _instance;
  ClienteService._internal();

  final List<ClienteModel> _clientes = [
    ClienteModel(id: 1, nome: 'João Silva', documento: '123.456.789-00', email: 'joao@email.com', telefone: '(62) 99999-0001'),
    ClienteModel(id: 2, nome: 'Maria Souza', documento: '987.654.321-00', email: 'maria@email.com', telefone: '(62) 99999-0002'),
    ClienteModel(id: 3, nome: 'Carlos Lima', documento: '11.222.333/0001-44', email: 'carlos@email.com', telefone: '(62) 99999-0003'),
    ClienteModel(id: 4, nome: 'Ana Costa', documento: '55.666.777/0001-88', email: 'ana@email.com', telefone: '(62) 99999-0004'),
  ];

  List<ClienteModel> getAll() => List.unmodifiable(_clientes);

  void add(ClienteModel cliente) {
    final int newId = _clientes.isNotEmpty ? _clientes.last.id! + 1 : 1;
    
    final novoCliente = ClienteModel(
      id: newId,
      nome: cliente.nome,
      documento: cliente.documento,
      email: cliente.email,
      telefone: cliente.telefone,
    );
    
    _clientes.add(novoCliente);
  }
}