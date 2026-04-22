import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario.dart';
import '../models/conta.dart';
import 'conta_service.dart';
import 'usuario_service.dart';

class AuthService {
  final SupabaseClient _supabase;

  AuthService() : _supabase = Supabase.instance.client;

  Future<void> login(String email, String senha) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: senha,
    );
    if (response.user == null) {
      throw Exception('Falha no login');
    }
  }

  Future<void> signup({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
    required String documento,
    required String tipoConta,
    String? planoGestor,
    String? nomeEquipe,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: senha,
      data: {'nome': nome},
    );

    final user = response.user;
    if (user == null) throw Exception('Falha ao criar usuário');

    final contaService = ContaService(_supabase);
    final usuarioService = UsuarioService(_supabase);

    Conta conta;

    if (tipoConta == 'individual') {
      conta = await contaService.criarContaIndividual();
      await usuarioService.atualizarDadosUsuario(
        usuarioId: user.id,
        contaId: conta.id,
        tipoUsuario: 'profissional',
        nome: nome,
        telefone: telefone,
        documento: documento,
      );
    } else {
      if (planoGestor == null || nomeEquipe == null) {
        throw Exception('Plano e nome da equipe são obrigatórios para gestor');
      }
      conta = await contaService.criarContaGestor(
        plano: planoGestor,
        nomeEquipe: nomeEquipe,
      );
      await usuarioService.atualizarDadosUsuario(
        usuarioId: user.id,
        contaId: conta.id,
        tipoUsuario: 'gestor',
        nome: nome,
        telefone: telefone,
        documento: documento,
      );
    }
  }

  Future<void> criarProfissionalParaContaAtual({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
    required String documento,
  }) async {
    final usuarioService = UsuarioService(_supabase);
    final gestor = await usuarioService.getPerfilAtual();

    if (!gestor.isGestor) {
      throw Exception('Apenas gestores podem criar profissionais.');
    }
    if (gestor.contaId == null) {
      throw Exception('Gestor sem conta associada.');
    }

    final contaService = ContaService(_supabase);
    final conta = await contaService.obterConta(gestor.contaId!);
    if (conta == null) throw Exception('Conta não encontrada.');

    final count =
        await usuarioService.contarProfissionaisDaConta(gestor.contaId!);
    if (count >= conta.limiteProfissionais) {
      throw Exception(
        'Limite de profissionais atingido (${conta.limiteProfissionais}).',
      );
    }

    final response = await _supabase.auth.admin.createUser(
      AdminUserAttributes(
        email: email,
        password: senha,
        emailConfirm: true,
        userMetadata: {'nome': nome},
      ),
    );

    final user = response.user;
    if (user == null) throw Exception('Falha ao criar profissional.');

    await usuarioService.atualizarDadosUsuario(
      usuarioId: user.id,
      contaId: gestor.contaId!,
      tipoUsuario: 'profissional',
      nome: nome,
      telefone: telefone,
      documento: documento,
    );
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  Future<Usuario> getUsuarioAtual() async {
    return UsuarioService(_supabase).getPerfilAtual();
  }
}