class Conta {
  final String id;
  final String tipoConta; // 'individual' | 'gestor'
  final String plano; // 'individual' | 'homecare' | 'equipe'
  final int limiteProfissionais;
  final String? nomeEquipe;
  final bool planoAtivo;
  final String statusPagamento; // 'ativo', 'pendente', 'cancelado', etc.
  final DateTime criadoEm;

  Conta({
    required this.id,
    required this.tipoConta,
    required this.plano,
    required this.limiteProfissionais,
    this.nomeEquipe,
    required this.planoAtivo,
    required this.statusPagamento,
    required this.criadoEm,
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

  factory Conta.fromMap(Map<String, dynamic> map) {
    return Conta(
      id: map['id'] as String,
      tipoConta: map['tipo_conta'] as String,
      plano: map['plano'] as String,
      limiteProfissionais: map['limite_profissionais'] as int,
      nomeEquipe: map['nome_equipe'] as String?,
      planoAtivo: map['plano_ativo'] as bool? ?? true,
      statusPagamento: map['status_pagamento'] as String? ?? 'ativo',
      criadoEm: _parseDate(map['criado_em']),
    );
  }
}