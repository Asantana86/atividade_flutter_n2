import 'package:connectivity_plus/connectivity_plus.dart';

// Importa o Provider
import '../providers/supabase_provider.dart';

// Importa os Repositórios
import '../repositories/cliente_repository.dart';
import '../repositories/tecnico_repository.dart';
import '../repositories/servico_repository.dart';
import '../repositories/ordem_servico_repository.dart';
import '../repositories/os_item_repository.dart';

class AgendadorWorker {
  static final AgendadorWorker _instance = AgendadorWorker._internal();
  factory AgendadorWorker() => _instance;
  AgendadorWorker._internal();

  final _provider = SupabaseProvider();
  
  // Instancia todos os operários
  final _clienteRepo = ClienteRepository();
  final _tecnicoRepo = TecnicoRepository();
  final _servicoRepo = ServicoRepository();
  final _osRepo = OrdemServicoRepository();
  final _osItemRepo = OsItemRepository();

  void iniciar() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!results.contains(ConnectivityResult.none)) {
        executarSincronizacao();
      }
    });
  }

  /// O Maestro da Sincronização
  Future<void> executarSincronizacao() async {
    print('🔄 Iniciando sincronização com a nuvem...');
    
    try {
      // A ORDEM AQUI É VITAL PARA NÃO DAR ERRO DE FOREIGN KEY!
      // 1. Tabelas independentes (Não dependem de ninguém)
      await _syncClientes();
      await _syncTecnicos();
      await _syncServicos();
      
      // 2. Tabelas dependentes (Precisam que Clientes e Técnicos já existam)
      await _syncOrdensServico();
      
      // 3. Tabelas filhas (Precisam que a Ordem e o Serviço já existam)
      await _syncOsItens();

      print('✅ Sincronização finalizada com sucesso!');
    } catch (e) {
      print('❌ Falha geral no agendador: $e');
    }
  }

  // ─── LÓGICA DE CADA TABELA ────────────────────────────────────────────────

  Future<void> _syncClientes() async {
    final todos = await _clienteRepo.getAll();
    final pendentes = todos.where((c) => !c.isSync).toList();

    for (var cliente in pendentes) {
      final json = cliente.toMap();
      json.remove('is_sync'); // O Supabase não precisa dessa coluna

      await _provider.inserir('clientes', json);
      
      cliente.isSync = true;
      await _clienteRepo.update(cliente);
    }
  }

  Future<void> _syncTecnicos() async {
    final todos = await _tecnicoRepo.getAll();
    final pendentes = todos.where((t) => !t.isSync).toList();

    for (var tec in pendentes) {
      final json = tec.toMap();
      json.remove('is_sync');

      await _provider.inserir('tecnicos', json);
      
      tec.isSync = true;
      await _tecnicoRepo.update(tec);
    }
  }

  Future<void> _syncServicos() async {
    final todos = await _servicoRepo.getAll();
    final pendentes = todos.where((s) => !s.isSync).toList();

    for (var servico in pendentes) {
      final json = servico.toMap();
      json.remove('is_sync');

      await _provider.inserir('servicos', json);
      
      servico.isSync = true;
      await _servicoRepo.update(servico);
    }
  }

  Future<void> _syncOrdensServico() async {
    final pendentes = await _osRepo.getUnsyncedOrders();

    for (var os in pendentes) {
      final json = os.toMap();

      // --- TRATAMENTO DAS FOTOS ---
      
      // 1. Foto Antes
      // Se tiver foto e ela não for um link da internet (http), nós subimos!
      if (os.fotoAntes != null && !os.fotoAntes!.startsWith('http')) {
        final urlPublica = await _provider.uploadArquivo('fotos_os', os.fotoAntes!);
        json['foto_antes'] = urlPublica; // Substitui o caminho local pelo link
        os.fotoAntes = urlPublica;       // Atualiza a entidade para salvar no SQLite depois
      }

      // 2. Foto Depois
      if (os.fotoDepois != null && !os.fotoDepois!.startsWith('http')) {
        final urlPublica = await _provider.uploadArquivo('fotos_os', os.fotoDepois!);
        json['foto_depois'] = urlPublica;
        os.fotoDepois = urlPublica;
      }

      // Limpa os dados de controle
      json.remove('is_sync');

      // Envia para o Supabase!
      await _provider.inserir('ordens_servico', json);

      // Marca como sincronizado no SQLite
      os.isSync = true;
      await _osRepo.update(os);
    }
  }

  Future<void> _syncOsItens() async {
    final todos = await _osItemRepo.getAll();
    final pendentes = todos.where((i) => !i.isSync).toList();

    for (var item in pendentes) {
      final json = item.toMap();
      json.remove('is_sync');

      await _provider.inserir('os_itens', json);
      
      item.isSync = true;
      await _osItemRepo.update(item);
    }
  }
}
