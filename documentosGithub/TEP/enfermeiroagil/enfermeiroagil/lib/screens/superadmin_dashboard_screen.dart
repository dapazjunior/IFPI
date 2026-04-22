import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/usuario.dart';
import '../services/usuario_service.dart';

class SuperAdminDashboardScreen extends StatefulWidget {
  final Usuario usuario;

  const SuperAdminDashboardScreen({super.key, required this.usuario});

  @override
  State<SuperAdminDashboardScreen> createState() =>
      _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen> {
  late final UsuarioService _usuarioService;
  late Future<List<Usuario>> _futureUsuarios;

  @override
  void initState() {
    super.initState();
    _usuarioService = UsuarioService(Supabase.instance.client);
    _futureUsuarios = _usuarioService.listarTodosUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text('Superadmin - ${u.nome}'),
      ),
      body: FutureBuilder<List<Usuario>>(
        future: _futureUsuarios,
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
              child: Text('Nenhum usuário encontrado.'),
            );
          }
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final user = lista[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: user.role == 'superadmin'
                      ? Colors.purple
                      : user.role == 'admin'
                          ? Colors.blue
                          : Colors.teal,
                  child: Text(
                    user.nome.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(user.nome),
                subtitle: Text('${user.email} • ${user.role}'),
                trailing: Switch(
                  value: !user.bloqueado,
                  onChanged: (ativo) async {
                    try {
                      await _usuarioService.setBloqueado(user.id, !ativo);
                      setState(() {
                        _futureUsuarios = _usuarioService.listarTodosUsuarios();
                      });
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Erro ao atualizar bloqueio: ${e.toString()}'),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}