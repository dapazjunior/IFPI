import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/usuario.dart';
import '../services/usuario_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  final Usuario usuario;

  const AdminDashboardScreen({super.key, required this.usuario});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late final UsuarioService _usuarioService;
  late Future<List<Usuario>> _futureEnfermeiros;

  @override
  void initState() {
    super.initState();
    _usuarioService = UsuarioService(Supabase.instance.client);
    _futureEnfermeiros =
        _usuarioService.listarEnfermeirosDaEquipe(widget.usuario.id);
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text('Equipe - ${u.nome}'),
      ),
      body: FutureBuilder<List<Usuario>>(
        future: _futureEnfermeiros,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final lista = snapshot.data ?? [];
          if (lista.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum enfermeiro na equipe.\n'
                'No futuro, você poderá adicionar membros por aqui.',
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final e = lista[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(e.nome.substring(0, 1).toUpperCase()),
                ),
                title: Text(e.nome),
                subtitle: Text(e.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      e.emServico ? Icons.circle : Icons.circle_outlined,
                      color: e.emServico ? Colors.green : Colors.grey,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(e.emServico ? 'Em serviço' : 'Offline'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}