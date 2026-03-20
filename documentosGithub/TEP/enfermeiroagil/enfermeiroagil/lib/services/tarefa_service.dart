import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tarefa.dart';

class TarefaService {
  final _client = Supabase.instance.client;

  Future<List<Tarefa>> listarTarefas(String pacienteId) async {
    final data = await _client
        .from('tarefas')
        .select()
        .eq('paciente_id', pacienteId)
        .order('horario_previsto', ascending: true, nullsFirst: false);

    return (data as List).map((e) => Tarefa.fromJson(e)).toList();
  }

  Future<void> criarTarefa({
    required String pacienteId,
    required String descricao,
    String? horarioPrevisto,
  }) async {
    await _client.from('tarefas').insert({
      'paciente_id': pacienteId,
      'descricao': descricao,
      'horario_previsto': horarioPrevisto,
    });
  }

  Future<void> alternarStatus(Tarefa tarefa) async {
    final novoStatus =
        tarefa.status == 'pendente' ? 'concluida' : 'pendente';

    await _client.from('tarefas').update({
      'status': novoStatus,
      'concluido_em':
          novoStatus == 'concluida' ? DateTime.now().toIso8601String() : null,
    }).eq('id', tarefa.id);
  }

  Future<void> deletarTarefa(String id) async {
    await _client.from('tarefas').delete().eq('id', id);
  }
}