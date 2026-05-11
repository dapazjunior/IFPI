import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/conta.dart';
import '../models/usuario.dart';
import '../models/paciente.dart';

import '../services/auth_service.dart';
import '../services/conta_service.dart';
import '../services/usuario_service.dart';
import '../services/paciente_service.dart';

import 'gestor_novo_profissional_screen.dart';
import 'paciente_form_screen.dart';
import 'paciente_detalhes_screen.dart';
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
  late final PacienteService _pacienteService;
  late final AuthService _authService;

  Conta? _conta;
  List<Usuario> _profissionais = [];
  List<Paciente> _pacientes = [];

  bool _carregando = true;
  int _abaSelecionada = 0;

  String? _filtroProfissionalId;
  String? _filtroPrioridade;
  String? _filtroHospital;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _contaService = ContaService(supabase);
    _usuarioService = UsuarioService(supabase);
    _pacienteService = PacienteService(supabase);
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

      List<Paciente> pacientes;
      if (_filtroProfissionalId == null) {
        pacientes = await _pacienteService
            .listarPacientesDaConta(widget.usuario.contaId!);
      } else {
        pacientes = await _pacienteService
            .listarPacientesDaContaPorProfissional(
          contaId: widget.usuario.contaId!,
          profissionalId: _filtroProfissionalId!,
        );
      }

      setState(() {
        _conta = conta;
        _profissionais = profissionais;
        _pacientes = pacientes;
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

  List<Paciente> _aplicarFiltrosPacientes(List<Paciente> lista) {
    return lista.where((p) {
      final passaPrioridade =
          _filtroPrioridade == null || p.prioridade == _filtroPrioridade;
      final passaHospital =
          _filtroHospital == null || p.hospitalNome == _filtroHospital;
      return passaPrioridade && passaHospital;
    }).toList();
  }

  Color _corPrioridade(String prioridade) {
    switch (prioridade) {
      case 'alta':
        return Colors.red.shade100;
      case 'media':
        return Colors.orange.shade100;
      default:
        return Colors.green.shade100;
    }
  }

  Color _corIconePrioridade(String prioridade) {
    switch (prioridade) {
      case 'alta':
        return Colors.red;
      case 'media':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  IconData _iconePrioridade(String prioridade) {
    switch (prioridade) {
      case 'alta':
        return Icons.priority_high;
      case 'media':
        return Icons.remove;
      default:
        return Icons.arrow_downward;
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
        _buildPacientes(_pacientes, _profissionais),
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
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people),
            label: 'Pacientes',
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget? _buildFab() {
    if (_abaSelecionada == 1) {
      // Equipe
      return FloatingActionButton(
        heroTag: 'fab_gestor_equipe',
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
      );
    } else if (_abaSelecionada == 2) {
      // Pacientes
      return FloatingActionButton(
        heroTag: 'fab_gestor_pacientes',
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PacienteFormScreen(usuario: widget.usuario),
            ),
          );
          _carregarDados();
        },
        tooltip: 'Novo paciente',
        child: const Icon(Icons.person_add_alt_1),
      );
    }
    return null;
  }

  // ─── Aba Resumo ───────────────────────────────────────────────────────────
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
          Card(
            child: ListTile(
              leading: const Icon(Icons.people_alt),
              title: Text('${_pacientes.length} paciente(s) na conta'),
              subtitle: const Text('Veja detalhes na aba Pacientes'),
            ),
          ),
          const SizedBox(height: 12),
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

  // ─── Aba Equipe ───────────────────────────────────────────────────────────
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

  // ─── Aba Pacientes ────────────────────────────────────────────────────────
  Widget _buildPacientes(
      List<Paciente> pacientes, List<Usuario> profissionais) {
    final filtrados = _aplicarFiltrosPacientes(pacientes);
    final hospitais = pacientes
        .map((p) => p.hospitalNome)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();

    return Column(
      children: [
        // Filtro por profissional
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: DropdownButtonFormField<String?>(
            value: _filtroProfissionalId,
            decoration: const InputDecoration(
              labelText: 'Profissional responsável',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Todos os profissionais'),
              ),
              ...profissionais.map(
                (p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.nome),
                ),
              ),
            ],
            onChanged: (valor) {
              setState(() => _filtroProfissionalId = valor);
              _carregarDados();
            },
          ),
        ),
        // Filtros de prioridade e hospital (reaproveitando lógica da lista de pacientes)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              const Text('Prioridade:',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Todas'),
                selected: _filtroPrioridade == null,
                onSelected: (_) =>
                    setState(() => _filtroPrioridade = null),
              ),
              const SizedBox(width: 4),
              ChoiceChip(
                label: const Text('Alta'),
                selected: _filtroPrioridade == 'alta',
                selectedColor: Colors.red.shade200,
                onSelected: (_) => setState(() => _filtroPrioridade =
                    _filtroPrioridade == 'alta' ? null : 'alta'),
              ),
              const SizedBox(width: 4),
              ChoiceChip(
                label: const Text('Média'),
                selected: _filtroPrioridade == 'media',
                selectedColor: Colors.orange.shade200,
                onSelected: (_) => setState(() => _filtroPrioridade =
                    _filtroPrioridade == 'media' ? null : 'media'),
              ),
              const SizedBox(width: 4),
              ChoiceChip(
                label: const Text('Baixa'),
                selected: _filtroPrioridade == 'baixa',
                selectedColor: Colors.green.shade200,
                onSelected: (_) => setState(() => _filtroPrioridade =
                    _filtroPrioridade == 'baixa' ? null : 'baixa'),
              ),
              if (hospitais.isNotEmpty) ...[
                const SizedBox(width: 16),
                const Text('Hospital:',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Todos'),
                  selected: _filtroHospital == null,
                  onSelected: (_) =>
                      setState(() => _filtroHospital = null),
                ),
                ...hospitais.map(
                  (h) => Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: ChoiceChip(
                      label: Text(h),
                      selected: _filtroHospital == h,
                      onSelected: (_) => setState(() =>
                          _filtroHospital =
                              _filtroHospital == h ? null : h),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const Divider(height: 1),
        if (filtrados.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'Nenhum paciente encontrado.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _carregarDados,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filtrados.length,
                itemBuilder: (context, index) {
                  final p = filtrados[index];
                  return Card(
                    color: _corPrioridade(p.prioridade),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            _corIconePrioridade(p.prioridade),
                        child: Text(
                          p.nome.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        p.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (p.leito != null && p.leito!.isNotEmpty)
                            Text('Leito: ${p.leito}'),
                          if (p.hospitalNome != null)
                            Text('Hospital: ${p.hospitalNome}'),
                        ],
                      ),
                      trailing: Icon(
                        _iconePrioridade(p.prioridade),
                        color: _corIconePrioridade(p.prioridade),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PacienteDetalhesScreen(
                              paciente: p,
                              usuario: widget.usuario,
                            ),
                          ),
                        );
                        _carregarDados();
                      },
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