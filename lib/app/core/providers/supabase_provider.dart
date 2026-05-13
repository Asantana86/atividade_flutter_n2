import 'package:flutter/foundation.dart';

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider {
  final _client = Supabase.instance.client;

  // ─── CAMADA DE BANCO DE DADOS (DATABASE) ───────────────────────────────────

  /// Insere um mapa JSON em uma tabela específica
  Future<void> inserir(String tabela, Map<String, dynamic> json) async {
    try {
      await _client.from(tabela).insert(json);
    } catch (e) {
      throw Exception('Erro ao inserir dados no Supabase: $e');
    }
  }

  // ─── CAMADA DE ARQUIVOS (STORAGE) ──────────────────────────────────────────

  /// Faz o upload de um arquivo local para um Bucket e retorna a URL Pública.
  /// [bucket] é o nome que você criou no painel (ex: 'fotos_os')
  /// [localPath] é o caminho que está salvo no seu SQLite
  Future<String> uploadArquivo(String bucket, String localPath) async {
    try {
      final file = File(localPath);
      
      // 1. Verifica se o arquivo realmente existe no celular antes de tentar subir
      if (!await file.exists()) {
        throw Exception('Arquivo local não encontrado: $localPath');
      }

      // 2. Cria um nome único para o arquivo no servidor para evitar sobrescrita
      // Exemplo: 1715000000_foto.jpg
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(localPath)}';

      // 3. Faz o upload bruto (Binary Upload)
      await _client.storage.from(bucket).upload(fileName, file);

      // 4. Gera e retorna a URL Pública para salvarmos no banco de dados
      final String publicUrl = _client.storage.from(bucket).getPublicUrl(fileName);
      
      debugPrint('✅ Upload concluído: $publicUrl');
      return publicUrl;
    } catch (e) {
      throw Exception('Erro ao subir arquivo para o Storage: $e');
    }
  }
}
