class Atendimento {
  final String id;
  final String pacienteId;
  final String? tipoAtendimentoId;
  final String? descricao;
  final String? horarioPrevisto;
  final DateTime? dataPrevista;
  final bool recorrente;
  final List<int>? recorrenciaDias; // 0=dom,1=seg,2=ter,3=qua,4=qui,5=sex,6=sab
  final DateTime? recorrenciaFim;
  final String status;
  final String? criadoPor;
  final DateTime criadoEm;
  final String? pacienteNome;
  final String? hospitalNome;
  final String? tipoAtendimentoNome;
  final String? prioridade;

  Atendimento({
    required this.id,
    required this.pacienteId,
    this.tipoAtendimentoId,
    this.descricao,
    this.horarioPrevisto,
    this.dataPrevista,
    required this.recorrente,
    this.recorrenciaDias,
    this.recorrenciaFim,
    required this.status,
    this.criadoPor,
    required this.criadoEm,
    this.pacienteNome,
    this.hospitalNome,
    this.tipoAtendimentoNome,
    this.prioridade,
  });

  static DateTime? _parseDateNullable(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.parse(value);
    }
    throw Exception('Formato de data inválido para criado_em: $value');
  }

  factory Atendimento.fromMap(Map<String, dynamic> map) {
    final paciente = map['pacientes'];
    final hospital = paciente is Map ? paciente['hospitais'] : null;
    final tipo = map['tipos_atendimento'];

    // recorrencia_dias vem como List<dynamic> do Supabase
    List<int>? dias;
    if (map['recorrencia_dias'] != null) {
      final raw = map['recorrencia_dias'];
      if (raw is List) {
        dias = raw.map((e) => (e as num).toInt()).toList();
      }
    }

    return Atendimento(
      id: map['id'] as String,
      pacienteId: map['paciente_id'] as String,
      tipoAtendimentoId: map['tipo_atendimento_id'] as String?,
      descricao: map['descricao'] as String?,
      horarioPrevisto: map['horario_previsto'] as String?,
      dataPrevista: _parseDateNullable(map['data_prevista']),
      recorrente: map['recorrente'] as bool? ?? false,
      recorrenciaDias: dias,
      recorrenciaFim: _parseDateNullable(map['recorrencia_fim']),
      status: map['status'] as String? ?? 'pendente',
      criadoPor: map['criado_por'] as String?,
      criadoEm: _parseDate(map['criado_em']),
      pacienteNome: paciente is Map ? paciente['nome'] as String? : null,
      prioridade: paciente is Map ? paciente['prioridade'] as String? : null,
      hospitalNome: hospital is Map ? hospital['nome'] as String? : null,
      tipoAtendimentoNome: tipo is Map ? tipo['nome'] as String? : null,
    );
  }

  String get recorrenciaDiasLabel {
    if (recorrenciaDias == null || recorrenciaDias!.isEmpty) return '';
    const nomes = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    return recorrenciaDias!.map((d) {
      if (d < 0 || d > 6) return '?';
      return nomes[d];
    }).join(', ');
  }
}