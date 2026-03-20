import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../services/auth_service.dart';
import '../services/paciente_service.dart';
import 'tarefas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pacienteService = PacienteService();
  final _auth = AuthService();
  late Future<List<Paciente>> _futurePacientes;

  @override
  void initState() {
    super.initState();
    _recarregar();
  }

  void _recarregar() {
    setState(() {
      _futurePacientes = _pacienteService.listarPacientes();
    });
  }

  Color _corPrioridade(String prioridade) {
    switch (prioridade) {
      case 'alta':
        return Colors.red.shade100;
      case 'media':
        return Colors.orange.shade100;
      default:
        return Colors.green.shade100;
    }
  }

  void _mostrarDialogNovoPaciente() {
    final nomeCtrl = TextEditingController();
    final leitoCtrl = TextEditingController();
    final obsCtrl = TextEditingController();
    String prioridade = 'baixa';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setStateDialog) => AlertDialog(
          title: const Text('Novo Paciente'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeCtrl,
                  decoration: const InputDecoration(labelText: 'Nome *'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: leitoCtrl,
                  decoration: const InputDecoration(labelText: 'Leito *'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: prioridade, // corrigido: era 'value'
                  decoration: const InputDecoration(labelText: 'Prioridade'),
                  items: const [
                    DropdownMenuItem(value: 'alta', child: Text('Alta')),
                    DropdownMenuItem(value: 'media', child: Text('Média')),
                    DropdownMenuItem(value: 'baixa', child: Text('Baixa')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setStateDialog(() => prioridade = val);
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: obsCtrl,
                  decoration: const InputDecoration(labelText: 'Observações'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nomeCtrl.text.isEmpty || leitoCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                        content: Text('Nome e leito são obrigatórios')),
                  );
                  return;
                }
                // Guarda o navigator antes do await
                final nav = Navigator.of(dialogContext);
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await _pacienteService.criarPaciente(
                    nome: nomeCtrl.text.trim(),
                    leito: leitoCtrl.text.trim(),
                    prioridade: prioridade,
                    observacoes: obsCtrl.text.trim(),
                  );
                  nav.pop();
                  _recarregar();
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enfermeiro Ágil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _recarregar,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Paciente>>(
        future: _futurePacientes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final pacientes = snapshot.data ?? [];
          if (pacientes.isEmpty) {
            return const Center(
              child: Text('Nenhum paciente cadastrado.\nToque em + para adicionar.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              final p = pacientes[index];
              return Card(
                color: _corPrioridade(p.prioridade),
                child: ListTile(
                  title: Text(
                    p.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Leito: ${p.leito}  |  Prioridade: ${p.prioridade}',
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TarefasScreen(paciente: p),
                      ),
                    );
                    _recarregar();
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () async {
                      final confirmar = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Excluir paciente'),
                          content: const Text(
                            'Isso vai excluir o paciente e todas as suas tarefas. Confirma?',
                          ),
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
                          await _pacienteService.deletarPaciente(p.id);
                          _recarregar();
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
        onPressed: _mostrarDialogNovoPaciente,
        child: const Icon(Icons.add),
      ),
    );
  }
}