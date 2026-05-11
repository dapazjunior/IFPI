import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _documentoCtrl = TextEditingController();
  final _nomeEquipeCtrl = TextEditingController();

  String _tipoConta = 'individual';
  String _planoGestor = 'homecare';
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
    _nomeEquipeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      await _authService.signup(
        nome: _nomeCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        senha: _senhaCtrl.text,
        telefone: _telefoneCtrl.text.trim(),
        documento: _documentoCtrl.text.trim(),
        tipoConta: _tipoConta,
        planoGestor: _tipoConta == 'gestor' ? _planoGestor : null,
        nomeEquipe:
            _tipoConta == 'gestor' ? _nomeEquipeCtrl.text.trim() : null,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );

      // Usuário já está logado após o signup, vai direto para o router
      Navigator.pushReplacementNamed(context, '/router');
    } catch (e) {
      setState(() {
        _erro = e.toString();
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGestor = _tipoConta == 'gestor';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
      ),
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
                    validator: (value) {
                      if (value == null || value.trim().length < 3) {
                        return 'Informe seu nome completo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          !value.contains('@') ||
                          !value.contains('.')) {
                        return 'Informe um e-mail válido';
                      }
                      return null;
                    },
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
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'A senha deve ter pelo menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tipo de conta',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Profissional individual'),
                          value: 'individual',
                          groupValue: _tipoConta,
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => _tipoConta = v);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Gestor de equipe'),
                          value: 'gestor',
                          groupValue: _tipoConta,
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => _tipoConta = v);
                          },
                        ),
                      ),
                    ],
                  ),
                  if (isGestor) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Plano do gestor',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _planoGestor,
                      decoration: const InputDecoration(
                        labelText: 'Plano',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'homecare',
                          child: Text('Homecare (até 5 profissionais)'),
                        ),
                        DropdownMenuItem(
                          value: 'equipe',
                          child: Text('Equipe (até 15 profissionais)'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _planoGestor = v);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nomeEquipeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nome da equipe/serviço',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (isGestor &&
                            (value == null || value.trim().isEmpty)) {
                          return 'Informe o nome da equipe/serviço';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (_erro != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _erro!,
                        style: const TextStyle(
                            color: Colors.red, fontSize: 13),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _carregando ? null : _submit,
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
                          : const Text('Criar conta'),
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