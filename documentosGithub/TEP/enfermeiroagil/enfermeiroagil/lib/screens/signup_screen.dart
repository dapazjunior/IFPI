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
  bool _senhaVisivel = false;
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
    final scheme = Theme.of(context).colorScheme;
    final isGestor = _tipoConta == 'gestor';

    return Scaffold(
      body: Column(
        children: [
          // Header compacto com gradiente
          Container(
            width: double.infinity,
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
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Criar conta',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Preencha seus dados para começar',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Formulário
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seção: Dados pessoais
                    _sectionLabel('Dados pessoais'),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nomeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nome completo',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().length < 3) {
                          return 'Informe seu nome completo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null ||
                            !value.contains('@') ||
                            !value.contains('.')) {
                          return 'Informe um e-mail válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _telefoneCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _documentoCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Documento (CPF/COREN/CRM)',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _senhaCtrl,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _senhaVisivel
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(
                              () => _senhaVisivel = !_senhaVisivel),
                        ),
                      ),
                      obscureText: !_senhaVisivel,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    // Seção: Tipo de conta
                    _sectionLabel('Tipo de conta'),
                    const SizedBox(height: 12),
                    _buildTipoContaCard(
                      value: 'individual',
                      titulo: 'Profissional individual',
                      subtitulo: 'Para uso pessoal, sem equipe',
                      icone: Icons.person,
                    ),
                    const SizedBox(height: 10),
                    _buildTipoContaCard(
                      value: 'gestor',
                      titulo: 'Gestor de equipe',
                      subtitulo: 'Gerencie uma equipe de profissionais',
                      icone: Icons.groups,
                    ),

                    // Campos adicionais do gestor
                    if (isGestor) ...[
                      const SizedBox(height: 28),
                      _sectionLabel('Configuração da equipe'),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _planoGestor,
                        decoration: const InputDecoration(
                          labelText: 'Plano',
                          prefixIcon: Icon(Icons.star_outline),
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
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _nomeEquipeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nome da equipe / serviço',
                          prefixIcon: Icon(Icons.business_outlined),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (isGestor &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Informe o nome da equipe';
                          }
                          return null;
                        },
                      ),
                    ],

                    const SizedBox(height: 28),

                    // Erro
                    if (_erro != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _erro!,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Botão
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _submit,
                        child: _carregando
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Criar conta',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Já tem conta? ',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Entrar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String texto) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTipoContaCard({
    required String value,
    required String titulo,
    required String subtitulo,
    required IconData icone,
  }) {
    final selecionado = _tipoConta == value;
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _tipoConta = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selecionado
              ? scheme.primaryContainer.withOpacity(0.5)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado ? scheme.primary : Colors.grey.shade300,
            width: selecionado ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selecionado
                    ? scheme.primary
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icone,
                color: selecionado ? Colors.white : Colors.grey.shade600,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: selecionado
                          ? scheme.primary
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selecionado
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selecionado ? scheme.primary : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}