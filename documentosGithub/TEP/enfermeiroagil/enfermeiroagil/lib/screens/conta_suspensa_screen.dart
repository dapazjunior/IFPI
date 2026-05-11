import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ContaSuspensaScreen extends StatelessWidget {
  final String motivo;

  const ContaSuspensaScreen({super.key, required this.motivo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.block,
                  size: 72,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Acesso suspenso',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  motivo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                OutlinedButton.icon(
                  onPressed: () async {
                    await AuthService().logout();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (_) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}