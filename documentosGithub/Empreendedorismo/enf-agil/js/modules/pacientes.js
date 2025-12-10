/**
 * MÓDULO 3: pacientes.js
 * CRUD de Pacientes e Lógica de Compartilhamento.
 */

import { supabase } from './supabaseClient.js';
import { getUserId } from './auth.js';

/**
 * Cadastra um novo paciente.
 * O user_id é pego automaticamente da sessão para garantir segurança no insert.
 */
export async function cadastrarPaciente(dadosPaciente) {
    // 1. Obtém o ID do usuário logado
    const userId = await getUserId();
    if (!userId) return { data: null, error: { message: 'Usuário não autenticado.' } };

    // 2. Prepara o objeto para inserção
    const novoPaciente = {
        user_id: userId, // Define o dono
        nome: dadosPaciente.nome,
        leito: dadosPaciente.leito,
        prioridade: dadosPaciente.prioridade, // Deve ser 'baixa', 'media' ou 'alta'
        observacoes: dadosPaciente.observacoes || ''
    };

    // 3. Insere no banco
    const { data, error } = await supabase
        .from('pacientes')
        .insert([novoPaciente])
        .select() // Retorna o dado inserido
        .single(); // Garante que volta um objeto, não um array

    return { data, error };
}

/**
 * Carrega lista de pacientes.
 * Usa a VIEW 'view_pacientes_usuario' criada no SQL para já trazer as permissões.
 */
export async function carregarPacientes() {
    const { data, error } = await supabase
        .from('view_pacientes_usuario') // Consulta a View, não a tabela direta
        .select('*')
        .order('criado_em', { ascending: false });

    return { data, error };
}

/**
 * Busca detalhes de um único paciente.
 */
export async function buscarPacientePorId(id) {
    const { data, error } = await supabase
        .from('view_pacientes_usuario')
        .select('*')
        .eq('id', id)
        .single();

    return { data, error };
}

/**
 * Exclui um paciente.
 * O RLS no banco já impede que não-donos excluam, mas validamos aqui também.
 */
export async function excluirPaciente(id) {
    const { error } = await supabase
        .from('pacientes')
        .delete()
        .eq('id', id);

    return { data: !error, error };
}

/**
 * Compartilha um paciente com outro usuário via E-mail.
 * NOTA: Requer uma função RPC no banco para buscar ID por email por segurança (security definer),
 * pois clientes não podem listar a tabela auth.users.
 */
export async function compartilharPaciente(emailDestino, pacienteId, permissao) {
    try {
        const meuId = await getUserId();
        
        // 1. Validação básica de auto-compartilhamento
        const { data: usuarioAtual } = await supabase.auth.getUser();
        if (usuarioAtual?.user?.email === emailDestino) {
            throw new Error("Você não pode compartilhar um paciente consigo mesmo.");
        }

        // 2. Verificar se o usuário atual tem permissão para compartilhar
        // Buscamos na view para ver qual permissão nós temos
        const { data: pacienteInfo, error: erroBusca } = await supabase
            .from('view_pacientes_usuario')
            .select('permissao_do_usuario')
            .eq('id', pacienteId)
            .single();

        if (erroBusca || !pacienteInfo) throw new Error("Paciente não encontrado ou acesso negado.");
        
        // Regra de Negócio: Só Dono ou 'total' pode compartilhar
        if (pacienteInfo.permissao_do_usuario !== 'dono' && pacienteInfo.permissao_do_usuario !== 'total') {
            throw new Error("Você não tem permissão para compartilhar este paciente.");
        }

        // 3. Resolver E-mail -> UUID
        // Como não podemos consultar auth.users direto, usamos uma RPC (Remote Procedure Call).
        // *Presume-se que você criou uma função 'get_user_id_by_email' no SQL*
        // Se não criou, essa parte falhará.
        const { data: uuidDestino, error: erroRPC } = await supabase
            .rpc('get_user_id_by_email', { email_input: emailDestino });

        if (erroRPC || !uuidDestino) throw new Error("Usuário não encontrado com este e-mail.");

        // 4. Inserir o compartilhamento
        const { data, error } = await supabase
            .from('pacientes_compartilhados')
            .insert([{
                paciente_id: pacienteId,
                usuario_id: uuidDestino,
                permissao: permissao, // 'ver', 'editar', 'total'
                compartilhado_por: meuId
            }])
            .select();

        // Tratamento de erro de duplicidade (código Postgres 23505)
        if (error && error.code === '23505') {
            return { data: null, error: { message: 'Este usuário já tem acesso a este paciente.' } };
        }

        return { data, error };

    } catch (err) {
        return { data: null, error: { message: err.message } };
    }
}

/**
 * Carrega quem tem acesso a um determinado paciente.
 */
export async function carregarAcessosDePaciente(pacienteId) {
    const { data, error } = await supabase
        .from('pacientes_compartilhados')
        .select('id, usuario_id, permissao, compartilhado_em') // Nota: para pegar nomes, precisaria de uma tabela 'profiles' pública
        .eq('paciente_id', pacienteId);

    return { data, error };
}