class Paciente {
  final String id;
  final String nome;
  final String leito;
  final String prioridade;
  final String observacoes;
  final String? criadoPor;

  Paciente({
    required this.id,
    required this.nome,
    required this.leito,
    required this.prioridade,
    required this.observacoes,
    this.criadoPor,
  });

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      id: json['id'] as String,
      nome: json['nome'] as String,
      leito: json['leito'] as String,
      prioridade: json['prioridade'] as String? ?? 'baixa',
      observacoes: json['observacoes'] as String? ?? '',
      criadoPor: json['criado_por'] as String?,
    );
  }
}