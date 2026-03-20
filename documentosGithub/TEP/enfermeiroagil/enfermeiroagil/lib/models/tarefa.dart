class Tarefa {
  final String id;
  final String pacienteId;
  final String descricao;
  final String? horarioPrevisto;
  final String status;
  final String? concluidoEm;

  Tarefa({
    required this.id,
    required this.pacienteId,
    required this.descricao,
    this.horarioPrevisto,
    required this.status,
    this.concluidoEm,
  });

  bool get concluida => status == 'concluida';

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    return Tarefa(
      id: json['id'] as String,
      pacienteId: json['paciente_id'] as String,
      descricao: json['descricao'] as String,
      horarioPrevisto: json['horario_previsto'] as String?,
      status: json['status'] as String? ?? 'pendente',
      concluidoEm: json['concluido_em'] as String?,
    );
  }
}