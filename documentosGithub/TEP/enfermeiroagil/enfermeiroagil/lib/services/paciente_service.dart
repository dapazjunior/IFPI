import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/paciente.dart';

class PacienteService {
  final SupabaseClient _supabase;

  PacienteService(this._supabase);

  /// Lista pacientes que o usuário atual pode ver (RLS já filtra),
  /// trazendo também o hospital (nome) via join.
  Future<List<Paciente>> listarPacientesDoUsuario() async {
    final rows = await _supabase
        .from('pacientes')
        .select('*, hospitais (nome)')
        .order('criado_em', ascending: false);

    return rows.map<Paciente>((r) => Paciente.fromMap(r)).toList();
  }

  /// Cria paciente e vincula automaticamente o enfermeiro atual
  Future<Paciente> criarPaciente({
    required String nome,
    String? leito,
    required String prioridade,
    String? hospitalId,
    String? observacoes,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    // 1) criar paciente
    final pacienteRow = await _supabase
        .from('pacientes')
        .insert({
          'nome': nome.trim(),
          'leito': leito?.trim(),
          'prioridade': prioridade,
          'hospital_id': hospitalId,
          'observacoes': observacoes?.trim(),
          'criado_por': user.id,
        })
        .select('*, hospitais (nome)')
        .single();

    final paciente = Paciente.fromMap(pacienteRow);

    // 2) vincular enfermeiro atual na tabela paciente_enfermeiros
    await _supabase.from('paciente_enfermeiros').insert({
      'paciente_id': paciente.id,
      'enfermeiro_id': user.id,
      'adicionado_por': user.id,
    });

    return paciente;
  }

  /// Compartilha paciente com outro enfermeiro
  Future<void> compartilharPacienteComEnfermeiro({
    required String pacienteId,
    required String enfermeiroId,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    await _supabase.from('paciente_enfermeiros').upsert({
      'paciente_id': pacienteId,
      'enfermeiro_id': enfermeiroId,
      'adicionado_por': user.id,
    });
  }

  Future<void> deletarPaciente(String pacienteId) async {
    await _supabase
        .from('pacientes')
        .delete()
        .eq('id', pacienteId);
  }
}