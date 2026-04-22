import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class GestorNovoProfissionalScreen extends StatefulWidget {
  const GestorNovoProfissionalScreen({super.key});

  @override
  State<GestorNovoProfissionalScreen> createState() =>
      _GestorNovoProfissionalScreenState();
}

class _GestorNovoProfissionalScreenState
    extends State<GestorNovoProfissionalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _documentoCtrl = TextEditingController();

  bool _carregando = false;
  String? _erro;

  final _authService = AuthService();

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _telefoneCtrl.dispose();
    _documentoCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      await _authService.criarProfissionalParaContaAtual(
        nome: _nomeCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        senha: _senhaCtrl.text,
        telefone: _telefoneCtrl.text.trim(),
        documento: _documentoCtrl.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profissional criado com sucesso.')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo profissional')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nome completo',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        v == null || v.trim().length < 3
                            ? 'Informe o nome completo'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v == null || !v.contains('@') || !v.contains('.')
                            ? 'E-mail inválido'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _telefoneCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _documentoCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Documento (CPF/COREN/CRM)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _senhaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Senha temporária',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (v) =>
                        v == null || v.length < 6
                            ? 'A senha deve ter pelo menos 6 caracteres'
                            : null,
                  ),
                  const SizedBox(height: 16),
                  if (_erro != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        _erro!,
                        style: const TextStyle(
                            color: Colors.red, fontSize: 13),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _carregando ? null : _salvar,
                      child: _carregando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : const Text('Criar profissional'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}