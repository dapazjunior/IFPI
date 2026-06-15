import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/usuario.dart';
import '../models/conta.dart';
import '../services/auth_service.dart';
import '../services/usuario_service.dart';
import '../services/conta_service.dart';
import 'login_screen.dart';

class AdminSistemaScreen extends StatefulWidget {
  final Usuario usuario;

  const AdminSistemaScreen({super.key, required this.usuario});

  @override
  State<AdminSistemaScreen> createState() => _AdminSistemaScreenState();
}

class _AdminSistemaScreenState extends State<AdminSistemaScreen> {
  late final UsuarioService _usuarioService;
  late final ContaService _contaService;
  late final AuthService _authService;

  List<Usuario> _usuarios = [];
  List<Conta> _contas = [];
  bool _carregando = true;
  int _abaSelecionada = 0;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _usuarioService = UsuarioService(supabase);
    _contaService = ContaService(supabase);
    _authService = AuthService();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);
    try {
      final usuarios = await _usuarioService.listarTodosUsuarios();
      final contas = await _contaService.listarTodasContas();
      setState(() {
        _usuarios = usuarios;
        _contas = contas;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Future<void> _alternarPlanoAtivo(Conta conta) async {
    try {
      await _contaService.setPlanoAtivo(conta.id, !conta.planoAtivo);
      await _carregarDados();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar conta: $e')),
      );
    }
  }

  Future<void> _alternarBloqueado(Usuario u) async {
    try {
      await _usuarioService.setBloqueado(u.id, !u.bloqueado);
      await _carregarDados();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar usuário: $e')),
      );
    }
  }

  String _labelTipoUsuario(String tipo) {
    switch (tipo) {
      case 'admin_sistema':
        return 'Admin Sistema';
      case 'gestor':
        return 'Gestor';
      case 'profissional':
        return 'Profissional';
      default:
        return tipo;
    }
  }

  Color _corTipo(Usuario u) {
    if (u.isAdminSistema) return Colors.purple;
    if (u.isGestor) return Colors.blue;
    return const Color(0xFF00796B);
  }

  Widget _buildHeader() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primary.withOpacity(0.80)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Painel do Sistema',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.usuario.nome,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Admin Sistema',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _carregarDados,
                    tooltip: 'Atualizar',
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: _logout,
                    tooltip: 'Sair',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : IndexedStack(
                    index: _abaSelecionada,
                    children: [
                      _buildResumo(),
                      _buildContas(),
                      _buildUsuarios(),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _abaSelecionada,
        onDestinationSelected: (i) =>
            setState(() => _abaSelecionada = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Resumo',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business),
            label: 'Contas',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Usuários',
          ),
        ],
      ),
    );
  }

  // ─── Aba Resumo ───────────────────────────────────────────────────────────

  Widget _buildResumo() {
    final totalContas = _contas.length;
    final contasAtivas = _contas.where((c) => c.planoAtivo).length;
    final totalUsuarios = _usuarios.length;
    final bloqueados = _usuarios.where((u) => u.bloqueado).length;
    final gestores = _usuarios.where((u) => u.isGestor).length;
    final profissionais = _usuarios.where((u) => u.isProfissional).length;
    final contasInativas = _contas.where((c) => !c.planoAtivo).toList();

    return RefreshIndicator(
      onRefresh: _carregarDados,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          // Grid de métricas
          Row(
            children: [
              Expanded(
                child: _metricCard(
                  icon: Icons.business,
                  cor: const Color(0xFF00796B),
                  valor: '$totalContas',
                  label: 'Contas',
                  sub: '$contasAtivas ativas',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _metricCard(
                  icon: Icons.people,
                  cor: Colors.blue,
                  valor: '$totalUsuarios',
                  label: 'Usuários',
                  sub: '$bloqueados bloqueados',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _metricCard(
                  icon: Icons.manage_accounts,
                  cor: Colors.purple,
                  valor: '$gestores',
                  label: 'Gestores',
                  sub: 'no sistema',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _metricCard(
                  icon: Icons.badge,
                  cor: Colors.orange,
                  valor: '$profissionais',
                  label: 'Profissionais',
                  sub: 'cadastrados',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Contas suspensas
          Row(
            children: [
              const Text(
                'Contas com plano desativado',
                style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              if (contasInativas.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${contasInativas.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          if (contasInativas.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle,
                      color: Colors.green.shade600, size: 20),
                  const SizedBox(width: 10),
                  const Text(
                    'Todas as contas estão ativas.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          else
            ...contasInativas.map(
              (c) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber,
                        color: Colors.red.shade400, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.nomeEquipe ?? c.tipoConta.toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Pagamento: ${c.statusPagamento}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _alternarPlanoAtivo(c),
                      child: const Text('Reativar'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _metricCard({
    required IconData icon,
    required Color cor,
    required String valor,
    required String label,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: cor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valor,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: cor,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Aba Contas ───────────────────────────────────────────────────────────

  Widget _buildContas() {
    if (_contas.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.business_outlined,
                    size: 48, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 20),
              const Text(
                'Nenhuma conta cadastrada.',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarDados,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
        itemCount: _contas.length,
        itemBuilder: (context, index) {
          final c = _contas[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border(
                left: BorderSide(
                  color: c.planoAtivo
                      ? const Color(0xFF00796B)
                      : Colors.red.shade300,
                  width: 4,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 4),
              leading: CircleAvatar(
                backgroundColor: c.planoAtivo
                    ? const Color(0xFF00796B)
                    : Colors.red.shade300,
                child: Icon(
                  c.tipoConta == 'gestor' ? Icons.groups : Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: Text(
                c.nomeEquipe ?? c.tipoConta.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plano: ${c.plano} · Limite: ${c.limiteProfissionais} prof.',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: c.statusPagamento == 'ativo'
                            ? Colors.green
                            : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Pagamento: ${c.statusPagamento}',
                        style: TextStyle(
                          fontSize: 12,
                          color: c.statusPagamento == 'ativo'
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Switch(
                value: c.planoAtivo,
                onChanged: (_) => _alternarPlanoAtivo(c),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Aba Usuários ─────────────────────────────────────────────────────────

  Widget _buildUsuarios() {
    if (_usuarios.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.people_outline,
                    size: 48, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 20),
              const Text(
                'Nenhum usuário encontrado.',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarDados,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
        itemCount: _usuarios.length,
        itemBuilder: (context, index) {
          final u = _usuarios[index];
          final cor = _corTipo(u);

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 4),
              leading: CircleAvatar(
                backgroundColor: cor,
                child: Text(
                  u.nome.isNotEmpty ? u.nome[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                u.nome,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    u.email,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: cor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _labelTipoUsuario(u.tipoUsuario),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: cor,
                          ),
                        ),
                      ),
                      if (u.bloqueado) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Bloqueado',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              trailing: u.isAdminSistema
                  ? Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield,
                          color: Colors.purple, size: 18),
                    )
                  : Switch(
                      value: !u.bloqueado,
                      onChanged: (_) => _alternarBloqueado(u),
                    ),
            ),
          );
        },
      ),
    );
  }
}