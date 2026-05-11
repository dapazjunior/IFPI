import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/paciente.dart';
import 'usuario_service.dart';

class PacienteService {
  final SupabaseClient _supabase;

  PacienteService(this._supabase);

  Future<List<Paciente>> listarPacientesDoUsuario() async {
    final rows = await _supabase
        .from('pacientes')
        .select('*, hospitais (nome)')
        .order('criado_em', ascending: false);

    return rows.map<Paciente>((r) => Paciente.fromMap(r)).toList();
  }

  Future<List<Paciente>> listarPacientesDaConta(String contaId) async {
    final rows = await _supabase
        .from('pacientes')
        .select('*, hospitais (nome)')
        .eq('conta_id', contaId)
        .order('criado_em', ascending: false);

    return rows.map<Paciente>((r) => Paciente.fromMap(r)).toList();
  }

  Future<List<Paciente>> listarPacientesDaContaPorProfissional({
    required String contaId,
    required String profissionalId,
  }) async {
    final rowsVinculados = await _supabase
        .from('pacientes')
        .select(
            '*, hospitais (nome), paciente_enfermeiros!inner(enfermeiro_id)')
        .eq('conta_id', contaId)
        .eq('paciente_enfermeiros.enfermeiro_id', profissionalId)
        .order('criado_em', ascending: false);

    final rowsCriados = await _supabase
        .from('pacientes')
        .select('*, hospitais (nome)')
        .eq('conta_id', contaId)
        .eq('criado_por', profissionalId)
        .order('criado_em', ascending: false);

    final Map<String, Paciente> mapa = {};
    for (final r in [...rowsVinculados, ...rowsCriados]) {
      final p = Paciente.fromMap(r);
      mapa[p.id] = p;
    }

    final lista = mapa.values.toList();
    lista.sort((a, b) => b.criadoEm.compareTo(a.criadoEm));
    return lista;
  }

  Future<Paciente> criarPaciente({
    required String nome,
    String? leito,
    required String prioridade,
    String? hospitalId,
    String? observacoes,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final usuarioService = UsuarioService(_supabase);
    final usuario = await usuarioService.getPerfilAtual();

    if (usuario.contaId == null) {
      throw Exception('Usuário sem conta associada.');
    }

    final pacienteRow = await _supabase
        .from('pacientes')
        .insert({
          'nome': nome.trim(),
          'leito': leito?.trim(),
          'prioridade': prioridade,
          'hospital_id': hospitalId,
          'observacoes': observacoes?.trim(),
          'criado_por': user.id,
          'conta_id': usuario.contaId,
        })
        .select('*, hospitais (nome)')
        .single();

    final paciente = Paciente.fromMap(pacienteRow);

    // Vincula o criador do paciente
    await _supabase.from('paciente_enfermeiros').insert({
      'paciente_id': paciente.id,
      'enfermeiro_id': user.id,
      'adicionado_por': user.id,
    });

    // Se for gestor, vincula automaticamente todos os profissionais da conta
    if (usuario.isGestor) {
      final profissionais = await usuarioService
          .listarProfissionaisDaConta(usuario.contaId!);

      for (final prof in profissionais) {
        await _supabase.from('paciente_enfermeiros').upsert({
          'paciente_id': paciente.id,
          'enfermeiro_id': prof.id,
          'adicionado_por': user.id,
        });
      }
    }

    return paciente;
  }

  Future<Paciente> editarPaciente({
    required String id,
    required String nome,
    String? leito,
    required String prioridade,
    String? hospitalId,
    String? observacoes,
  }) async {
    final row = await _supabase
        .from('pacientes')
        .update({
          'nome': nome.trim(),
          'leito': leito?.trim(),
          'prioridade': prioridade,
          'hospital_id': hospitalId,
          'observacoes': observacoes?.trim(),
        })
        .eq('id', id)
        .select('*, hospitais (nome)')
        .single();

    return Paciente.fromMap(row);
  }

  Future<void> compartilharPacienteComEnfermeiro({
    required String pacienteId,
    required String enfermeiroId,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    await _supabase.from('paciente_enfermeiros').upsert({
      'paciente_id': pacienteId,
      'enfermeiro_id': enfermeiroId,
      'adicionado_por': user.id,
    });
  }

  Future<void> compartilharComTodaEquipe({
    required String pacienteId,
    required String contaId,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado');

    final usuarioService = UsuarioService(_supabase);
    final profissionais =
        await usuarioService.listarProfissionaisDaConta(contaId);

    for (final prof in profissionais) {
      await _supabase.from('paciente_enfermeiros').upsert({
        'paciente_id': pacienteId,
        'enfermeiro_id': prof.id,
        'adicionado_por': user.id,
      });
    }
  }

  Future<void> deletarPaciente(String pacienteId) async {
    await _supabase.from('pacientes').delete().eq('id', pacienteId);
  }
}