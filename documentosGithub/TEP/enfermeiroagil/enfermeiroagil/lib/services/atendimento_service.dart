import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/atendimento.dart';

class AtendimentoService {
  final SupabaseClient _supabase;

  AtendimentoService(this._supabase);

  Future<List<Atendimento>> listarProximosDoUsuario() async {
    final rows = await _supabase
        .from('atendimentos')
        .select('''
          *,
          pacientes (
            nome,
            prioridade,
            hospitais (nome)
          ),
          tipos_atendimento (nome)
        ''')
        .eq('status', 'pendente')
        .order('data_prevista', ascending: true)
        .order('horario_previsto', ascending: true);

    return rows.map<Atendimento>((r) => Atendimento.fromMap(r)).toList();
  }

  Future<List<Atendimento>> listarPorPaciente(String pacienteId) async {
    final rows = await _supabase
        .from('atendimentos')
        .select('''
          *,
          tipos_atendimento (nome)
        ''')
        .eq('paciente_id', pacienteId)
        .order('data_prevista', ascending: true)
        .order('horario_previsto', ascending: true);

    return rows.map<Atendimento>((r) => Atendimento.fromMap(r)).toList();
  }

  Future<Atendimento> criarAtendimento({
    required String pacienteId,
    String? tipoAtendimentoId,
    String? descricao,
    DateTime? dataPrevista,
    String? horarioPrevisto,
    bool recorrente = false,
    List<int>? recorrenciaDias,
    DateTime? recorrenciaFim,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final row = await _supabase
        .from('atendimentos')
        .insert({
          'paciente_id': pacienteId,
          'tipo_atendimento_id': tipoAtendimentoId,
          'descricao': descricao?.trim(),
          'data_prevista': dataPrevista?.toIso8601String().split('T').first,
          'horario_previsto': horarioPrevisto?.trim(),
          'recorrente': recorrente,
          'recorrencia_dias': recorrenciaDias,
          'recorrencia_fim':
              recorrenciaFim?.toIso8601String().split('T').first,
          'status': 'pendente',
          'criado_por': user.id,
        })
        .select('''
          *,
          pacientes (
            nome,
            prioridade,
            hospitais (nome)
          ),
          tipos_atendimento (nome)
        ''')
        .single();

    return Atendimento.fromMap(row);
  }

  Future<Atendimento> atualizarAtendimento({
    required String id,
    String? tipoAtendimentoId,
    String? descricao,
    DateTime? dataPrevista,
    String? horarioPrevisto,
    bool? recorrente,
    List<int>? recorrenciaDias,
    DateTime? recorrenciaFim,
    String? status,
  }) async {
    final Map<String, dynamic> dados = {};

    dados['tipo_atendimento_id'] = tipoAtendimentoId;
    dados['descricao'] = descricao?.trim();
    dados['data_prevista'] =
        dataPrevista?.toIso8601String().split('T').first;
    dados['horario_previsto'] = horarioPrevisto?.trim();
    if (recorrente != null) {
      dados['recorrente'] = recorrente;
      dados['recorrencia_dias'] = recorrenciaDias;
      dados['recorrencia_fim'] =
          recorrenciaFim?.toIso8601String().split('T').first;
    }
    if (status != null) {
      dados['status'] = status;
    }

    final row = await _supabase
        .from('atendimentos')
        .update(dados)
        .eq('id', id)
        .select('''
          *,
          pacientes (
            nome,
            prioridade,
            hospitais (nome)
          ),
          tipos_atendimento (nome)
        ''')
        .single();

    return Atendimento.fromMap(row);
  }

  Future<void> marcarConcluido(String id) async {
    await _supabase
        .from('atendimentos')
        .update({
          'status': 'concluido',
          'concluido_em': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
  }

  Future<void> marcarPendente(String id) async {
    await _supabase
        .from('atendimentos')
        .update({
          'status': 'pendente',
          'concluido_em': null,
        })
        .eq('id', id);
  }

  // Mantido por compatibilidade
  Future<void> alternarStatus(Atendimento atendimento) async {
    if (atendimento.status == 'pendente') {
      await marcarConcluido(atendimento.id);
    } else {
      await marcarPendente(atendimento.id);
    }
  }

  Future<void> deletarAtendimento(String id) async {
    await _supabase.from('atendimentos').delete().eq('id', id);
  }
}