import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/usuario.dart';
import '../models/hospital.dart';
import '../models/tipo_atendimento.dart';
import '../services/paciente_service.dart';
import '../services/hospital_service.dart';
import '../services/tipo_atendimento_service.dart';

class PacienteFormScreen extends StatefulWidget {
  final Usuario usuario;

  const PacienteFormScreen({super.key, required this.usuario});

  @override
  State<PacienteFormScreen> createState() => _PacienteFormScreenState();
}

class _PacienteFormScreenState extends State<PacienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _leitoCtrl = TextEditingController();
  final _obsCtrl = TextEditingController();

  late final PacienteService _pacienteService;
  late final HospitalService _hospitalService;
  late final TipoAtendimentoService _tipoService;

  List<Hospital> _hospitais = [];
  List<TipoAtendimento> _tipos = [];

  Hospital? _hospitalSelecionado;
  TipoAtendimento? _tipoSelecionado;
  String _prioridade = 'baixa';
  bool _loading = false;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _pacienteService = PacienteService(supabase);
    _hospitalService = HospitalService(supabase);
    _tipoService = TipoAtendimentoService(supabase);
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final hospitais = await _hospitalService.listarHospitais();
      final tipos = await _tipoService.listarTiposDisponiveis();
      setState(() {
        _hospitais = hospitais;
        _tipos = tipos;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  Future<void> _abrirDialogNovoHospital() async {
    final nomeCtrl = TextEditingController();
    final cidadeCtrl = TextEditingController();
    final estadoCtrl = TextEditingController();

    final resultado = await showDialog<Hospital>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Novo Hospital'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(
                labelText: 'Nome do hospital *',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cidadeCtrl,
              decoration: const InputDecoration(
                labelText: 'Cidade (opcional)',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: estadoCtrl,
              decoration: const InputDecoration(
                labelText: 'Estado (opcional)',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nomeCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Informe o nome do hospital')),
                );
                return;
              }
              try {
                final novo = await _hospitalService.criarHospital(
                  nome: nomeCtrl.text.trim(),
                  cidade: cidadeCtrl.text.trim().isEmpty
                      ? null
                      : cidadeCtrl.text.trim(),
                  estado: estadoCtrl.text.trim().isEmpty
                      ? null
                      : estadoCtrl.text.trim(),
                );
                if (ctx.mounted) Navigator.pop(ctx, novo);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Erro ao criar hospital: $e')),
                  );
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (resultado != null) {
      setState(() {
        _hospitais.add(resultado);
        _hospitais.sort((a, b) => a.nome.compareTo(b.nome));
        _hospitalSelecionado = resultado;
      });
    }
  }

  Future<void> _abrirDialogNovoTipo() async {
    final nomeCtrl = TextEditingController();

    final resultado = await showDialog<TipoAtendimento>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Novo Tipo de Atendimento'),
        content: TextField(
          controller: nomeCtrl,
          decoration: const InputDecoration(
            labelText: 'Nome do atendimento *',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nomeCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Informe o nome')),
                );
                return;
              }
              try {
                final novo = await _tipoService
                    .criarTipoPersonalizado(nomeCtrl.text.trim());
                if (ctx.mounted) Navigator.pop(ctx, novo);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Erro: $e')),
                  );
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (resultado != null) {
      setState(() {
        _tipos.add(resultado);
        _tipos.sort((a, b) => a.nome.compareTo(b.nome));
        _tipoSelecionado = resultado;
      });
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_hospitalSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um hospital')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await _pacienteService.criarPaciente(
        nome: _nomeCtrl.text.trim(),
        leito: _leitoCtrl.text.trim().isEmpty ? null : _leitoCtrl.text.trim(),
        prioridade: _prioridade,
        hospitalId: _hospitalSelecionado!.id,
        observacoes: _obsCtrl.text.trim().isEmpty ? null : _obsCtrl.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paciente cadastrado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar paciente: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _leitoCtrl.dispose();
    _obsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Paciente')),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nomeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nome do paciente *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Informe o nome'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _leitoCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Leito (opcional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.bed),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                          icon:
                              Icon(Icons.arrow_downward, color: Colors.green),
                        ),
                      ],
                      selected: {_prioridade},
                      onSelectionChanged: (s) =>
                          setState(() => _prioridade = s.first),
                    ),
                    const SizedBox(height: 16),
                    const Text('Hospital *',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Hospital>(
                      value: _hospitalSelecionado,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.local_hospital),
                      ),
                      hint: const Text('Selecione o hospital'),
                      items: [
                        ..._hospitais.map((h) => DropdownMenuItem(
                              value: h,
                              child: Text(h.nome),
                            )),
                        const DropdownMenuItem(
                          value: null,
                          child: Row(
                            children: [
                              Icon(Icons.add, size: 18),
                              SizedBox(width: 6),
                              Text('Adicionar novo hospital...'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          _abrirDialogNovoHospital();
                        } else {
                          setState(() => _hospitalSelecionado = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Tipo de atendimento principal (opcional)',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<TipoAtendimento>(
                      value: _tipoSelecionado,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.medical_services),
                      ),
                      hint: const Text('Selecione o tipo'),
                      items: [
                        ..._tipos.map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t.nome),
                            )),
                        const DropdownMenuItem(
                          value: null,
                          child: Row(
                            children: [
                              Icon(Icons.add, size: 18),
                              SizedBox(width: 6),
                              Text('Adicionar novo tipo...'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          _abrirDialogNovoTipo();
                        } else {
                          setState(() => _tipoSelecionado = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _obsCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Observações (opcional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.notes),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : _salvar,
                        icon: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.save),
                        label: const Text('Salvar Paciente'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}