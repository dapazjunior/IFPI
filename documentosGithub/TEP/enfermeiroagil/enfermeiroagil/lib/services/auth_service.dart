import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  Future<void> login(String email, String senha) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: senha,
    );
    if (response.user == null) {
      throw Exception('Erro ao fazer login. Verifique suas credenciais.');
    }
  }

  Future<void> signup(String email, String senha) async {
    final response = await _client.auth.signUp(
      email: email,
      password: senha,
    );
    if (response.user == null) {
      throw Exception('Erro ao cadastrar. Tente novamente.');
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  String get currentUserEmail =>
      _client.auth.currentUser?.email ?? 'Enfermeiro';
}