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

  Color _corPrioridade(String prioridade) {
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
        return 'Prioridade Alta';
      case 'media':
        return 'Prioridade Média';
      default:
        return 'Prioridade Baixa';
    }
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '';
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  // ─── Editar paciente ──────────────────────────────────────────────────────

  Future<void> _abrirFormEdicao() async {
    List<Hospital> hospitais = [];
    try {
      hospitais = await _hospitalService.listarHospitais();
    } catch (_) {}

    final nomeCtrl = TextEditingController(text: _paciente.nome);
    final leitoCtrl = TextEditingController(text: _paciente.leito ?? '');
    final obsCtrl = TextEditingController(text: _paciente.observacoes ?? '');
    String prioridade = _paciente.prioridade;

    Hospital? hospitalSelecionado;
    if (_paciente.hospitalId != null) {
      try {
        hospitalSelecionado = hospitais.firstWhere(
          (h) => h.id == _paciente.hospitalId,
        );
      } catch (_) {}
    }

    final formKey = GlobalKey<FormState>();

    await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Editar paciente'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nomeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nome *',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Informe o nome'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: leitoCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Leito (opcional)',
                      prefixIcon: Icon(Icons.bed_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Prioridade',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _chipPrioridade(
                        ctx: ctx,
                        label: 'Alta',
                        value: 'alta',
                        atual: prioridade,
                        cor: Colors.red,
                        onTap: () =>
                            setStateDialog(() => prioridade = 'alta'),
                      ),
                      const SizedBox(width: 6),
                      _chipPrioridade(
                        ctx: ctx,
                        label: 'Média',
                        value: 'media',
                        atual: prioridade,
                        cor: Colors.orange,
                        onTap: () =>
                            setStateDialog(() => prioridade = 'media'),
                      ),
                      const SizedBox(width: 6),
                      _chipPrioridade(
                        ctx: ctx,
                        label: 'Baixa',
                        value: 'baixa',
                        atual: prioridade,
                        cor: Colors.green,
                        onTap: () =>
                            setStateDialog(() => prioridade = 'baixa'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Hospital>(
                    value: hospitalSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Hospital',
                      prefixIcon: Icon(Icons.local_hospital_outlined),
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
                      prefixIcon: Icon(Icons.notes_outlined),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
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
                  setState(() => _paciente = pacienteAtualizado);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Paciente atualizado com sucesso!')),
                  );
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
  }

  Widget _chipPrioridade({
    required BuildContext ctx,
    required String label,
    required String value,
    required String atual,
    required Color cor,
    required VoidCallback onTap,
  }) {
    final selecionado = atual == value;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selecionado ? cor.withOpacity(0.15) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selecionado ? cor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: selecionado ? cor : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
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
      Navigator.pop(context, true);
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

      final outros =
          profissionais.where((p) => p.id != widget.usuario.id).toList();

      if (outros.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Não há outros profissionais na sua equipe para compartilhar.'),
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
              children: [
                if (widget.usuario.isGestor) ...[
                  CheckboxListTile(
                    value: compartilharComTodos,
                    onChanged: (v) => setStateDialog(
                        () => compartilharComTodos = v ?? false),
                    title: const Text('Compartilhar com toda a equipe'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(),
                ],
                if (!compartilharComTodos) ...[
                  const Text(
                      'Selecione o profissional que poderá ver este paciente:'),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Usuario>(
                    decoration: const InputDecoration(
                      labelText: 'Profissional',
                      prefixIcon: Icon(Icons.person_outline),
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
                content:
                    Text('Paciente compartilhado com toda a equipe.')),
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
                    'Paciente compartilhado com ${selecionado!.nome}.')),
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
        _todos[index] = _AtendimentoHelper.comStatus(
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
          title: Text(
            existente == null ? 'Novo atendimento' : 'Editar atendimento',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<TipoAtendimento>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de atendimento',
                    prefixIcon: Icon(Icons.medical_services_outlined),
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
                    prefixIcon: Icon(Icons.notes_outlined),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Text(
                  'Data e horário',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(
                          dataSelecionada == null
                              ? 'Selecionar data'
                              : _formatarData(dataSelecionada),
                          style: const TextStyle(fontSize: 13),
                        ),
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
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.access_time, size: 16),
                        label: Text(
                          horarioCtrl.text.isEmpty
                              ? 'Horário'
                              : horarioCtrl.text,
                          style: const TextStyle(fontSize: 13),
                        ),
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: ctx,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setStateDialog(() {
                              horarioCtrl.text =
                                  '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Recorrente?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: recorrente,
                      onChanged: (v) =>
                          setStateDialog(() => recorrente = v),
                    ),
                  ],
                ),
                if (recorrente) ...[
                  const Text(
                    'Dias da semana',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: List.generate(7, (i) {
                      final sel = diasSelecionados.contains(i);
                      return FilterChip(
                        label: Text(nomesDias[i]),
                        selected: sel,
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
                  OutlinedButton.icon(
                    icon: const Icon(Icons.event_busy, size: 16),
                    label: Text(
                      recorrenciaFim == null
                          ? 'Sem data de fim'
                          : 'Até ${_formatarData(recorrenciaFim)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: recorrenciaFim ??
                            DateTime.now()
                                .add(const Duration(days: 30)),
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
                          content:
                              Text('Erro ao salvar atendimento: $e')),
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

    if (resultado == 'save') await _recarregar();
  }

  // ─── Card de atendimento ──────────────────────────────────────────────────

  Widget _buildCardAtendimento(Atendimento a) {
    final concluido = a.status == 'concluido';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: concluido ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: concluido ? Colors.grey.shade300 : Colors.teal,
            width: 3,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: GestureDetector(
          onTap: () => _alternarStatus(a),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Icon(
              concluido
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked,
              key: ValueKey(concluido),
              color: concluido ? Colors.green : Colors.grey.shade400,
              size: 28,
            ),
          ),
        ),
        title: Text(
          a.tipoAtendimentoNome ?? 'Atendimento',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            decoration: concluido ? TextDecoration.lineThrough : null,
            color: concluido ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (a.descricao != null && a.descricao!.isNotEmpty)
              Text(
                a.descricao!,
                style: TextStyle(
                    color: concluido ? Colors.grey : Colors.black54,
                    fontSize: 12),
              ),
            if (a.dataPrevista != null)
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 11, color: Colors.grey.shade500),
                  const SizedBox(width: 3),
                  Text(
                    _formatarData(a.dataPrevista),
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade600),
                  ),
                  if (a.horarioPrevisto != null &&
                      a.horarioPrevisto!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.access_time,
                        size: 11, color: Colors.grey.shade500),
                    const SizedBox(width: 3),
                    Text(
                      a.horarioPrevisto!,
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ],
              ),
            if (a.recorrente)
              Row(
                children: [
                  Icon(Icons.repeat, size: 11, color: Colors.blue.shade300),
                  const SizedBox(width: 3),
                  Text(
                    a.recorrenciaDiasLabel.isNotEmpty
                        ? a.recorrenciaDiasLabel
                        : 'Recorrente',
                    style: TextStyle(
                        color: Colors.blue.shade400, fontSize: 11),
                  ),
                ],
              ),
          ],
        ),
        trailing: concluido
            ? null
            : IconButton(
                icon: Icon(Icons.edit_outlined,
                    size: 18, color: Colors.grey.shade500),
                onPressed: () => _abrirFormAtendimento(existente: a),
              ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final p = _paciente;
    final scheme = Theme.of(context).colorScheme;
    final corPrioridade = _corPrioridade(p.prioridade);
    final pendentes = _todos.where((a) => a.status == 'pendente').toList();
    final concluidos =
        _todos.where((a) => a.status == 'concluido').toList();

    return Scaffold(
      body: Column(
        children: [
          // Header com gradiente e informações do paciente
          Container(
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
              child: Column(
                children: [
                  // Barra de ações
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.person_add_alt,
                              color: Colors.white),
                          tooltip: 'Compartilhar',
                          onPressed: _compartilharPaciente,
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert,
                              color: Colors.white),
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
                                  Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Remover paciente',
                                      style:
                                          TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Informações do paciente
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.white24,
                          child: Text(
                            p.nome.isNotEmpty ? p.nome[0].toUpperCase() : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.nome,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  // Badge prioridade
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: corPrioridade.withOpacity(0.25),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      border: Border.all(
                                          color: corPrioridade
                                              .withOpacity(0.5)),
                                    ),
                                    child: Text(
                                      _labelPrioridade(p.prioridade),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  if (p.leito != null &&
                                      p.leito!.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Leito ${p.leito}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  if (p.hospitalNome != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        p.hospitalNome!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (p.observacoes != null &&
                                  p.observacoes!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    p.observacoes!,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Conteúdo principal
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _recarregar,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 80),
                      children: [
                        // Seção: Pendentes
                        Row(
                          children: [
                            const Text(
                              'Pendentes',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: pendentes.isEmpty
                                    ? Colors.grey.shade200
                                    : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${pendentes.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: pendentes.isEmpty
                                      ? Colors.grey
                                      : Colors.orange.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (pendentes.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline,
                                    color: Colors.grey.shade400),
                                const SizedBox(width: 10),
                                Text(
                                  'Nenhum atendimento pendente.',
                                  style: TextStyle(
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          )
                        else
                          ...pendentes.map(_buildCardAtendimento),

                        const SizedBox(height: 20),

                        // Seção: Histórico (colapsável)
                        GestureDetector(
                          onTap: () => setState(
                              () => _mostrarHistorico = !_mostrarHistorico),
                          child: Row(
                            children: [
                              const Text(
                                'Histórico',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${concluidos.length}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                _mostrarHistorico
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                color: Colors.grey.shade500,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_mostrarHistorico)
                          concluidos.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.grey.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.history,
                                          color: Colors.grey.shade400),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Nenhum atendimento concluído ainda.',
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: concluidos
                                      .map(_buildCardAtendimento)
                                      .toList(),
                                ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormAtendimento(),
        tooltip: 'Novo atendimento',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AtendimentoHelper {
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