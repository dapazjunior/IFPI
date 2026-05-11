class Usuario {
  final String id;
  final String email;
  final String nome;
  final String? telefone;
  final String? documento;
  final String tipoUsuario;
  final String? contaId;
  final bool ativo;
  final bool emServico;
  final bool bloqueado;
  final DateTime criadoEm;

  Usuario({
    required this.id,
    required this.email,
    required this.nome,
    this.telefone,
    this.documento,
    required this.tipoUsuario,
    this.contaId,
    required this.ativo,
    required this.emServico,
    required this.bloqueado,
    required this.criadoEm,
  });

  static DateTime _parseDate(dynamic value) {
    if (value == null) {
      // fallback simples para evitar crash; se preferir, pode lançar exceção
      return DateTime.now();
    }
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.parse(value);
    }
    throw Exception('Formato de data inválido para criado_em: $value');
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as String,
      email: map['email'] as String,
      nome: map['nome'] as String? ?? '',
      telefone: map['telefone'] as String?,
      documento: map['documento'] as String?,
      tipoUsuario: map['tipo_usuario'] as String? ?? 'profissional',
      contaId: map['conta_id'] as String?,
      ativo: map['ativo'] as bool? ?? true,
      emServico: map['em_servico'] as bool? ?? false,
      bloqueado: map['bloqueado'] as bool? ?? false,
      criadoEm: _parseDate(map['criado_em']),
    );
  }

  bool get isAdminSistema => tipoUsuario == 'admin_sistema';
  bool get isGestor => tipoUsuario == 'gestor';
  bool get isProfissional => tipoUsuario == 'profissional';
}