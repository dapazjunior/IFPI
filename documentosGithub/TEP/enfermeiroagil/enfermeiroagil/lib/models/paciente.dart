class Paciente {
  final String id;
  final String nome;
  final String? leito;
  final String prioridade; // alta | media | baixa
  final String? hospitalId;
  final String? observacoes;
  final String? criadoPor;
  final String? contaId;
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
    this.contaId,
    required this.criadoEm,
    this.hospitalNome,
  });

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
      contaId: map['conta_id'] as String?,
      criadoEm: _parseDate(map['criado_em']),
      hospitalNome: hospital is Map ? hospital['nome'] as String? : null,
    );
  }
}