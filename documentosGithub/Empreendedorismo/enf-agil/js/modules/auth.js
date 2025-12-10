/**
 * MÓDULO 2: auth.js
 * Gerencia Login, Cadastro, Logout e Sessão.
 */

import { supabase } from './supabaseClient.js';

/**
 * Realiza o login do usuário com e-mail e senha.
 */
export async function fazerLogin(email, senha) {
    // Tenta autenticar usando a API do Supabase
    const { data, error } = await supabase.auth.signInWithPassword({
        email: email,
        password: senha,
    });

    // Retorna o resultado padronizado
    // Se houver erro, data será null e error conterá os detalhes
    return { data, error };
}

/**
 * Cria uma nova conta de usuário.
 * Salva o 'nome' nos metadados do usuário para uso futuro.
 */
export async function fazerCadastro(nome, email, senha) {
    // Chama a função de cadastro (signUp)
    const { data, error } = await supabase.auth.signUp({
        email: email,
        password: senha,
        options: {
            // O objeto data dentro de options salva informações extras no auth.users
            data: {
                full_name: nome, // Salva o nome para exibição na UI
            },
        },
    });

    return { data, error };
}

/**
 * Encerra a sessão do usuário atual.
 */
export async function fazerLogout() {
    const { error } = await supabase.auth.signOut();
    // Retornamos um objeto vazio em data para manter o padrão, caso sucesso
    return { data: !error, error };
}

/**
 * Verifica se existe um usuário logado e retorna seus dados.
 * Útil para proteger rotas ou recuperar o ID do usuário.
 */
export async function verificarSessao() {
    // Obtém a sessão atual
    const { data, error } = await supabase.auth.getSession();
    
    // Se não houver sessão, data.session será null
    return { data: data.session, error };
}

/**
 * Helper para pegar o User ID atual rapidamente (uso interno)
 */
export async function getUserId() {
    const { data } = await supabase.auth.getUser();
    return data?.user?.id || null;
}