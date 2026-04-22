import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/usuario.dart';
import 'login_screen.dart';
import 'enfermeiro_dashboard_screen.dart';
import 'gestor_dashboard_screen.dart';
import 'admin_sistema_screen.dart';

class RouterScreen extends StatefulWidget {
  const RouterScreen({super.key});

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _decidirRota();
  }

  Future<void> _decidirRota() async {
    try {
      final Usuario usuario = await _authService.getUsuarioAtual();

      if (!mounted) return;

      if (!usuario.ativo || usuario.bloqueado) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(), // depois podemos pôr tela de bloqueio
          ),
        );
        return;
      }

      if (usuario.isAdminSistema) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AdminSistemaScreen(usuario: usuario),
          ),
        );
      } else if (usuario.isGestor) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => GestorDashboardScreen(usuario: usuario),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EnfermeiroDashboardScreen(usuario: usuario),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}