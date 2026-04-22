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

  factory Conta.fromMap(Map<String, dynamic> map) {
    return Conta(
      id: map['id'] as String,
      tipoConta: map['tipo_conta'] as String,
      plano: map['plano'] as String,
      limiteProfissionais: map['limite_profissionais'] as int,
      nomeEquipe: map['nome_equipe'] as String?,
      planoAtivo: map['plano_ativo'] as bool? ?? true,
      statusPagamento: map['status_pagamento'] as String? ?? 'ativo',
      criadoEm: DateTime.parse(map['criado_em'] as String),
    );
  }
}