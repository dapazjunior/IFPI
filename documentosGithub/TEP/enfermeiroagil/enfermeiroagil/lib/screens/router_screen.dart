import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/conta.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/conta_service.dart';
import 'login_screen.dart';
import 'enfermeiro_dashboard_screen.dart';
import 'gestor_dashboard_screen.dart';
import 'admin_sistema_screen.dart';
import 'conta_suspensa_screen.dart';

class RouterScreen extends StatefulWidget {
  const RouterScreen({super.key});

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  final _authService = AuthService();
  String? _erroCarregamento;

  @override
  void initState() {
    super.initState();
    _decidirRota();
  }

  Future<void> _decidirRota() async {
    try {
      final supabase = Supabase.instance.client;

      if (supabase.auth.currentSession == null) {
        if (!mounted) return;
        _ir(const LoginScreen());
        return;
      }

      final contaService = ContaService(supabase);
      final Usuario usuario = await _authService.getUsuarioAtual();

      if (!mounted) return;

      if (usuario.isAdminSistema) {
        _ir(AdminSistemaScreen(usuario: usuario));
        return;
      }

      if (!usuario.ativo || usuario.bloqueado) {
        _ir(const ContaSuspensaScreen(
          motivo: 'Seu acesso foi desativado. Entre em contato com o suporte.',
        ));
        return;
      }

      if (usuario.contaId != null) {
        final Conta? conta = await contaService.obterConta(usuario.contaId!);

        if (!mounted) return;

        if (conta != null && !conta.planoAtivo) {
          _ir(ContaSuspensaScreen(
            motivo:
                'Sua conta está suspensa. Situação do pagamento: ${conta.statusPagamento}.',
          ));
          return;
        }
      }

      if (usuario.isGestor) {
        _ir(GestorDashboardScreen(usuario: usuario));
      } else {
        _ir(EnfermeiroDashboardScreen(usuario: usuario));
      }
    } catch (e) {
      if (!mounted) return;

      final supabase = Supabase.instance.client;

      if (supabase.auth.currentSession == null) {
        _ir(const LoginScreen());
        return;
      }

      setState(() => _erroCarregamento = e.toString());
    }
  }

  void _ir(Widget tela) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => tela),
    );
  }

  Future<void> _tentarNovamente() async {
    setState(() => _erroCarregamento = null);
    await _decidirRota();
  }

  Future<void> _sair() async {
    await _authService.logout();
    if (!mounted) return;
    _ir(const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (_erroCarregamento != null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 48,
                    color: Colors.red.shade400,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Erro ao carregar perfil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _erroCarregamento!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _tentarNovamente,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _sair,
                    icon: const Icon(Icons.logout),
                    label: const Text('Sair'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Tela de loading com identidade visual
    return Scaffold(
      body: Container(
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
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.medical_services_rounded,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
              SizedBox(height: 16),
              Text(
                'Carregando...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}