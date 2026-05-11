import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/paciente.dart';
import '../models/usuario.dart';
import '../models/atendimento.dart';
import '../models/tipo_atendimento.dart';
import '../models/hospital.dart';
import '../services/atendimento_service.dart';
import '../services/tipo_atendimento_service.dart';
import '../services/usuario_service.dart';
import '../services/paciente_service.dart';
import '../services/hospital_service.dart';

class PacienteDetalhesScreen extends StatefulWidget {
  final Paciente paciente;
  final Usuario usuario;

  const PacienteDetalhesScreen({
    super.key,
    required this.paciente,
    required this.usuario,
  });

  @override
  State<PacienteDetalhesScreen> createState() =>
      _PacienteDetalhesScreenState();
}

class _PacienteDetalhesScreenState extends State<PacienteDetalhesScreen> {
  late final AtendimentoService _atendimentoService;
  late final TipoAtendimentoService _tipoService;
  late final UsuarioService _usuarioService;
  late final PacienteService _pacienteService;
  late final HospitalService _hospitalService;

  // Paciente pode ser atualizado após edição
  late Paciente _paciente;

  List<Atendimento> _todos = [];
  bool _carregando = true;
  bool _mostrarHistorico = false;

  @override
  void initState() {
    super.initState();
    _paciente = widget.paciente;
    final supabase = Supabase.instance.client;
    _atendimentoService = AtendimentoService(supabase);
    _tipoService = TipoAtendimentoService(supabase);
    _usuarioService = UsuarioService(supabase);
    _pacienteService = PacienteService(supabase);
    _hospitalService = HospitalService(supabase);
    _recarregar();
  }

