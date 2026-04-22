import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/conta.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/conta_service.dart';
import '../services/usuario_service.dart';
import 'gestor_novo_profissional_screen.dart';
import 'login_screen.dart';

class GestorDashboardScreen extends StatefulWidget {
  final Usuario usuario;

  const GestorDashboardScreen({super.key, required this.usuario});

  @override
  State<GestorDashboardScreen> createState() => _GestorDashboardScreenState();
}

class _GestorDashboardScreenState extends State<GestorDashboardScreen> {
  late final ContaService _contaService;
  late final UsuarioService _usuarioService;
  late final AuthService _authService;

  Conta? _conta;
  List<Usuario> _profissionais = [];
  bool _carregando = true;
  int _abaSelecionada = 0;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _contaService = ContaService(supabase);
    _usuarioService = UsuarioService(supabase);
    _authService = AuthService();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    if (widget.usuario.contaId == null) return;
    setState(() => _carregando = true);
    try {
      final conta =
          await _contaService.obterConta(widget.usuario.contaId!);
      final profissionais = await _usuarioService
          .listarProfissionaisDaConta(widget.usuario.contaId!);
      setState(() {
        _conta = conta;
        _profissionais = profissionais;
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

  Future<void> _alternarAtivo(Usuario prof) async {
    try {
      await _usuarioService.setAtivo(prof.id, !prof.ativo);
      await _carregarDados();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar profissional: $e')),
      );
    }
  }

  String _tituloPlano(String plano) {
    switch (plano) {
      case 'homecare':
        return 'Plano Homecare';
      case 'equipe':
        return 'Plano Equipe';
      default:
        return 'Plano Individual';
    }
  }

  @override
  Widget build(BuildContext context) {
    final conta = _conta;
    final usados = _profissionais.length;
    final limite = conta?.limiteProfissionais ?? 0;

    Widget body;

    if (_carregando) {
      body = const Center(child: CircularProgressIndicator());
    } else if (conta == null) {
      body = const Center(
        child: Text(
          'Conta não encontrada.',
          style: TextStyle(color: Colors.red),
        ),
      );
    } else {
      final telas = [
        _buildResumo(conta, usados, limite),
        _buildEquipe(_profissionais, usados, limite),
      ];
      body = telas[_abaSelecionada];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestor – ${widget.usuario.nome}'),
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
      body: body,
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
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Equipe',
          ),
        ],
      ),
      floatingActionButton: _abaSelecionada == 1
          ? FloatingActionButton(
              heroTag: 'fab_gestor',
              onPressed: () async {
                final criado = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GestorNovoProfissionalScreen(),
                  ),
                );
                if (criado == true) _carregarDados();
              },
              tooltip: 'Adicionar profissional',
              child: const Icon(Icons.person_add),
            )
          : null,
    );
  }

  Widget _buildResumo(Conta conta, int usados, int limite) {
    final restante = (limite - usados).clamp(0, limite);

    return RefreshIndicator(
      onRefresh: _carregarDados,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.business_center),
              title: Text(conta.nomeEquipe ?? 'Minha conta'),
              subtitle: Text('Tipo: ${conta.tipoConta.toUpperCase()}'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.star_border),
              title: Text(_tituloPlano(conta.plano)),
              subtitle:
                  Text('Profissionais: $usados de $limite usados'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(
                conta.planoAtivo ? Icons.check_circle : Icons.cancel,
                color: conta.planoAtivo ? Colors.green : Colors.red,
              ),
              title: Text(
                conta.planoAtivo ? 'Plano ativo' : 'Plano desativado',
              ),
              subtitle: Text(
                  'Status de pagamento: ${conta.statusPagamento}'),
            ),
          ),
          const SizedBox(height: 24),
          restante > 0
              ? Text(
                  'Você ainda pode adicionar $restante profissional(is).',
                  style: const TextStyle(color: Colors.green),
                )
              : const Text(
                  'Limite atingido. Considere fazer upgrade do plano.',
                  style: TextStyle(color: Colors.red),
                ),
        ],
      ),
    );
  }

  Widget _buildEquipe(
      List<Usuario> profissionais, int usados, int limite) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Text(
                'Profissionais ($usados / $limite)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        if (profissionais.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'Nenhum profissional cadastrado.\nUse o botão + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _carregarDados,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: profissionais.length,
                itemBuilder: (context, index) {
                  final p = profissionais[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          p.nome.isNotEmpty
                              ? p.nome[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(p.nome),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.email),
                          Text(
                            p.ativo ? 'Ativo' : 'Desativado',
                            style: TextStyle(
                              color:
                                  p.ativo ? Colors.green : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: Switch(
                        value: p.ativo,
                        onChanged: (_) => _alternarAtivo(p),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}