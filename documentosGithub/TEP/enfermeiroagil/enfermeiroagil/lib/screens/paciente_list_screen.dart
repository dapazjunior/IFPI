import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/paciente.dart';
import '../models/usuario.dart';
import '../services/paciente_service.dart';
import 'paciente_detalhes_screen.dart';

class PacienteListScreen extends StatefulWidget {
  final Usuario usuario;
  final bool mostrarFab;

  const PacienteListScreen({
    super.key,
    required this.usuario,
    this.mostrarFab = false,
  });

  @override
  PacienteListScreenState createState() => PacienteListScreenState();
}

class PacienteListScreenState extends State<PacienteListScreen> {
  late final PacienteService _pacienteService;
  late Future<List<Paciente>> _futurePacientes;

  String? _filtroPrioridade;
  String? _filtroHospital;

  @override
  void initState() {
    super.initState();
    _pacienteService = PacienteService(Supabase.instance.client);
    recarregar();
  }

  void recarregar() {
    setState(() {
      _futurePacientes = _pacienteService.listarPacientesDoUsuario();
    });
  }

  List<Paciente> _aplicarFiltros(List<Paciente> lista) {
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

  Widget _buildFiltros(List<Paciente> todos) {
    final hospitais = todos
        .map((p) => p.hospitalNome)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              const SizedBox(width: 12),
              Container(
                  height: 20,
                  width: 1,
                  color: Colors.grey.shade300),
              const SizedBox(width: 12),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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

  @override
  Widget build(BuildContext context) {
    final usuario = widget.usuario;

    return FutureBuilder<List<Paciente>>(
      future: _futurePacientes,
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
                    'Erro ao carregar pacientes',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: recarregar,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        final todos = snapshot.data ?? [];
        final filtrados = _aplicarFiltros(todos);

        return Column(
          children: [
            _buildFiltros(todos),
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
                          child: Icon(
                            Icons.people_outline,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          todos.isEmpty
                              ? 'Nenhum paciente cadastrado'
                              : 'Nenhum paciente com esse filtro',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          todos.isEmpty
                              ? 'Toque no botão + para cadastrar\nseu primeiro paciente.'
                              : 'Tente ajustar ou limpar os filtros.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        if (todos.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => setState(() {
                              _filtroPrioridade = null;
                              _filtroHospital = null;
                            }),
                            child: const Text('Limpar filtros'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => recarregar(),
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
                            backgroundColor:
                                _corAvatarPrioridade(p.prioridade),
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
                          title: Text(
                            p.nome,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (p.leito != null && p.leito!.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(Icons.bed,
                                        size: 12,
                                        color: Colors.grey.shade600),
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
                                        size: 12,
                                        color: Colors.grey.shade600),
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
                                  usuario: usuario,
                                ),
                              ),
                            );
                            recarregar();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}