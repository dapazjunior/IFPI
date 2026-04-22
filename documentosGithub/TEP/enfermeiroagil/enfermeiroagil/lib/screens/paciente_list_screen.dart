import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/paciente.dart';
import '../models/usuario.dart';
import '../services/paciente_service.dart';
import 'paciente_form_screen.dart';
import 'paciente_detalhes_screen.dart';

class PacienteListScreen extends StatefulWidget {
  final Usuario usuario;
  final bool mostrarFab;

  const PacienteListScreen({
    super.key,
    required this.usuario,
    this.mostrarFab = false, // quando usado como aba, o FAB fica no dashboard
  });

  @override
  State<PacienteListScreen> createState() => _PacienteListScreenState();
}

class _PacienteListScreenState extends State<PacienteListScreen> {
  late final PacienteService _pacienteService;
  late Future<List<Paciente>> _futurePacientes;

  String? _filtroPrioridade;
  String? _filtroHospital;

  @override
  void initState() {
    super.initState();
    _pacienteService = PacienteService(Supabase.instance.client);
    _recarregar();
  }

  void _recarregar() {
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

  Color _corPrioridade(String prioridade) {
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

  IconData _iconePrioridade(String prioridade) {
    switch (prioridade) {
      case 'alta':
        return Icons.priority_high;
      case 'media':
        return Icons.remove;
      case 'baixa':
      default:
        return Icons.arrow_downward;
    }
  }

  Color _corIconePrioridade(String prioridade) {
    switch (prioridade) {
      case 'alta':
        return Colors.red;
      case 'media':
        return Colors.orange;
      case 'baixa':
      default:
        return Colors.green;
    }
  }

  Widget _buildFiltros(List<Paciente> todos) {
    final hospitais = todos
        .map((p) => p.hospitalNome)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text('Prioridade:',
              style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Todas'),
            selected: _filtroPrioridade == null,
            onSelected: (_) => setState(() => _filtroPrioridade = null),
          ),
          const SizedBox(width: 4),
          ChoiceChip(
            label: const Text('Alta'),
            selected: _filtroPrioridade == 'alta',
            selectedColor: Colors.red.shade200,
            onSelected: (_) => setState(() =>
                _filtroPrioridade = _filtroPrioridade == 'alta' ? null : 'alta'),
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
              onSelected: (_) => setState(() => _filtroHospital = null),
            ),
            ...hospitais.map((h) {
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: ChoiceChip(
                  label: Text(h),
                  selected: _filtroHospital == h,
                  onSelected: (_) => setState(
                      () => _filtroHospital = _filtroHospital == h ? null : h),
                ),
              );
            }),
          ],
        ],
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
          return Center(child: Text('Erro: ${snapshot.error}'));
        }

        final todos = snapshot.data ?? [];
        final filtrados = _aplicarFiltros(todos);

        return Column(
          children: [
            _buildFiltros(todos),
            const Divider(height: 1),
            if (filtrados.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'Nenhum paciente encontrado.\nToque em + para cadastrar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
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
                          backgroundColor: _corIconePrioridade(p.prioridade),
                          child: Text(
                            p.nome.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                                usuario: usuario,
                              ),
                            ),
                          );
                          _recarregar();
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}