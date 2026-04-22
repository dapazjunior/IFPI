class Usuario {
  final String id;
  final String email;
  final String nome;
  final String? telefone;
  final String? documento;
  final String tipoUsuario; // 'admin_sistema' | 'gestor' | 'profissional'
  final String? contaId;
  final bool ativo;
  final bool emServico;
  final bool bloqueado; // se não tiver na tabela, remova
  final String role; // legado, se já existir; senão pode remover
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
    required this.role,
    required this.criadoEm,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as String,
      email: map['email'] as String,
      nome: map['nome'] as String,
      telefone: map['telefone'] as String?,
      documento: map['documento'] as String?,
      tipoUsuario: map['tipo_usuario'] as String? ?? 'profissional',
      contaId: map['conta_id'] as String?,
      ativo: map['ativo'] as bool? ?? true,
      emServico: map['em_servico'] as bool? ?? false,
      bloqueado: map['bloqueado'] as bool? ?? false,
      role: map['role'] as String? ?? 'enfermeiro',
      criadoEm: DateTime.parse(map['criado_em'] as String),
    );
  }

  bool get isAdminSistema => tipoUsuario == 'admin_sistema';
  bool get isGestor => tipoUsuario == 'gestor';
  bool get isProfissional => tipoUsuario == 'profissional';
}