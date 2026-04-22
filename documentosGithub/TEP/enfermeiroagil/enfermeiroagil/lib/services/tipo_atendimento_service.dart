import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tipo_atendimento.dart';

class TipoAtendimentoService {
  final SupabaseClient _supabase;

  TipoAtendimentoService(this._supabase);

  Future<List<TipoAtendimento>> listarTiposDisponiveis() async {
    final rows = await _supabase
        .from('tipos_atendimento')
        .select()
        .order('padrao', ascending: false)
        .order('nome', ascending: true);

    return rows.map<TipoAtendimento>((r) => TipoAtendimento.fromMap(r)).toList();
  }

  Future<TipoAtendimento> criarTipoPersonalizado(String nome) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final data = await _supabase
        .from('tipos_atendimento')
        .insert({
          'nome': nome.trim(),
          'padrao': false,
          'criado_por': user.id,
        })
        .select()
        .single();

    return TipoAtendimento.fromMap(data);
  }
}