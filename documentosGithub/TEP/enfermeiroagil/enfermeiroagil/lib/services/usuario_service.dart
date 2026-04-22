import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario.dart';

class UsuarioService {
  final SupabaseClient _supabase;

  UsuarioService(this._supabase);

  Future<Usuario> getPerfilAtual() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final row = await _supabase
        .from('usuarios')
        .select()
        .eq('id', user.id)
        .single();

    return Usuario.fromMap(row);
  }

  Future<Usuario> atualizarDadosUsuario({
    required String usuarioId,
    String? contaId,
    String? tipoUsuario,
    String? nome,
    String? telefone,
    String? documento,
  }) async {
    final dados = <String, dynamic>{};

    if (contaId != null) dados['conta_id'] = contaId;
    if (tipoUsuario != null) dados['tipo_usuario'] = tipoUsuario;
    if (nome != null) dados['nome'] = nome.trim();
    if (telefone != null) dados['telefone'] = telefone.trim();
    if (documento != null) dados['documento'] = documento.trim();

    final row = await _supabase
        .from('usuarios')
        .update(dados)
        .eq('id', usuarioId)
        .select()
        .single();

    return Usuario.fromMap(row);
  }

  Future<List<Usuario>> listarProfissionaisDaConta(String contaId) async {
    final rows = await _supabase
        .from('usuarios')
        .select()
        .eq('conta_id', contaId)
        .eq('tipo_usuario', 'profissional')
        .order('nome');

    return rows.map<Usuario>((r) => Usuario.fromMap(r)).toList();
  }

  Future<int> contarProfissionaisDaConta(String contaId) async {
    // A versão atual do supabase_flutter não aceita FetchOptions no select().
    // Buscamos a lista e contamos localmente.
    final rows = await _supabase
        .from('usuarios')
        .select('id')
        .eq('conta_id', contaId)
        .eq('tipo_usuario', 'profissional');

    return rows.length;
  }

  Future<void> setAtivo(String usuarioId, bool ativo) async {
    await _supabase
        .from('usuarios')
        .update({'ativo': ativo}).eq('id', usuarioId);
  }

  Future<void> setEmServico(bool emServico) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    await _supabase
        .from('usuarios')
        .update({'em_servico': emServico}).eq('id', user.id);
  }
}