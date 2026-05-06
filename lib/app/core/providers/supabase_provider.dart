import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseProvider {
  final _client = Supabase.instance.client;

  Future<void> inserir(String tabela, Map<String, dynamic> json) async {
    try {
      await _client.from(tabela).insert(json);
    } catch (e) {
      throw Exception('Erro de comunicação com a Cloud: $e');
    }
  }

}