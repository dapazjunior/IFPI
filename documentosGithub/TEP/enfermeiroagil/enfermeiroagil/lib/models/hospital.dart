class Hospital {
  final String id;
  final String nome;
  final String? cidade;
  final String? estado;

  Hospital({
    required this.id,
    required this.nome,
    this.cidade,
    this.estado,
  });

  factory Hospital.fromMap(Map<String, dynamic> map) {
    return Hospital(
      id: map['id'] as String,
      nome: map['nome'] as String? ?? '',
      cidade: map['cidade'] as String?,
      estado: map['estado'] as String?,
    );
  }
}