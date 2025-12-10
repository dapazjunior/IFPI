// auth.js - VERSÃO COMPLETA CORRIGIDA
import { supabase } from './supabaseClient.js';

// Função de login
export async function fazerLogin(email, senha) {
    try {
        console.log('🔑 Tentando login com:', email);
        
        const { data, error } = await supabase.auth.signInWithPassword({
            email: email,
            password: senha
        });

        if (error) {
            console.error('❌ Erro no login:', error.message);
            return { erro: error.message };
        }

        console.log('✅ Login bem-sucedido:', data.user.email);
        
        // Registrar usuário na tabela usuarios se não existir
        await registrarUsuarioSeNecessario(data.user);

        return {
            success: true,
            user: {
                id: data.user.id,
                nome: data.user.user_metadata?.nome || data.user.email.split('@')[0],
                email: data.user.email
            }
        };
    } catch (error) {
        console.error('❌ Erro no login:', error);
        return { erro: 'Erro ao fazer login' };
    }
}

// Função de cadastro
export async function fazerCadastro(nome, email, senha) {
    try {
        console.log('📝 Tentando cadastro:', nome, email);
        
        const { data, error } = await supabase.auth.signUp({
            email: email,
            password: senha,
            options: {
                data: {
                    nome: nome
                }
            }
        });

        if (error) {
            console.error('❌ Erro no cadastro:', error.message);
            return { erro: error.message };
        }

        console.log('✅ Cadastro bem-sucedido');
        
        // Registrar usuário na tabela usuarios
        if (data.user) {
            await registrarUsuario(data.user, nome);
        }

        return { 
            success: true,
            mensagem: 'Cadastro realizado com sucesso! Verifique seu email.' 
        };
    } catch (error) {
        console.error('❌ Erro no cadastro:', error);
        return { erro: 'Erro ao cadastrar' };
    }
}

// Registrar usuário na tabela usuarios
async function registrarUsuario(user, nome) {
    try {
        const { error } = await supabase
            .from('usuarios')
            .insert({
                auth_id: user.id,
                nome: nome,
                email: user.email.toLowerCase()
            });

        if (error) {
            // Se for erro de duplicado, não precisa fazer nada
            if (error.code === '23505') {
                console.log('ℹ️ Usuário já registrado na tabela usuarios');
                return;
            }
            console.error('❌ Erro ao registrar usuário:', error);
        } else {
            console.log('✅ Usuário registrado na tabela usuarios');
        }
    } catch (error) {
        console.error('❌ Erro ao registrar usuário:', error);
    }
}

// Verificar e registrar usuário se necessário
async function registrarUsuarioSeNecessario(user) {
    try {
        // Verificar se usuário já existe na tabela
        const { data, error } = await supabase
            .from('usuarios')
            .select('id')
            .eq('auth_id', user.id)
            .single();

        if (error && error.code === 'PGRST116') {
            // Usuário não existe, criar
            await registrarUsuario(user, user.user_metadata?.nome || user.email.split('@')[0]);
        } else if (error) {
            console.error('❌ Erro ao verificar usuário:', error);
        }
    } catch (error) {
        console.error('❌ Erro ao verificar usuário:', error);
    }
}

// Função de logout
export async function fazerLogout() {
    try {
        const { error } = await supabase.auth.signOut();
        if (error) {
            console.error('❌ Erro no logout:', error);
            return { erro: error.message };
        }
        return { success: true };
    } catch (error) {
        console.error('❌ Erro no logout:', error);
        return { erro: 'Erro ao fazer logout' };
    }
}

// Verificar sessão atual - VERSÃO CORRIGIDA
export async function verificarSessao() {
    try {
        // Obter sessão atual
        const { data, error } = await supabase.auth.getSession();
        
        if (error) {
            console.log('ℹ️ Erro ao obter sessão:', error.message);
            return { user: null };
        }
        
        const { session } = data;
        
        if (!session || !session.user) {
            console.log('ℹ️ Nenhuma sessão ativa');
            return { user: null };
        }

        console.log('✅ Sessão encontrada para usuário:', session.user.email);
        
        // Tentar obter nome da tabela usuarios
        let nomeUsuario = session.user.user_metadata?.nome || session.user.email.split('@')[0];
        
        try {
            const { data: usuarioData, error: usuarioError } = await supabase
                .from('usuarios')
                .select('nome')
                .eq('auth_id', session.user.id)
                .maybeSingle();  // Use maybeSingle em vez de single

            if (!usuarioError && usuarioData) {
                nomeUsuario = usuarioData.nome || nomeUsuario;
            }
        } catch (usuarioError) {
            console.log('ℹ️ Não foi possível obter dados do usuário da tabela:', usuarioError?.message);
        }

        return {
            user: {
                id: session.user.id,
                nome: nomeUsuario,
                email: session.user.email
            }
        };
    } catch (error) {
        console.error('❌ Erro ao verificar sessão:', error);
        return { user: null };
    }
}

// Obter usuário atual
export async function getCurrentUser() {
    try {
        const { data: { user }, error } = await supabase.auth.getUser();
        return { user, error };
    } catch (error) {
        console.error('❌ Erro ao obter usuário:', error);
        return { user: null, error };
    }
}