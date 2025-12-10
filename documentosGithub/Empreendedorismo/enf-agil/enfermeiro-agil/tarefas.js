// tarefas.js
import { supabase } from './supabaseClient.js';

// Carregar tarefas de um paciente
export async function carregarTarefas(pacienteId) {
    try {
        console.log('📝 Carregando tarefas do paciente:', pacienteId);
        
        const { data: { user }, error: userError } = await supabase.auth.getUser();
        
        if (userError || !user) {
            console.error('❌ Usuário não autenticado');
            return [];
        }

        const { data, error } = await supabase
            .from('tarefas')
            .select('*')
            .eq('paciente_id', pacienteId)
            .order('status', { ascending: true }) // pendente primeiro
            .order('horario_previsto', { ascending: true });

        if (error) {
            console.error('❌ Erro ao carregar tarefas:', error.message);
            return [];
        }

        console.log(`✅ ${data?.length || 0} tarefas carregadas`);
        return data || [];
    } catch (error) {
        console.error('❌ Erro ao carregar tarefas:', error);
        return [];
    }
}

// Cadastrar nova tarefa
export async function cadastrarTarefa(dados) {
    try {
        console.log('➕ Cadastrando tarefa:', dados);
        
        const { data: { user }, error: userError } = await supabase.auth.getUser();
        
        if (userError || !user) {
            return { erro: 'Usuário não autenticado' };
        }

        // Verificar se paciente pertence ao usuário
        const { data: paciente, error: checkError } = await supabase
            .from('pacientes')
            .select('id')
            .eq('id', dados.paciente_id)
            .eq('auth_id', user.id)
            .single();

        if (checkError) {
            return { erro: 'Paciente não encontrado ou não autorizado' };
        }

        const { data, error } = await supabase
            .from('tarefas')
            .insert([dados])
            .select()
            .single();

        if (error) {
            console.error('❌ Erro ao cadastrar tarefa:', error.message);
            return { erro: error.message };
        }

        console.log('✅ Tarefa cadastrada:', data.id);
        return { 
            success: true, 
            mensagem: 'Tarefa cadastrada com sucesso!',
            data: data
        };
    } catch (error) {
        console.error('❌ Erro ao cadastrar tarefa:', error);
        return { erro: 'Erro ao cadastrar tarefa' };
    }
}

// Alternar status da tarefa (pendente/concluida)
export async function alternarTarefa(id) {
    try {
        console.log('🔄 Alternando tarefa ID:', id);
        
        const { data: { user }, error: userError } = await supabase.auth.getUser();
        
        if (userError || !user) {
            return { erro: 'Usuário não autenticado' };
        }

        // Primeiro buscar a tarefa
        const { data: tarefa, error: fetchError } = await supabase
            .from('tarefas')
            .select('*')
            .eq('id', id)
            .single();

        if (fetchError) {
            console.error('❌ Tarefa não encontrada:', fetchError.message);
            return { erro: 'Tarefa não encontrada' };
        }

        // Verificar se paciente pertence ao usuário
        const { data: paciente, error: pacienteError } = await supabase
            .from('pacientes')
            .select('auth_id')
            .eq('id', tarefa.paciente_id)
            .single();

        if (pacienteError || paciente.auth_id !== user.id) {
            return { erro: 'Não autorizado' };
        }

        const novoStatus = tarefa.status === 'pendente' ? 'concluida' : 'pendente';
        const concluidoEm = novoStatus === 'concluida' ? new Date().toISOString() : null;

        const { data, error } = await supabase
            .from('tarefas')
            .update({
                status: novoStatus,
                concluido_em: concluidoEm,
                updated_at: new Date().toISOString()
            })
            .eq('id', id)
            .select()
            .single();

        if (error) {
            console.error('❌ Erro ao alternar tarefa:', error.message);
            return { erro: error.message };
        }

        console.log('✅ Tarefa alternada para:', novoStatus);
        return { 
            success: true, 
            mensagem: 'Tarefa atualizada!',
            data: data,
            novoStatus: novoStatus
        };
    } catch (error) {
        console.error('❌ Erro ao alternar tarefa:', error);
        return { erro: 'Erro ao atualizar tarefa' };
    }
}

// Excluir tarefa
export async function excluirTarefa(id) {
    try {
        console.log('🗑️ Excluindo tarefa ID:', id);
        
        const { data: { user }, error: userError } = await supabase.auth.getUser();
        
        if (userError || !user) {
            return { erro: 'Usuário não autenticado' };
        }

        // Primeiro buscar a tarefa para verificar permissão
        const { data: tarefa, error: fetchError } = await supabase
            .from('tarefas')
            .select('paciente_id')
            .eq('id', id)
            .single();

        if (fetchError) {
            return { erro: 'Tarefa não encontrada' };
        }

        // Verificar se paciente pertence ao usuário
        const { data: paciente, error: pacienteError } = await supabase
            .from('pacientes')
            .select('auth_id')
            .eq('id', tarefa.paciente_id)
            .single();

        if (pacienteError || paciente.auth_id !== user.id) {
            return { erro: 'Não autorizado' };
        }

        const { error } = await supabase
            .from('tarefas')
            .delete()
            .eq('id', id);

        if (error) {
            console.error('❌ Erro ao excluir tarefa:', error.message);
            return { erro: error.message };
        }

        console.log('✅ Tarefa excluída:', id);
        return { 
            success: true, 
            mensagem: 'Tarefa excluída com sucesso!' 
        };
    } catch (error) {
        console.error('❌ Erro ao excluir tarefa:', error);
        return { erro: 'Erro ao excluir tarefa' };
    }
}

// Carregar todas as tarefas pendentes do usuário
export async function carregarTodasTarefasPendentes() {
    try {
        console.log('📋 Carregando todas as tarefas pendentes...');
        
        const { data: { user }, error: userError } = await supabase.auth.getUser();
        
        if (userError || !user) {
            console.error('❌ Usuário não autenticado');
            return [];
        }

        // Buscar pacientes do usuário
        const { data: pacientes, error: pacientesError } = await supabase
            .from('pacientes')
            .select('id')
            .eq('auth_id', user.id);

        if (pacientesError || !pacientes || pacientes.length === 0) {
            return [];
        }

        const pacienteIds = pacientes.map(p => p.id);

        // Buscar tarefas pendentes
        const { data, error } = await supabase
            .from('tarefas')
            .select(`
                *,
                pacientes!inner(*)
            `)
            .in('paciente_id', pacienteIds)
            .eq('status', 'pendente')
            .order('pacientes.prioridade', { ascending: false })
            .order('horario_previsto', { ascending: true });

        if (error) {
            console.error('❌ Erro ao carregar tarefas pendentes:', error.message);
            return [];
        }

        console.log(`✅ ${data?.length || 0} tarefas pendentes carregadas`);
        return data || [];
    } catch (error) {
        console.error('❌ Erro ao carregar tarefas pendentes:', error);
        return [];
    }
}