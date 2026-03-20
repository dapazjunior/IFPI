import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/paciente.dart';

class PacienteService {
  final _client = Supabase.instance.client;

  Future<List<Paciente>> listarPacientes() async {
    final data = await _client
        .from('pacientes')
        .select()
        .order('prioridade', ascending: true) // alta < baixa alfabeticamente
        .order('nome', ascending: true);

    // Ordenação manual por prioridade (alta > media > baixa)
    final lista = (data as List).map((e) => Paciente.fromJson(e)).toList();
    const ordem = {'alta': 0, 'media': 1, 'baixa': 2};
    lista.sort((a, b) =>
        (ordem[a.prioridade] ?? 2).compareTo(ordem[b.prioridade] ?? 2));

    return lista;
  }

  Future<void> criarPaciente({
    required String nome,
    required String leito,
    String prioridade = 'baixa',
    String observacoes = '',
  }) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    await _client.from('pacientes').insert({
      'nome': nome,
      'leito': leito,
      'prioridade': prioridade,
      'observacoes': observacoes,
      'criado_por': userId,
    });
  }

  Future<void> deletarPaciente(String id) async {
    // As tarefas são deletadas automaticamente pelo ON DELETE CASCADE
    await _client.from('pacientes').delete().eq('id', id);
  }
}