  Future<void> _recarregar() async {
    setState(() => _carregando = true);
    try {
      final lista =
          await _atendimentoService.listarPorPaciente(_paciente.id);
      setState(() {
        _todos = lista;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar atendimentos: $e')),
      );
    }
  }

  // ─── Editar paciente ──────────────────────────────────────────────────────

  Future<void> _abrirFormEdicao() async {
    // Carrega hospitais disponíveis
    List<Hospital> hospitais = [];
    try {
      hospitais = await _hospitalService.listarHospitais();
    } catch (_) {}

    final nomeCtrl = TextEditingController(text: _paciente.nome);
    final leitoCtrl = TextEditingController(text: _paciente.leito ?? '');
    final obsCtrl = TextEditingController(text: _paciente.observacoes ?? '');
    String prioridade = _paciente.prioridade;

    // Tenta encontrar o hospital atual na lista
    Hospital? hospitalSelecionado;
    if (_paciente.hospitalId != null) {
      try {
        hospitalSelecionado = hospitais.firstWhere(
          (h) => h.id == _paciente.hospitalId,
        );
      } catch (_) {}
    }

    final formKey = GlobalKey<FormState>();

    final salvo = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Editar paciente'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nomeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nome *',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: leitoCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Leito (opcional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Prioridade',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'alta',
                        label: Text('Alta'),
                        icon: Icon(Icons.priority_high, color: Colors.red),
                      ),
                      ButtonSegment(
                        value: 'media',
                        label: Text('Média'),
                        icon: Icon(Icons.remove, color: Colors.orange),
                      ),
                      ButtonSegment(
                        value: 'baixa',
                        label: Text('Baixa'),
                        icon: Icon(Icons.arrow_downward, color: Colors.green),
                      ),
                    ],
                    selected: {prioridade},
                    onSelectionChanged: (s) =>
                        setStateDialog(() => prioridade = s.first),
                  ),
                  const SizedBox(height: 12),
                  const Text('Hospital',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Hospital>(
                    value: hospitalSelecionado,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    hint: const Text('Selecione o hospital'),
                    items: hospitais
                        .map((h) => DropdownMenuItem(
                              value: h,
                              child: Text(h.nome),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setStateDialog(() => hospitalSelecionado = value),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: obsCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Observações (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                try {
                  final pacienteAtualizado =
                      await _pacienteService.editarPaciente(
                    id: _paciente.id,
                    nome: nomeCtrl.text.trim(),
                    leito: leitoCtrl.text.trim().isEmpty
                        ? null
                        : leitoCtrl.text.trim(),
                    prioridade: prioridade,
                    hospitalId: hospitalSelecionado?.id,
                    observacoes: obsCtrl.text.trim().isEmpty
                        ? null
                        : obsCtrl.text.trim(),
                  );
                  if (ctx.mounted) Navigator.pop(ctx, true);
                  setState(() => _paciente = pacienteAtualizado);
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text('Erro ao salvar: $e')),
                    );
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );

    if (salvo == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paciente atualizado com sucesso!')),
      );
    }
  }

  // ─── Deletar paciente ─────────────────────────────────────────────────────

  Future<void> _confirmarDelecao() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remover paciente'),
        content: Text(
          'Tem certeza que deseja remover "${_paciente.nome}"?\n\n'
          'Todos os atendimentos vinculados também serão removidos. '
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await _pacienteService.deletarPaciente(_paciente.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paciente removido.')),
      );
      Navigator.pop(context, true); // Volta para a lista sinalizando mudança
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao remover paciente: $e')),
      );
    }
  }

  // ─── Compartilhar paciente ────────────────────────────────────────────────

  Future<void> _compartilharPaciente() async {
  if (widget.usuario.contaId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuário sem conta associada.')),
    );
    return;
  }

  try {
    final profissionais = await _usuarioService
        .listarProfissionaisDaConta(widget.usuario.contaId!);

    final outros = profissionais
        .where((p) => p.id != widget.usuario.id)
        .toList();

    if (outros.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não há outros profissionais na sua equipe para compartilhar.',
          ),
        ),
      );
      return;
    }

    Usuario? selecionado;
    bool compartilharComTodos = false;

    final resultado = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Compartilhar paciente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.usuario.isGestor) ...[
                CheckboxListTile(
                  value: compartilharComTodos,
                  onChanged: (v) =>
                      setStateDialog(() => compartilharComTodos = v ?? false),
                  title: const Text('Compartilhar com toda a equipe'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(),
              ],
              if (!compartilharComTodos) ...[
                const Text(
                  'Selecione o profissional que poderá ver este paciente:',
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Usuario>(
                  decoration: const InputDecoration(
                    labelText: 'Profissional',
                    border: OutlineInputBorder(),
                  ),
                  items: outros
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.nome),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setStateDialog(() => selecionado = value),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!compartilharComTodos && selecionado == null) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                        content: Text('Selecione um profissional')),
                  );
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: const Text('Compartilhar'),
            ),
          ],
        ),
      ),
    );

    if (resultado == true) {
      if (compartilharComTodos) {
        await _pacienteService.compartilharComTodaEquipe(
          pacienteId: _paciente.id,
          contaId: widget.usuario.contaId!,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paciente compartilhado com toda a equipe.'),
          ),
        );
      } else if (selecionado != null) {
        await _pacienteService.compartilharPacienteComEnfermeiro(
          pacienteId: _paciente.id,
          enfermeiroId: selecionado!.id,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Paciente compartilhado com ${selecionado!.nome}.'),
          ),
        );
      }
    }
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao compartilhar paciente: $e')),
    );
  }
}

  // ─── Status de atendimento ────────────────────────────────────────────────

  Future<void> _alternarStatus(Atendimento a) async {
    setState(() {
      final index = _todos.indexWhere((x) => x.id == a.id);
      if (index != -1) {
        _todos[index] = _TodosAtendimentosHelper.comStatus(
          _todos[index],
          a.status == 'pendente' ? 'concluido' : 'pendente',
        );
      }
    });

    try {
      await _atendimentoService.alternarStatus(a);
      await _recarregar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar status: $e')),
      );
      await _recarregar();
    }
  }

  // ─── Form de atendimento ──────────────────────────────────────────────────

  Future<void> _abrirFormAtendimento({Atendimento? existente}) async {
    final tipos = await _tipoService.listarTiposDisponiveis();

    TipoAtendimento? tipoSelecionado;
    final descCtrl = TextEditingController();
    final horarioCtrl = TextEditingController();
    DateTime? dataSelecionada;
    bool recorrente = false;
    List<int> diasSelecionados = [];
    DateTime? recorrenciaFim;

    const nomesDias = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

    if (existente != null) {
      tipoSelecionado = existente.tipoAtendimentoId != null
          ? tipos.firstWhere(
              (t) => t.id == existente.tipoAtendimentoId,
              orElse: () => tipos.first,
            )
          : null;
      descCtrl.text = existente.descricao ?? '';
      horarioCtrl.text = existente.horarioPrevisto ?? '';
      dataSelecionada = existente.dataPrevista;
      recorrente = existente.recorrente;
      diasSelecionados = List.from(existente.recorrenciaDias ?? []);
      recorrenciaFim = existente.recorrenciaFim;
    }

    final resultado = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text(existente == null
              ? 'Novo atendimento'
              : 'Editar atendimento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<TipoAtendimento>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de atendimento',
                    border: OutlineInputBorder(),
                  ),
                  value: tipoSelecionado,
                  items: tipos
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.nome),
                          ))
                      .toList(),
                  onChanged: (value) => tipoSelecionado = value,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Descrição (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                const Text('Data prevista',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(dataSelecionada == null
                      ? 'Selecionar data'
                      : '${dataSelecionada!.day.toString().padLeft(2, '0')}/'
                          '${dataSelecionada!.month.toString().padLeft(2, '0')}/'
                          '${dataSelecionada!.year}'),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: dataSelecionada ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now()
                          .add(const Duration(days: 365 * 2)),
                    );
                    if (picked != null) {
                      setStateDialog(() => dataSelecionada = picked);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: horarioCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Horário previsto (ex: 08:00)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: ctx,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      horarioCtrl.text =
                          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                    }
                  },
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Recorrente?',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    Switch(
                      value: recorrente,
                      onChanged: (v) =>
                          setStateDialog(() => recorrente = v),
                    ),
                  ],
                ),
                if (recorrente) ...[
                  const SizedBox(height: 8),
                  const Text('Dias da semana',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: List.generate(7, (i) {
                      final selecionado = diasSelecionados.contains(i);
                      return FilterChip(
                        label: Text(nomesDias[i]),
                        selected: selecionado,
                        onSelected: (v) {
                          setStateDialog(() {
                            if (v) {
                              diasSelecionados.add(i);
                              diasSelecionados.sort();
                            } else {
                              diasSelecionados.remove(i);
                            }
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  const Text('Repetir até',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.event_busy),
                    label: Text(recorrenciaFim == null
                        ? 'Sem data de fim'
                        : '${recorrenciaFim!.day.toString().padLeft(2, '0')}/'
                            '${recorrenciaFim!.month.toString().padLeft(2, '0')}/'
                            '${recorrenciaFim!.year}'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: recorrenciaFim ??
                            DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now()
                            .add(const Duration(days: 365 * 2)),
                      );
                      if (picked != null) {
                        setStateDialog(() => recorrenciaFim = picked);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'cancel'),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (existente == null) {
                    await _atendimentoService.criarAtendimento(
                      pacienteId: _paciente.id,
                      tipoAtendimentoId: tipoSelecionado?.id,
                      descricao: descCtrl.text.trim().isEmpty
                          ? null
                          : descCtrl.text.trim(),
                      dataPrevista: dataSelecionada,
                      horarioPrevisto: horarioCtrl.text.trim().isEmpty
                          ? null
                          : horarioCtrl.text.trim(),
                      recorrente: recorrente,
                      recorrenciaDias:
                          recorrente && diasSelecionados.isNotEmpty
                              ? diasSelecionados
                              : null,
                      recorrenciaFim: recorrente ? recorrenciaFim : null,
                    );
                  } else {
                    await _atendimentoService.atualizarAtendimento(
                      id: existente.id,
                      tipoAtendimentoId: tipoSelecionado?.id,
                      descricao: descCtrl.text.trim().isEmpty
                          ? null
                          : descCtrl.text.trim(),
                      dataPrevista: dataSelecionada,
                      horarioPrevisto: horarioCtrl.text.trim().isEmpty
                          ? null
                          : horarioCtrl.text.trim(),
                      recorrente: recorrente,
                      recorrenciaDias:
                          recorrente && diasSelecionados.isNotEmpty
                              ? diasSelecionados
                              : null,
                      recorrenciaFim: recorrente ? recorrenciaFim : null,
                    );
                  }
                  if (ctx.mounted) Navigator.pop(ctx, 'save');
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                          content: Text('Erro ao salvar atendimento: $e')),
                    );
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );

    if (resultado == 'save') {
      await _recarregar();
    }
  }

  // ─── Helpers visuais ──────────────────────────────────────────────────────

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

  String _formatarData(DateTime? data) {
    if (data == null) return '';
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  Widget _buildCardAtendimento(Atendimento a) {
    final concluido = a.status == 'concluido';

    return Card(
      color: concluido ? Colors.grey.shade100 : null,
      child: ListTile(
        leading: GestureDetector(
          onTap: () => _alternarStatus(a),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Icon(
              concluido
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              key: ValueKey(concluido),
              color: concluido ? Colors.green : Colors.grey,
              size: 28,
            ),
          ),
        ),
        title: Text(
          a.tipoAtendimentoNome ?? 'Atendimento',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration:
                concluido ? TextDecoration.lineThrough : null,
            color: concluido ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (a.descricao != null && a.descricao!.isNotEmpty)
              Text(a.descricao!,
                  style:
                      TextStyle(color: concluido ? Colors.grey : null)),
            if (a.dataPrevista != null)
              Text('Data: ${_formatarData(a.dataPrevista)}'),
            if (a.horarioPrevisto != null &&
                a.horarioPrevisto!.isNotEmpty)
              Text('Horário: ${a.horarioPrevisto}'),
            if (a.recorrente)
              Row(
                children: [
                  const Icon(Icons.repeat,
                      size: 14, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    a.recorrenciaDiasLabel.isNotEmpty
                        ? a.recorrenciaDiasLabel
                        : 'Recorrente',
                    style: const TextStyle(
                        color: Colors.blue, fontSize: 12),
                  ),
                ],
              ),
          ],
        ),
        trailing: concluido
            ? const Icon(Icons.check_circle,
                color: Colors.green, size: 20)
            : IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () => _abrirFormAtendimento(existente: a),
              ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final p = _paciente;
    final pendentes =
        _todos.where((a) => a.status == 'pendente').toList();
    final concluidos =
        _todos.where((a) => a.status == 'concluido').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(p.nome),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt),
            tooltip: 'Compartilhar paciente',
            onPressed: _compartilharPaciente,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'editar') _abrirFormEdicao();
              if (value == 'deletar') _confirmarDelecao();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'editar',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(width: 8),
                    Text('Editar paciente'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'deletar',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Remover paciente',
                        style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _recarregar,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Card(
                    color: _corPrioridade(p.prioridade),
                    child: ListTile(
                      title: Text(p.nome,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (p.leito != null && p.leito!.isNotEmpty)
                            Text('Leito: ${p.leito}'),
                          if (p.hospitalNome != null)
                            Text('Hospital: ${p.hospitalNome}'),
                          Text(
                              'Prioridade: ${p.prioridade.toUpperCase()}'),
                          if (p.observacoes != null &&
                              p.observacoes!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text('Obs: ${p.observacoes}'),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Pendentes',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Badge(
                        label: Text('${pendentes.length}'),
                        backgroundColor: Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (pendentes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'Nenhum atendimento pendente.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...pendentes.map(_buildCardAtendimento),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => setState(
                        () => _mostrarHistorico = !_mostrarHistorico),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          const Text(
                            'Histórico',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Badge(
                            label: Text('${concluidos.length}'),
                            backgroundColor: Colors.green,
                          ),
                          const Spacer(),
                          Icon(
                            _mostrarHistorico
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (_mostrarHistorico)
                    if (concluidos.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'Nenhum atendimento concluído ainda.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ...concluidos.map(_buildCardAtendimento),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormAtendimento(),
        tooltip: 'Novo atendimento',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TodosAtendimentosHelper {
  static Atendimento comStatus(Atendimento a, String novoStatus) {
    return Atendimento(
      id: a.id,
      pacienteId: a.pacienteId,
      tipoAtendimentoId: a.tipoAtendimentoId,
      descricao: a.descricao,
      horarioPrevisto: a.horarioPrevisto,
      dataPrevista: a.dataPrevista,
      recorrente: a.recorrente,
      recorrenciaDias: a.recorrenciaDias,
      recorrenciaFim: a.recorrenciaFim,
      status: novoStatus,
      criadoPor: a.criadoPor,
      criadoEm: a.criadoEm,
      pacienteNome: a.pacienteNome,
      hospitalNome: a.hospitalNome,
      tipoAtendimentoNome: a.tipoAtendimentoNome,
      prioridade: a.prioridade,
    );
  }
}