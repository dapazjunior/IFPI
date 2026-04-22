class Paciente {
  final String id;
  final String nome;
  final String? leito;
  final String prioridade; // alta | media | baixa
  final String? hospitalId;
  final String? observacoes;
  final String? criadoPor;
  final DateTime criadoEm;

  // Campos auxiliares carregados via join (opcionais)
  final String? hospitalNome;

  Paciente({
    required this.id,
    required this.nome,
    this.leito,
    required this.prioridade,
    this.hospitalId,
    this.observacoes,
    this.criadoPor,
    required this.criadoEm,
    this.hospitalNome,
  });

  factory Paciente.fromMap(Map<String, dynamic> map) {
    // Quando usamos select com join do hospital (hospitais: nome)
    final hospital = map['hospitais'];
    return Paciente(
      id: map['id'] as String,
      nome: map['nome'] as String? ?? '',
      leito: map['leito'] as String?,
      prioridade: map['prioridade'] as String? ?? 'baixa',
      hospitalId: map['hospital_id'] as String?,
      observacoes: map['observacoes'] as String?,
      criadoPor: map['criado_por'] as String?,
      criadoEm: DateTime.parse(map['criado_em'] as String),
      hospitalNome: hospital is Map ? hospital['nome'] as String? : null,
    );
  }
}