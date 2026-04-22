class TipoAtendimento {
  final String id;
  final String nome;
  final bool padrao;

  TipoAtendimento({
    required this.id,
    required this.nome,
    required this.padrao,
  });

  factory TipoAtendimento.fromMap(Map<String, dynamic> map) {
    return TipoAtendimento(
      id: map['id'] as String,
      nome: map['nome'] as String? ?? '',
      padrao: map['padrao'] as bool? ?? false,
    );
  }
}