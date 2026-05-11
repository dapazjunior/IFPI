import 'package:flutter/material.dart';
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
    debugPrint('>>> [signup] PASSO 1: signUp iniciado para $email');

    final signUpResponse = await _supabase.auth.signUp(
      email: email,
      password: senha,
      data: {'nome': nome},
    );

    if (signUpResponse.user == null) {
      throw Exception('Falha ao criar usuário');
    }

    debugPrint('>>> [signup] PASSO 1 OK: user.id=${signUpResponse.user!.id}');
    debugPrint('>>> [signup] PASSO 1: session após signUp = ${_supabase.auth.currentSession?.accessToken != null ? "existe" : "NULL"}');

    debugPrint('>>> [signup] PASSO 2: signInWithPassword iniciado');

    final loginResponse = await _supabase.auth.signInWithPassword(
      email: email,
      password: senha,
    );

    final user = loginResponse.user;
    if (user == null) {
      throw Exception('Falha ao autenticar após criar usuário');
    }

    debugPrint('>>> [signup] PASSO 2 OK: user.id=${user.id}');
    debugPrint('>>> [signup] PASSO 2: session role = ${_supabase.auth.currentSession?.accessToken != null ? "existe" : "NULL"}');

    final contaService = ContaService(_supabase);
    final usuarioService = UsuarioService(_supabase);

    Conta conta;

    debugPrint('>>> [signup] PASSO 3: criarConta iniciado, tipoConta=$tipoConta');

    if (tipoConta == 'individual') {
      conta = await contaService.criarContaIndividual();
      debugPrint('>>> [signup] PASSO 3 OK: conta.id=${conta.id}');

      debugPrint('>>> [signup] PASSO 4: atualizarDadosUsuario iniciado');
      await usuarioService.atualizarDadosUsuario(
        usuarioId: user.id,
        contaId: conta.id,
        tipoUsuario: 'profissional',
        nome: nome,
        telefone: telefone,
        documento: documento,
      );
      debugPrint('>>> [signup] PASSO 4 OK');
    } else {
      if (planoGestor == null || nomeEquipe == null) {
        throw Exception('Plano e nome da equipe são obrigatórios para gestor');
      }
      conta = await contaService.criarContaGestor(
        plano: planoGestor,
        nomeEquipe: nomeEquipe,
      );
      debugPrint('>>> [signup] PASSO 3 OK: conta.id=${conta.id}');

      debugPrint('>>> [signup] PASSO 4: atualizarDadosUsuario iniciado');
      await usuarioService.atualizarDadosUsuario(
        usuarioId: user.id,
        contaId: conta.id,
        tipoUsuario: 'gestor',
        nome: nome,
        telefone: telefone,
        documento: documento,
      );
      debugPrint('>>> [signup] PASSO 4 OK');
    }

    debugPrint('>>> [signup] CONCLUÍDO com sucesso');
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
    if (conta == null) {
      throw Exception('Conta não encontrada.');
    }

    final count =
        await usuarioService.contarProfissionaisDaConta(gestor.contaId!);
    if (count >= conta.limiteProfissionais) {
      throw Exception(
        'Limite de profissionais atingido (${conta.limiteProfissionais}).',
      );
    }

    final sessaoGestor = _supabase.auth.currentSession;
    if (sessaoGestor == null) {
      throw Exception('Sessão do gestor perdida.');
    }
    final refreshTokenGestor = sessaoGestor.refreshToken;
    if (refreshTokenGestor == null || refreshTokenGestor.isEmpty) {
      throw Exception('Refresh token do gestor não encontrado.');
    }

    final response = await _supabase.auth.signUp(
      email: email,
      password: senha,
      data: {'nome': nome},
    );

    final novoUser = response.user;
    if (novoUser == null) {
      throw Exception('Falha ao criar profissional.');
    }

    await usuarioService.atualizarDadosUsuario(
      usuarioId: novoUser.id,
      contaId: gestor.contaId!,
      tipoUsuario: 'profissional',
      nome: nome,
      telefone: telefone,
      documento: documento,
    );

    final restoreResponse =
        await _supabase.auth.setSession(refreshTokenGestor);

    if (restoreResponse.user == null ||
        _supabase.auth.currentUser?.id != gestor.id) {
      throw Exception(
        'Não foi possível restaurar a sessão do gestor após criar o profissional.',
      );
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  Future<Usuario> getUsuarioAtual() async {
    return UsuarioService(_supabase).getUsuarioAtual();
  }
}