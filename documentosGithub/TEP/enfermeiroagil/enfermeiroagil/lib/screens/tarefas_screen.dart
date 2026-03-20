import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../models/tarefa.dart';
import '../services/tarefa_service.dart';

class TarefasScreen extends StatefulWidget {
  final Paciente paciente;

  const TarefasScreen({super.key, required this.paciente});

  @override
  State<TarefasScreen> createState() => _TarefasScreenState();
}

class _TarefasScreenState extends State<TarefasScreen> {
  final _tarefaService = TarefaService();
  late Future<List<Tarefa>> _futureTarefas;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    setState(() {
      _futureTarefas = _tarefaService.listarTarefas(widget.paciente.id);
    });
  }

  void _mostrarDialogNovaTarefa() {
    final descCtrl = TextEditingController();
    final horaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nova Tarefa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Descrição *'),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: horaCtrl,
              decoration: const InputDecoration(
                labelText: 'Horário previsto (ex: 14:30)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (descCtrl.text.isEmpty) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Descrição é obrigatória')),
                );
                return;
              }
              // Guarda referências antes do await
              final nav = Navigator.of(dialogContext);
              final messenger = ScaffoldMessenger.of(context);
              try {
                await _tarefaService.criarTarefa(
                  pacienteId: widget.paciente.id,
                  descricao: descCtrl.text.trim(),
                  horarioPrevisto: horaCtrl.text.trim().isEmpty
                      ? null
                      : horaCtrl.text.trim(),
                );
                nav.pop();
                _carregar();
              } catch (e) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Erro: $e')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.paciente;
    return Scaffold(
      appBar: AppBar(
        title: Text('${p.nome} — Leito ${p.leito}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregar,
          ),
        ],
      ),
      body: FutureBuilder<List<Tarefa>>(
        future: _futureTarefas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final tarefas = snapshot.data ?? [];
          if (tarefas.isEmpty) {
            return const Center(
              child: Text('Nenhuma tarefa.\nToque em + para adicionar.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              final t = tarefas[index];
              return Card(
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(
                      t.concluida
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: t.concluida ? Colors.green : Colors.grey,
                    ),
                    onPressed: () async {
                      // Guarda messenger antes do await
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        await _tarefaService.alternarStatus(t);
                        _carregar();
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Erro: $e')),
                        );
                      }
                    },
                  ),
                  title: Text(
                    t.descricao,
                    style: TextStyle(
                      decoration:
                          t.concluida ? TextDecoration.lineThrough : null,
                      color: t.concluida ? Colors.grey : null,
                    ),
                  ),
                  subtitle: t.horarioPrevisto != null
                      ? Text('Previsto: ${t.horarioPrevisto}')
                      : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      final confirmar = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Excluir tarefa'),
                          content:
                              const Text('Deseja excluir esta tarefa?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Excluir',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirmar == true) {
                        // Guarda messenger antes do await
                        final messenger = ScaffoldMessenger.of(context);
                        try {
                          await _tarefaService.deletarTarefa(t.id);
                          _carregar();
                        } catch (e) {
                          messenger.showSnackBar(
                            SnackBar(content: Text('Erro: $e')),
                          );
                        }
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogNovaTarefa,
        child: const Icon(Icons.add),
      ),
    );
  }
}