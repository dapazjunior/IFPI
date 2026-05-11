import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/conta.dart';

class ContaService {
  final SupabaseClient _supabase;

  ContaService(this._supabase);

  Future<Conta> criarContaIndividual() async {
    final row = await _supabase
        .from('contas')
        .insert({
          'tipo_conta': 'individual',
          'plano': 'individual',
          'limite_profissionais': 1,
        })
        .select()
        .single();

    return Conta.fromMap(row);
  }

  Future<Conta> criarContaGestor({
    required String plano, // 'homecare' | 'equipe'
    required String nomeEquipe,
  }) async {
    final limite = plano == 'homecare' ? 5 : 15;

    final row = await _supabase
        .from('contas')
        .insert({
          'tipo_conta': 'gestor',
          'plano': plano,
          'limite_profissionais': limite,
          'nome_equipe': nomeEquipe,
        })
        .select()
        .single();

    return Conta.fromMap(row);
  }

  Future<Conta?> obterConta(String contaId) async {
    final row = await _supabase
        .from('contas')
        .select()
        .eq('id', contaId)
        .maybeSingle();

    if (row == null) return null;
    return Conta.fromMap(row);
  }

  /// Lista todas as contas do sistema.
  /// Uso exclusivo do admin_sistema — requer RLS permissiva para esse role.
  Future<List<Conta>> listarTodasContas() async {
    final rows = await _supabase
        .from('contas')
        .select()
        .order('criado_em', ascending: false);

    return rows.map<Conta>((r) => Conta.fromMap(r)).toList();
  }

  /// Ativa ou desativa o plano de uma conta (campo plano_ativo).
  Future<void> setPlanoAtivo(String contaId, bool ativo) async {
    await _supabase
        .from('contas')
        .update({'plano_ativo': ativo}).eq('id', contaId);
  }
}