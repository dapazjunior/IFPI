/**
 * MÓDULO 4: tarefas.js
 * Gerenciamento de tarefas e status.
 */

import { supabase } from './supabaseClient.js';
import { buscarPacientePorId } from './pacientes.js'; // Reutiliza lógica

/**
 * Carrega todas as tarefas de um paciente específico.
 */
export async function carregarTarefas(pacienteId) {
    const { data, error } = await supabase
        .from('tarefas')
        .select('*')
        .eq('paciente_id', pacienteId)
        .order('horario_previsto', { ascending: true });

    return { data, error };
}

/**
 * Cadastra uma nova tarefa.
 * Valida se o usuário tem permissão de escrita ('dono', 'editar', 'total').
 */
export async function cadastrarTarefa(dadosTarefa) {
    try {
        const { paciente_id, descricao, horario_previsto } = dadosTarefa;

        // 1. Verifica permissão antes de tentar inserir
        // Reutilizamos a função de pacientes que consulta a View com RLS check
        const { data: paciente, error: erroPermissao } = await buscarPacientePorId(paciente_id);
        
        if (erroPermissao || !paciente) throw new Error("Paciente inacessível.");

        const p = paciente.permissao_do_usuario;
        
        // Regra: 'ver' não pode criar tarefas
        if (p !== 'dono' && p !== 'editar' && p !== 'total') {
            throw new Error("Apenas editores podem criar tarefas.");
        }

        // 2. Insere a tarefa
        const { data, error } = await supabase
            .from('tarefas')
            .insert([{
                paciente_id,
                descricao,
                horario_previsto: horario_previsto || null,
                status: 'pendente'
            }])
            .select()
            .single();

        return { data, error };

    } catch (err) {
        return { data: null, error: { message: err.message } };
    }
}

/**
 * Alterna o status da tarefa entre 'pendente' e 'concluida'.
 * Atualiza automaticamente o campo 'concluido_em'.
 */
export async function alternarTarefa(tarefaId, statusAtual) {
    const novoStatus = statusAtual === 'pendente' ? 'concluida' : 'pendente';
    const dataConclusao = novoStatus === 'concluida' ? new Date().toISOString() : null;

    // O RLS do banco (manipulate_tarefas) vai bloquear se o usuário for apenas 'ver'
    // mas o tratamento de erro aqui capturará isso.
    const { data, error } = await supabase
        .from('tarefas')
        .update({ 
            status: novoStatus,
            concluido_em: dataConclusao
        })
        .eq('id', tarefaId)
        .select()
        .single();

    if (error) {
        // Tradução amigável de erro de RLS
        if (error.code === '42501') { 
            return { data: null, error: { message: 'Sem permissão para alterar tarefas.' } };
        }
        return { data: null, error };
    }

    return { data, error };
}

/**
 * Exclui uma tarefa.
 */
export async function excluirTarefa(tarefaId) {
    const { error } = await supabase
        .from('tarefas')
        .delete()
        .eq('id', tarefaId);

    if (error) {
         if (error.code === '42501') {
            return { data: null, error: { message: 'Sem permissão para excluir tarefas.' } };
        }
        return { data: null, error };
    }

    return { data: true, error: null };
}

/**
 * Carrega todas as tarefas pendentes de TODOS os pacientes que o usuário tem acesso.
 * Útil para uma dashboard geral ("Minhas Tarefas do Dia").
 */
export async function carregarTodasTarefasPendentes() {
    // Busca na View de tarefas que criamos no SQL
    const { data, error } = await supabase
        .from('view_tarefas_usuario')
        .select('*')
        .eq('status', 'pendente')
        .order('horario_previsto', { ascending: true });

    return { data, error };
}