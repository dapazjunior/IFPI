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
      final conta = await _contaService.obterConta(widget.usuario.contaId!);
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
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;

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

  Color _corFundoPrioridade(String prioridade) {
    switch (prioridade) {
      case 'alta':
        return Colors.red.shade50;
      case 'media':
        return Colors.orange.shade50;
      default:
        return Colors.green.shade50;
    }
  }

  Color _corBordaPrioridade(String prioridade) {
    switch (prioridade) {
      case 'alta':
        return Colors.red.shade400;
      case 'media':
        return Colors.orange.shade400;
      default:
        return Colors.green.shade400;
    }
  }

  Color _corAvatarPrioridade(String prioridade) {
    switch (prioridade) {
      case 'alta':
        return Colors.red;
      case 'media':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String _labelPrioridade(String prioridade) {
    switch (prioridade) {
      case 'alta':
        return 'Alta';
      case 'media':
        return 'Média';
      default:
        return 'Baixa';
    }
  }

  Widget _buildHeader() {
    final scheme = Theme.of(context).colorScheme;
    final u = widget.usuario;
    final conta = _conta;

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
                    Text(
                      conta?.nomeEquipe ?? u.nome,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gestor: ${u.nome}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                    if (conta != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: conta.planoAtivo
                              ? Colors.green.shade400
                              : Colors.red.shade400,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          conta.planoAtivo
                              ? '${_tituloPlano(conta.plano)} ativo'
                              : 'Plano suspenso',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white24,
                child: Text(
                  u.nome.isNotEmpty ? u.nome[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conta = _conta;
    final usados = _profissionais.length;
    final limite = conta?.limiteProfissionais ?? 0;

    return Scaffold(
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : conta == null
              ? const Center(
                  child: Text(
                    'Conta não encontrada.',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: IndexedStack(
                        index: _abaSelecionada,
                        children: [
                          _buildResumo(conta, usados, limite),
                          _buildEquipe(_profissionais, usados, limite),
                          _buildPacientes(_pacientes, _profissionais),
                        ],
                      ),
                    ),
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
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Equipe',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt),
            label: 'Pacientes',
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget? _buildFab() {
    if (_abaSelecionada == 1) {
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
    final ativos = _profissionais.where((p) => p.ativo).length;
    final emServico = _profissionais.where((p) => p.emServico).length;

    return RefreshIndicator(
      onRefresh: _carregarDados,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          // Cards de métricas
          Row(
            children: [
              Expanded(
                child: _metricCard(
                  icon: Icons.people,
                  cor: Colors.blue,
                  valor: '$usados/$limite',
                  label: 'Profissionais',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _metricCard(
                  icon: Icons.person_pin_circle,
                  cor: Colors.green,
                  valor: '$emServico',
                  label: 'Em serviço',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _metricCard(
                  icon: Icons.personal_injury,
                  cor: Colors.teal,
                  valor: '${_pacientes.length}',
                  label: 'Pacientes',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _metricCard(
                  icon: Icons.add_circle_outline,
                  cor: restante > 0 ? Colors.orange : Colors.red,
                  valor: '$restante',
                  label: 'Vagas livres',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Card do plano
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.star,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      _tituloPlano(conta.plano),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: conta.planoAtivo
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: conta.planoAtivo
                              ? Colors.green.shade200
                              : Colors.red.shade200,
                        ),
                      ),
                      child: Text(
                        conta.planoAtivo ? 'Ativo' : 'Suspenso',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: conta.planoAtivo
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: limite > 0 ? usados / limite : 0,
                    backgroundColor: Colors.grey.shade200,
                    color: usados >= limite
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$usados de $limite profissionais utilizados',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pagamento: ${conta.statusPagamento}',
                  style: TextStyle(
                    fontSize: 12,
                    color: conta.statusPagamento == 'ativo'
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Acesso rápido
          const Text(
            'Acesso rápido',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _atalhoCard(
                  icon: Icons.person_add,
                  label: 'Novo\nprofissional',
                  onTap: () async {
                    final criado = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GestorNovoProfissionalScreen(),
                      ),
                    );
                    if (criado == true) _carregarDados();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _atalhoCard(
                  icon: Icons.person_add_alt_1,
                  label: 'Novo\npaciente',
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PacienteFormScreen(usuario: widget.usuario),
                      ),
                    );
                    _carregarDados();
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _atalhoCard(
                  icon: Icons.logout,
                  label: 'Sair',
                  cor: Colors.red.shade400,
                  onTap: _logout,
                ),
              ),
            ],
          ),

          if (restante == 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber,
                      color: Colors.red.shade400, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Limite de profissionais atingido. Considere fazer upgrade do plano.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _metricCard({
    required IconData icon,
    required Color cor,
    required String valor,
    required String label,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                valor,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: cor,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _atalhoCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? cor,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final corFinal = cor ?? scheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: corFinal, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Aba Equipe ───────────────────────────────────────────────────────────

  Widget _buildEquipe(List<Usuario> profissionais, int usados, int limite) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Text(
                'Profissionais',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$usados / $limite',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        if (profissionais.isEmpty)
          Expanded(
            child: Center(
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
                      child: Icon(Icons.group_add,
                          size: 48, color: Colors.grey.shade400),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nenhum profissional cadastrado',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Toque no botão + para adicionar\no primeiro membro da equipe.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _carregarDados,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                itemCount: profissionais.length,
                itemBuilder: (context, index) {
                  final p = profissionais[index];
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
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: p.ativo
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade400,
                            child: Text(
                              p.nome.isNotEmpty
                                  ? p.nome[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (p.emServico)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Text(
                        p.nome,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.email,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade600),
                          ),
                          Row(
                            children: [
                              Icon(
                                p.emServico
                                    ? Icons.circle
                                    : Icons.circle_outlined,
                                size: 10,
                                color: p.emServico
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                p.emServico ? 'Em serviço' : 'Offline',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: p.emServico
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            p.ativo ? 'Ativo' : 'Inativo',
                            style: TextStyle(
                              fontSize: 12,
                              color: p.ativo
                                  ? Colors.green.shade700
                                  : Colors.red.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Switch(
                            value: p.ativo,
                            onChanged: (_) => _alternarAtivo(p),
                          ),
                        ],
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

  Widget _buildPacientes(List<Paciente> pacientes, List<Usuario> profissionais) {
    final filtrados = _aplicarFiltrosPacientes(pacientes);
    final hospitais = pacientes
        .map((p) => p.hospitalNome)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          child: DropdownButtonFormField<String?>(
            value: _filtroProfissionalId,
            decoration: const InputDecoration(
              labelText: 'Profissional responsável',
              prefixIcon: Icon(Icons.person_search),
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
        Container(
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
            child: Row(
              children: [
                _chipFiltro(
                  label: 'Todas',
                  selecionado: _filtroPrioridade == null,
                  onTap: () => setState(() => _filtroPrioridade = null),
                ),
                const SizedBox(width: 6),
                _chipFiltro(
                  label: 'Alta',
                  selecionado: _filtroPrioridade == 'alta',
                  corSelecionada: Colors.red.shade100,
                  corTexto: Colors.red.shade700,
                  onTap: () => setState(() => _filtroPrioridade =
                      _filtroPrioridade == 'alta' ? null : 'alta'),
                ),
                const SizedBox(width: 6),
                _chipFiltro(
                  label: 'Média',
                  selecionado: _filtroPrioridade == 'media',
                  corSelecionada: Colors.orange.shade100,
                  corTexto: Colors.orange.shade700,
                  onTap: () => setState(() => _filtroPrioridade =
                      _filtroPrioridade == 'media' ? null : 'media'),
                ),
                const SizedBox(width: 6),
                _chipFiltro(
                  label: 'Baixa',
                  selecionado: _filtroPrioridade == 'baixa',
                  corSelecionada: Colors.green.shade100,
                  corTexto: Colors.green.shade700,
                  onTap: () => setState(() => _filtroPrioridade =
                      _filtroPrioridade == 'baixa' ? null : 'baixa'),
                ),
                if (hospitais.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Container(
                      height: 20, width: 1, color: Colors.grey.shade300),
                  const SizedBox(width: 10),
                  ...hospitais.map((h) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _chipFiltro(
                          label: h,
                          selecionado: _filtroHospital == h,
                          onTap: () => setState(() => _filtroHospital =
                              _filtroHospital == h ? null : h),
                        ),
                      )),
                ],
              ],
            ),
          ),
        ),
        const Divider(height: 1),
        if (filtrados.isEmpty)
          Expanded(
            child: Center(
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
                    Text(
                      pacientes.isEmpty
                          ? 'Nenhum paciente cadastrado'
                          : 'Nenhum paciente com esse filtro',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      pacientes.isEmpty
                          ? 'Toque no botão + para cadastrar o primeiro paciente.'
                          : 'Tente ajustar os filtros.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: _carregarDados,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                itemCount: filtrados.length,
                itemBuilder: (context, index) {
                  final p = filtrados[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: _corFundoPrioridade(p.prioridade),
                      borderRadius: BorderRadius.circular(14),
                      border: Border(
                        left: BorderSide(
                          color: _corBordaPrioridade(p.prioridade),
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
                          horizontal: 14, vertical: 6),
                      leading: CircleAvatar(
                        backgroundColor: _corAvatarPrioridade(p.prioridade),
                        child: Text(
                          p.nome.isNotEmpty ? p.nome[0].toUpperCase() : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        p.nome,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (p.leito != null && p.leito!.isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.bed,
                                    size: 12, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  'Leito ${p.leito}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          if (p.hospitalNome != null)
                            Row(
                              children: [
                                Icon(Icons.local_hospital,
                                    size: 12, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  p.hospitalNome!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _corBordaPrioridade(p.prioridade)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _corBordaPrioridade(p.prioridade)
                                .withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          _labelPrioridade(p.prioridade),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _corAvatarPrioridade(p.prioridade),
                          ),
                        ),
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

  Widget _chipFiltro({
    required String label,
    required bool selecionado,
    Color? corSelecionada,
    Color? corTexto,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selecionado
              ? (corSelecionada ?? scheme.primaryContainer)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selecionado
                ? (corTexto ?? scheme.primary)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                selecionado ? FontWeight.w600 : FontWeight.normal,
            color: selecionado
                ? (corTexto ?? scheme.primary)
                : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}