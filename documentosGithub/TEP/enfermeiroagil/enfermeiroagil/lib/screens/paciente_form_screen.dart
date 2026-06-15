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
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: cidadeCtrl,
              decoration: const InputDecoration(
                labelText: 'Cidade (opcional)',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: estadoCtrl,
              decoration: const InputDecoration(
                labelText: 'Estado (opcional)',
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
                  const SnackBar(
                      content: Text('Informe o nome do hospital')),
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
        leito:
            _leitoCtrl.text.trim().isEmpty ? null : _leitoCtrl.text.trim(),
        prioridade: _prioridade,
        hospitalId: _hospitalSelecionado!.id,
        observacoes:
            _obsCtrl.text.trim().isEmpty ? null : _obsCtrl.text.trim(),
        tipoAtendimentoIdPrincipal: _tipoSelecionado?.id,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paciente cadastrado com sucesso!')),
      );
      Navigator.pop(context, true);
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

  Widget _sectionLabel(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPrioridadeCard({
    required String value,
    required String label,
    required Color cor,
    required IconData icone,
  }) {
    final selecionado = _prioridade == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _prioridade = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selecionado ? cor.withOpacity(0.15) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selecionado ? cor : Colors.grey.shade300,
              width: selecionado ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icone,
                  color: selecionado ? cor : Colors.grey.shade400,
                  size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selecionado
                      ? FontWeight.w700
                      : FontWeight.normal,
                  color: selecionado ? cor : Colors.grey.shade600,
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
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header colorido
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        scheme.primary,
                        scheme.primary.withOpacity(0.75),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 20, 20),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new,
                                color: Colors.white, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Novo Paciente',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Preencha os dados do paciente',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Formulário
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel('Identificação'),
                          TextFormField(
                            controller: _nomeCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Nome do paciente *',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            validator: (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Informe o nome'
                                    : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _leitoCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Leito (opcional)',
                              prefixIcon: Icon(Icons.bed_outlined),
                            ),
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(height: 24),
                          _sectionLabel('Prioridade'),
                          Row(
                            children: [
                              _buildPrioridadeCard(
                                value: 'alta',
                                label: 'Alta',
                                cor: Colors.red,
                                icone: Icons.priority_high,
                              ),
                              const SizedBox(width: 8),
                              _buildPrioridadeCard(
                                value: 'media',
                                label: 'Média',
                                cor: Colors.orange,
                                icone: Icons.remove,
                              ),
                              const SizedBox(width: 8),
                              _buildPrioridadeCard(
                                value: 'baixa',
                                label: 'Baixa',
                                cor: Colors.green,
                                icone: Icons.arrow_downward,
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                          _sectionLabel('Local e tipo'),
                          DropdownButtonFormField<Hospital>(
                            value: _hospitalSelecionado,
                            decoration: const InputDecoration(
                              labelText: 'Hospital *',
                              prefixIcon:
                                  Icon(Icons.local_hospital_outlined),
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
                                    Icon(Icons.add,
                                        size: 18, color: Colors.teal),
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
                                setState(
                                    () => _hospitalSelecionado = value);
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<TipoAtendimento>(
                            value: _tipoSelecionado,
                            decoration: const InputDecoration(
                              labelText:
                                  'Tipo de atendimento principal (opcional)',
                              prefixIcon:
                                  Icon(Icons.medical_services_outlined),
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
                                    Icon(Icons.add,
                                        size: 18, color: Colors.teal),
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
                                setState(
                                    () => _tipoSelecionado = value);
                              }
                            },
                          ),

                          const SizedBox(height: 24),
                          _sectionLabel('Observações'),
                          TextFormField(
                            controller: _obsCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Observações (opcional)',
                              prefixIcon: Icon(Icons.notes_outlined),
                              alignLabelWithHint: true,
                            ),
                            maxLines: 3,
                          ),

                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: _loading ? null : _salvar,
                              icon: _loading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.save_outlined),
                              label: const Text(
                                'Salvar Paciente',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}