import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  AuthService();

  User? get usuarioSupabase => _supabase.auth.currentUser;

  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;

  Future<void> login(String email, String senha) async {
    await _supabase.auth.signInWithPassword(email: email, password: senha);
  }

  Future<void> cadastrar({
    required String email,
    required String senha,
    required String nomeCompleto,
  }) async {
    await _supabase.auth.signUp(
      email: email,
      password: senha,
      data: {
        'nome_completo': nomeCompleto,
        'perfil': 'tecnico', 
      },
    );
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}