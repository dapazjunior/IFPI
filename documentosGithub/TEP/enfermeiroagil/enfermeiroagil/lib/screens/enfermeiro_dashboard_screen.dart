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
    _recarregar();
  }

  void _recarregar() {
    setState(() {
      _futureAtendimentos = _atendimentoService.listarProximosDoUsuario();
    });
  }

  Color _corPrioridade(String? prioridade) {
    switch (prioridade) {
      case 'alta':
        return Colors.red.shade100;
      case 'media':
        return Colors.orange.shade100;
      case 'baixa':
      default:
        return Colors.green.shade100;
    }
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
      'Quarta', 'Quinta', 'Sexta', 'Sábado'
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

  Widget _buildDashboard() {
    final u = widget.usuario;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, ${u.nome}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _emServicoAtual ? 'Em serviço' : 'Fora de serviço',
                      style: TextStyle(
                        color: _emServicoAtual ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Text('Em serviço',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Switch(
                    value: _emServicoAtual,
                    onChanged: (value) async {
                      setState(() => _emServicoAtual = value);
                      try {
                        await _usuarioService.setEmServico(value);
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao atualizar status: $e')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Próximos atendimentos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
                return Center(child: Text('Erro: ${snapshot.error}'));
              }
              final atendimentos = snapshot.data ?? [];
              if (atendimentos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.event_available,
                          size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Nenhum atendimento pendente.\n'
                        'Cadastre pacientes e atendimentos\npara organizar seu plantão.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
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
                );
              }

              final grupos = _agruparPorDia(atendimentos);

              return RefreshIndicator(
                onRefresh: () async => _recarregar(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: grupos.length,
                  itemBuilder: (context, indexGrupo) {
                    final g = grupos[indexGrupo];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, top: 8, bottom: 4),
                          child: Text(
                            g.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        ...g.itens.map((a) => Card(
                              color: _corPrioridade(a.prioridade),
                              child: ListTile(
                                title: Text(
                                  a.pacienteNome ?? 'Paciente',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    if (a.tipoAtendimentoNome != null)
                                      Text('Tipo: ${a.tipoAtendimentoNome}'),
                                    if (a.hospitalNome != null)
                                      Text('Hospital: ${a.hospitalNome}'),
                                    if (a.horarioPrevisto != null &&
                                        a.horarioPrevisto!.isNotEmpty)
                                      Text('Horário: ${a.horarioPrevisto}'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    a.status == 'pendente'
                                        ? Icons.radio_button_unchecked
                                        : Icons.check_circle,
                                    color: a.status == 'pendente'
                                        ? Colors.grey
                                        : Colors.green,
                                  ),
                                  onPressed: () async {
                                    final messenger =
                                        ScaffoldMessenger.of(context);
                                    try {
                                      await _atendimentoService
                                          .alternarStatus(a);
                                      _recarregar();
                                    } catch (e) {
                                      messenger.showSnackBar(SnackBar(
                                          content: Text(
                                              'Erro ao atualizar: $e')));
                                    }
                                  },
                                ),
                              ),
                            )),
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

    // FAB muda dependendo da aba
    final fab = FloatingActionButton(
      heroTag: 'fab_dashboard_$_abaSelecionada', // tag única por aba
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PacienteFormScreen(usuario: u),
          ),
        );
        _recarregar();
      },
      tooltip: 'Novo paciente',
      child: const Icon(Icons.person_add),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enfermeiro Ágil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: _recarregar,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      body: IndexedStack(
        index: _abaSelecionada,
        children: [
          _buildDashboard(),
          PacienteListScreen(usuario: u),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _abaSelecionada,
        onDestinationSelected: (index) {
          setState(() => _abaSelecionada = index);
          if (index == 0) _recarregar();
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