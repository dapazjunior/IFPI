import 'package:flutter/material.dart';
import '../models/usuario.dart';

class AdminSistemaScreen extends StatelessWidget {
  final Usuario usuario;

  const AdminSistemaScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin – ${usuario.nome}'),
      ),
      body: const Center(
        child: Text('Painel do administrador do sistema'),
      ),
    );
  }
}