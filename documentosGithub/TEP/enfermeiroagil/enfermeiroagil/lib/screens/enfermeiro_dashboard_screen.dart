import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/usuario.dart';
import '../models/atendimento.dart';
import '../services/usuario_service.dart';
import '../services/atendimento_service.dart';
import '../services/auth_service.dart';
import 'paciente_list_screen.dart';
import 'paciente_form_screen.dart';

class EnfermeiroDashboardScreen extends StatefulWidget {
  final Usuario usuario;

  const EnfermeiroDashboardScreen({super.key, required this.usuario});

  @override
  State<EnfermeiroDashboardScreen> createState() =>
      _EnfermeiroDashboardScreenState();
}

class _EnfermeiroDashboardScreenState
    extends State<EnfermeiroDashboardScreen> {
  late final UsuarioService _usuarioService;
  late final AtendimentoService _atendimentoService;
  late final AuthService _authService;

  final _pacienteListKey = GlobalKey<PacienteListScreenState>();

  late Future<List<Atendimento>> _futureAtendimentos;
  bool _emServicoAtual = false;
  int _abaSelecionada = 0;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _usuarioService = UsuarioService(supabase);
    _atendimentoService = AtendimentoService(supabase);
    _authService = AuthService();
    _emServicoAtual = widget.usuario.emServico;
    _recarregarAtendimentos();
  }

  void _recarregarAtendimentos() {
    setState(() {
      _futureAtendimentos = _atendimentoService.listarProximosDoUsuario();
    });
  }

  Future<void> _logout() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair do aplicativo?'),
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
    if (confirmar == true) {
      await _authService.logout();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  String _labelDia(DateTime? data) {
    if (data == null) return 'Sem data';
    final hoje = DateTime.now();
    final d = DateTime(data.year, data.month, data.day);
    final h = DateTime(hoje.year, hoje.month, hoje.day);
    if (d == h) return 'Hoje';
    if (d == h.add(const Duration(days: 1))) return 'Amanhã';
    const nomesDias = [
      'Domingo', 'Segunda', 'Terça',
      'Quarta', 'Quinta', 'Sexta', 'Sábado',
    ];
    final nomeDia = nomesDias[data.weekday % 7];
    final dd = data.day.toString().padLeft(2, '0');
    final mm = data.month.toString().padLeft(2, '0');
    return '$nomeDia • $dd/$mm/${data.year}';
  }

  List<_GrupoAtendimentos> _agruparPorDia(List<Atendimento> lista) {
    final Map<String, _GrupoAtendimentos> mapa = {};
    for (final a in lista) {
      final data = a.dataPrevista;
      final chave = data != null
          ? '${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}'
          : 'sem_data';
      if (!mapa.containsKey(chave)) {
        mapa[chave] = _GrupoAtendimentos(
          data: data,
          label: _labelDia(data),
          itens: [],
        );
      }
      mapa[chave]!.itens.add(a);
    }
    final grupos = mapa.values.toList();
    grupos.sort((a, b) {
      if (a.data == null && b.data == null) return 0;
      if (a.data == null) return 1;
      if (b.data == null) return -1;
      return a.data!.compareTo(b.data!);
    });
    for (final g in grupos) {
      g.itens.sort((a, b) {
        final ha = a.horarioPrevisto ?? '';
        final hb = b.horarioPrevisto ?? '';
        return ha.compareTo(hb);
      });
    }
    return grupos;
  }

  Color _corPrioridade(String? prioridade) {
    switch (prioridade) {
      case 'alta':
        return Colors.red.shade50;
      case 'media':
        return Colors.orange.shade50;
      default:
        return Colors.green.shade50;
    }
  }

  Color _corBordaPrioridade(String? prioridade) {
    switch (prioridade) {
      case 'alta':
        return Colors.red.shade300;
      case 'media':
        return Colors.orange.shade300;
      default:
        return Colors.green.shade300;
    }
  }

  Widget _buildHeader() {
    final u = widget.usuario;
    final scheme = Theme.of(context).colorScheme;
    final hora = DateTime.now().hour;
    final saudacao = hora < 12
        ? 'Bom dia'
        : hora < 18
            ? 'Boa tarde'
            : 'Boa noite';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primary.withOpacity(0.80)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$saudacao,',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  u.nome,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Badge de status
                GestureDetector(
                  onTap: () async {
                    final novoValor = !_emServicoAtual;
                    setState(() => _emServicoAtual = novoValor);
                    try {
                      await _usuarioService.setEmServico(novoValor);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Erro ao atualizar status: $e')),
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _emServicoAtual
                          ? Colors.green.shade400
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _emServicoAtual
                              ? Icons.circle
                              : Icons.circle_outlined,
                          size: 10,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _emServicoAtual
                              ? 'Em serviço'
                              : 'Fora de serviço',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.touch_app,
                            size: 12, color: Colors.white70),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Avatar com inicial
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Text(
              u.nome.isNotEmpty ? u.nome[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Row(
            children: [
              const Text(
                'Próximos atendimentos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: _recarregarAtendimentos,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Atualizar'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Atendimento>>(
            future: _futureAtendimentos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: Colors.red.shade300),
                        const SizedBox(height: 12),
                        Text(
                          'Erro ao carregar atendimentos',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _recarregarAtendimentos,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final atendimentos = snapshot.data ?? [];

              if (atendimentos.isEmpty) {
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
                          child: Icon(
                            Icons.event_available_rounded,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Nenhum atendimento pendente',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Cadastre pacientes e atendimentos\npara organizar seu plantão.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () =>
                              setState(() => _abaSelecionada = 1),
                          icon: const Icon(Icons.people),
                          label: const Text('Ver meus pacientes'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final grupos = _agruparPorDia(atendimentos);

              return RefreshIndicator(
                onRefresh: () async => _recarregarAtendimentos(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                  itemCount: grupos.length,
                  itemBuilder: (context, indexGrupo) {
                    final g = grupos[indexGrupo];
                    final isHoje = g.label == 'Hoje';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 4, top: 12, bottom: 8),
                          child: Row(
                            children: [
                              if (isHoje)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    g.label,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  g.label,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        ...g.itens.map((a) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: _corPrioridade(a.prioridade),
                              borderRadius: BorderRadius.circular(14),
                              border: Border(
                                left: BorderSide(
                                  color: _corBordaPrioridade(
                                      a.prioridade),
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
                              title: Text(
                                a.pacienteNome ?? 'Paciente',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  if (a.tipoAtendimentoNome != null)
                                    Row(
                                      children: [
                                        Icon(Icons.medical_services,
                                            size: 12,
                                            color:
                                                Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Text(
                                          a.tipoAtendimentoNome!,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Colors.grey.shade700),
                                        ),
                                      ],
                                    ),
                                  if (a.hospitalNome != null)
                                    Row(
                                      children: [
                                        Icon(Icons.local_hospital,
                                            size: 12,
                                            color:
                                                Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Text(
                                          a.hospitalNome!,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Colors.grey.shade700),
                                        ),
                                      ],
                                    ),
                                  if (a.horarioPrevisto != null &&
                                      a.horarioPrevisto!.isNotEmpty)
                                    Row(
                                      children: [
                                        Icon(Icons.access_time,
                                            size: 12,
                                            color:
                                                Colors.grey.shade600),
                                        const SizedBox(width: 4),
                                        Text(
                                          a.horarioPrevisto!,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  Colors.grey.shade700),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () async {
                                  final messenger =
                                      ScaffoldMessenger.of(context);
                                  try {
                                    await _atendimentoService
                                        .alternarStatus(a);
                                    _recarregarAtendimentos();
                                  } catch (e) {
                                    messenger.showSnackBar(SnackBar(
                                        content: Text(
                                            'Erro ao atualizar: $e')));
                                  }
                                },
                                child: AnimatedSwitcher(
                                  duration:
                                      const Duration(milliseconds: 250),
                                  child: Icon(
                                    a.status == 'pendente'
                                        ? Icons.radio_button_unchecked
                                        : Icons.check_circle_rounded,
                                    key: ValueKey(a.status),
                                    color: a.status == 'pendente'
                                        ? Colors.grey.shade400
                                        : Colors.green,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.usuario;

    Widget? fab;
    if (_abaSelecionada == 1) {
      fab = FloatingActionButton(
        heroTag: 'fab_enfermeiro_pacientes',
        onPressed: () async {
          final criado = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => PacienteFormScreen(usuario: u),
            ),
          );
          if (criado == true) {
            _pacienteListKey.currentState?.recarregar();
            _recarregarAtendimentos();
          }
        },
        tooltip: 'Novo paciente',
        child: const Icon(Icons.person_add),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _abaSelecionada == 0
          ? null // sem AppBar no dashboard — o header customizado substitui
          : AppBar(
              title: const Text('Meus Pacientes'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Atualizar',
                  onPressed: () =>
                      _pacienteListKey.currentState?.recarregar(),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Sair',
                  onPressed: _logout,
                ),
              ],
            ),
      body: SafeArea(
        top: _abaSelecionada != 0,
        child: IndexedStack(
          index: _abaSelecionada,
          children: [
            _buildDashboard(),
            PacienteListScreen(key: _pacienteListKey, usuario: u),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _abaSelecionada,
        onDestinationSelected: (index) {
          setState(() => _abaSelecionada = index);
          if (index == 0) _recarregarAtendimentos();
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Pacientes',
          ),
        ],
      ),
      floatingActionButton: fab,
    );
  }
}

class _GrupoAtendimentos {
  final DateTime? data;
  final String label;
  final List<Atendimento> itens;

  _GrupoAtendimentos({
    required this.data,
    required this.label,
    required this.itens,
  });
}