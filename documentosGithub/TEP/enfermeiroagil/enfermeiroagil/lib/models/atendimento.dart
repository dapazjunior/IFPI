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

  factory Atendimento.fromMap(Map<String, dynamic> map) {
    final paciente = map['pacientes'];
    final hospital = paciente is Map ? paciente['hospitais'] : null;
    final tipo = map['tipos_atendimento'];

    // recorrencia_dias vem como List<dynamic> do Supabase
    List<int>? dias;
    if (map['recorrencia_dias'] != null) {
      dias = (map['recorrencia_dias'] as List).map((e) => e as int).toList();
    }

    return Atendimento(
      id: map['id'] as String,
      pacienteId: map['paciente_id'] as String,
      tipoAtendimentoId: map['tipo_atendimento_id'] as String?,
      descricao: map['descricao'] as String?,
      horarioPrevisto: map['horario_previsto'] as String?,
      dataPrevista: map['data_prevista'] != null
          ? DateTime.tryParse(map['data_prevista'] as String)
          : null,
      recorrente: map['recorrente'] as bool? ?? false,
      recorrenciaDias: dias,
      recorrenciaFim: map['recorrencia_fim'] != null
          ? DateTime.tryParse(map['recorrencia_fim'] as String)
          : null,
      status: map['status'] as String? ?? 'pendente',
      criadoPor: map['criado_por'] as String?,
      criadoEm: DateTime.parse(map['criado_em'] as String),
      pacienteNome: paciente is Map ? paciente['nome'] as String? : null,
      prioridade: paciente is Map ? paciente['prioridade'] as String? : null,
      hospitalNome: hospital is Map ? hospital['nome'] as String? : null,
      tipoAtendimentoNome: tipo is Map ? tipo['nome'] as String? : null,
    );
  }

  // Label legível dos dias de recorrência
  String get recorrenciaDiasLabel {
    if (recorrenciaDias == null || recorrenciaDias!.isEmpty) return '';
    const nomes = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    return recorrenciaDias!.map((d) => nomes[d]).join(', ');
  }
}