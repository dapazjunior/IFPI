// pacientes.js
import { supabase } from './supabaseClient.js';

// Carregar todos os pacientes do usuário logado
export async function carregarPacientes() {
    try {
        console.log('📋 Carregando pacientes...');
        
        const { data: { user }, error: userError } = await supabase.auth.getUser();
        
        if (userError || !user) {
            console.error('❌ Usuário não autenticado');
            return [];
        }

        const { data, error } = await supabase
            .from('pacientes')
            .select('*')
            .eq('auth_id', user.id)
            .order('prioridade', { ascending: false }) // alta primeiro
            .order('nome', { ascending: true });

        if (error) {
            console.error('❌ Erro ao carregar pacientes:', error.message);
            return [];
        }

        console.log(`✅ ${data?.length || 0} pacientes carregados`);
        return data || [];
    } catch (error) {
        console.error('❌ Erro ao carregar pacientes:', error);
        return [];
    }
}

// Cadastrar novo paciente
export async function cadastrarPaciente(dados) {
    try {
        console.log('➕ Cadastrando paciente:', dados);
        
        const { data: { user }, error: userError } = await supabase.auth.getUser();
        
        if (userError || !user) {
            return { erro: 'Usuário não autenticado' };
        }

        const pacienteData = {
            ...dados,
            auth_id: user.id
        };

        const { data, error } = await supabase
            .from('pacientes')
            .insert([pacienteData])
            .select()
            .single();

        if (error) {
            console.error('❌ Erro ao cadastrar paciente:', error.message);
            return { erro: error.message };
        }

        console.log('✅ Paciente cadastrado:', data.id);
        return { 
            success: true, 
            mensagem: 'Paciente cadastrado com sucesso!',
            data: data
        };
    } catch (error) {
        console.error('❌ Erro ao cadastrar paciente:', error);
        return { erro: 'Erro ao cadastrar paciente' };
    }
}

// Excluir paciente
export async function excluirPaciente(id) {
    try {
        console.log('🗑️ Excluindo paciente ID:', id);
        
        const { data: { user }, error: userError } = await supabase.auth.getUser();
        
        if (userError || !user) {
            return { erro: 'Usuário não autenticado' };
        }

        // Verificar se o paciente pertence ao usuário
        const { data: paciente, error: checkError } = await supabase
            .from('pacientes')
            .select('auth_id')
            .eq('id', id)
            .single();

        if (checkError) {
            return { erro: 'Paciente não encontrado' };
        }

        if (paciente.auth_id !== user.id) {
            return { erro: 'Não autorizado' };
        }

        const { error } = await supabase
            .from('pacientes')
            .delete()
            .eq('id', id);

        if (error) {
            console.error('❌ Erro ao excluir paciente:', error.message);
            return { erro: error.message };
        }

        console.log('✅ Paciente excluído:', id);
        return { 
            success: true, 
            mensagem: 'Paciente excluído com sucesso!' 
        };
    } catch (error) {
        console.error('❌ Erro ao excluir paciente:', error);
        return { erro: 'Erro ao excluir paciente' };
    }
}

// Buscar paciente por ID
export async function buscarPacientePorId(id) {
    try {
        const { data, error } = await supabase
            .from('pacientes')
            .select('*')
            .eq('id', id)
            .single();

        if (error) {
            console.error('❌ Erro ao buscar paciente:', error.message);
            return null;
        }

        return data;
    } catch (error) {
        console.error('❌ Erro ao buscar paciente:', error);
        return null;
    }
}