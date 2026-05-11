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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin – ${widget.usuario.nome}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarDados,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _abaSelecionada,
              children: [
                _buildResumo(),
                _buildContas(),
                _buildUsuarios(),
              ],
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _abaSelecionada,
        onDestinationSelected: (i) => setState(() => _abaSelecionada = i),
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
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Visão geral do sistema',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _cardResumo(
                  icon: Icons.business,
                  cor: Colors.teal,
                  titulo: 'Contas',
                  valor: '$totalContas',
                  subtitulo: '$contasAtivas ativas',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _cardResumo(
                  icon: Icons.people,
                  cor: Colors.blue,
                  titulo: 'Usuários',
                  valor: '$totalUsuarios',
                  subtitulo: '$bloqueados bloqueados',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _cardResumo(
                  icon: Icons.manage_accounts,
                  cor: Colors.purple,
                  titulo: 'Gestores',
                  valor: '$gestores',
                  subtitulo: 'no sistema',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _cardResumo(
                  icon: Icons.badge,
                  cor: Colors.orange,
                  titulo: 'Profissionais',
                  valor: '$profissionais',
                  subtitulo: 'cadastrados',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Contas com plano desativado',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (contasInativas.isEmpty)
            const Text(
              'Todas as contas estão ativas.',
              style: TextStyle(color: Colors.green),
            )
          else
            ...contasInativas.map(
              (c) => Card(
                color: Colors.red.shade50,
                child: ListTile(
                  leading:
                      const Icon(Icons.warning, color: Colors.red),
                  title:
                      Text(c.nomeEquipe ?? c.tipoConta.toUpperCase()),
                  subtitle: Text('Pagamento: ${c.statusPagamento}'),
                  trailing: TextButton(
                    onPressed: () => _alternarPlanoAtivo(c),
                    child: const Text('Reativar'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cardResumo({
    required IconData icon,
    required Color cor,
    required String titulo,
    required String valor,
    required String subtitulo,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: cor, size: 32),
            const SizedBox(height: 8),
            Text(
              valor,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              subtitulo,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Aba Contas ───────────────────────────────────────────────────────────
  Widget _buildContas() {
    if (_contas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma conta cadastrada.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarDados,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _contas.length,
        itemBuilder: (context, index) {
          final c = _contas[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    c.planoAtivo ? Colors.teal : Colors.red.shade300,
                child: Icon(
                  c.tipoConta == 'gestor'
                      ? Icons.groups
                      : Icons.person,
                  color: Colors.white,
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
                    'Plano: ${c.plano} • Limite: ${c.limiteProfissionais}',
                  ),
                  Text(
                    'Pagamento: ${c.statusPagamento}',
                    style: TextStyle(
                      fontSize: 12,
                      color: c.statusPagamento == 'ativo'
                          ? Colors.green
                          : Colors.orange,
                    ),
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
      return const Center(
        child: Text(
          'Nenhum usuário encontrado.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarDados,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _usuarios.length,
        itemBuilder: (context, index) {
          final u = _usuarios[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: u.isAdminSistema
                    ? Colors.purple
                    : u.isGestor
                        ? Colors.blue
                        : Colors.teal,
                child: Text(
                  u.nome.isNotEmpty ? u.nome[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(u.nome),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(u.email),
                  Text(
                    _labelTipoUsuario(u.tipoUsuario),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: u.isAdminSistema
                          ? Colors.purple
                          : u.isGestor
                              ? Colors.blue
                              : Colors.teal,
                    ),
                  ),
                  if (u.bloqueado)
                    const Text(
                      'Bloqueado',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                ],
              ),
              trailing: u.isAdminSistema
                  ? const Icon(Icons.shield, color: Colors.purple)
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