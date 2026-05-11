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

      // Se não há sessão ativa, vai para login imediatamente
      if (supabase.auth.currentSession == null) {
        if (!mounted) return;
        _ir(const LoginScreen());
        return;
      }

      final contaService = ContaService(supabase);
      final Usuario usuario = await _authService.getUsuarioAtual();

      if (!mounted) return;

      // Admin do sistema não depende de plano
      if (usuario.isAdminSistema) {
        _ir(AdminSistemaScreen(usuario: usuario));
        return;
      }

      // Usuário desativado ou bloqueado manualmente
      if (!usuario.ativo || usuario.bloqueado) {
        _ir(const ContaSuspensaScreen(
          motivo:
              'Seu acesso foi desativado. Entre em contato com o suporte.',
        ));
        return;
      }

      // Verifica situação do plano da conta
      if (usuario.contaId != null) {
        final Conta? conta =
            await contaService.obterConta(usuario.contaId!);

        if (!mounted) return;

        if (conta != null && !conta.planoAtivo) {
          _ir(ContaSuspensaScreen(
            motivo:
                'Sua conta está suspensa. Situação do pagamento: ${conta.statusPagamento}.',
          ));
          return;
        }
      }

      // Roteamento por tipo de usuário
      if (usuario.isGestor) {
        _ir(GestorDashboardScreen(usuario: usuario));
      } else {
        _ir(EnfermeiroDashboardScreen(usuario: usuario));
      }
    } catch (e) {
      if (!mounted) return;

      final supabase = Supabase.instance.client;

      // Se não há sessão, vai para login normalmente
      if (supabase.auth.currentSession == null) {
        _ir(const LoginScreen());
        return;
      }

      // Há sessão mas o perfil não carregou — mostra erro sem deslogar
      setState(() {
        _erroCarregamento = e.toString();
      });
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
    if (_erroCarregamento != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Erro ao carregar perfil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _erroCarregamento!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _tentarNovamente,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _sair,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}