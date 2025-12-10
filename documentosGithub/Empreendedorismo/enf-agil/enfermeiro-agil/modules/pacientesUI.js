// modules/pacientesUI.js - Interface para pacientes
import { formatarData, getCorPrioridade } from './ui-helpers.js';

let pacienteDetalhado = null;
let tarefasPaciente = [];

// Carregar tarefas do paciente
async function carregarTarefasPaciente(pacienteId) {
    try {
        const tarefas = await window.carregarTarefas(pacienteId);
        tarefasPaciente = tarefas || [];
        return tarefasPaciente;
    } catch (error) {
        console.error('❌ Erro ao carregar tarefas:', error);
        tarefasPaciente = [];
        return [];
    }
}

// Mostrar formulário de novo paciente
export function mostrarFormularioNovoPaciente() {
    const mainContent = document.getElementById('mainContent');
    if (!mainContent) return;
    
    mainContent.innerHTML = `
        <div class="container-fluid py-4">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                            <h4 class="mb-0"><i class="bi bi-person-plus me-2"></i>Novo Paciente</h4>
                            <button class="btn btn-light btn-sm" onclick="window.modules.dashboard.mostrarDashboard(window.appState)">
                                <i class="bi bi-arrow-left"></i> Voltar
                            </button>
                        </div>
                        <div class="card-body">
                            <form id="formNovoPaciente" onsubmit="event.preventDefault(); window.modules.pacientes.salvarNovoPaciente(this)">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Nome do Paciente *</label>
                                        <input type="text" class="form-control" name="nome" required 
                                               placeholder="Nome completo do paciente">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Leito/Quarto *</label>
                                        <input type="text" class="form-control" name="leito" required 
                                               placeholder="Ex: 201A, 305B">
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Prioridade</label>
                                        <select class="form-select" name="prioridade">
                                            <option value="baixa">Baixa (Rotina)</option>
                                            <option value="media">Média (Atenção)</option>
                                            <option value="alta">Alta (Urgente)</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Data de Admissão</label>
                                        <input type="date" class="form-control" name="data_admissao">
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Observações</label>
                                    <textarea class="form-control" name="observacoes" rows="3" 
                                              placeholder="Informações relevantes sobre o paciente..."></textarea>
                                </div>
                                
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save"></i> Salvar Paciente
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary" 
                                            onclick="window.modules.dashboard.mostrarDashboard(window.appState)">
                                        <i class="bi bi-x-circle"></i> Cancelar
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `;
}

// Salvar novo paciente
export async function salvarNovoPaciente(form) {
    const formData = new FormData(form);
    const dados = {
        nome: formData.get('nome'),
        leito: formData.get('leito'),
        prioridade: formData.get('prioridade'),
        observacoes: formData.get('observacoes')
    };
    
    // Adicionar data de admissão se fornecida
    const dataAdmissao = formData.get('data_admissao');
    if (dataAdmissao) {
        dados.data_admissao = dataAdmissao;
    }
    
    try {
        const resultado = await window.cadastrarPaciente(dados);
        
        if (resultado.erro) {
            window.mostrarMensagem('Erro: ' + resultado.erro, 'error');
        } else {
            window.mostrarMensagem('Paciente cadastrado com sucesso!', 'success');
            
            // Atualizar estado e dashboard
            if (window.appState) {
                window.appState.pacientes = await window.carregarPacientes();
                window.appState.tarefasPendentes = await window.carregarTodasTarefasPendentes();
                
                // Atualizar sidebar
                if (window.renderizarSidebar) {
                    window.renderizarSidebar();
                }
                
                window.modules.dashboard.mostrarDashboard(window.appState);
            }
        }
    } catch (error) {
        console.error('❌ Erro ao salvar paciente:', error);
        window.mostrarMensagem('Erro ao cadastrar paciente', 'error');
    }
}

// Mostrar detalhes do paciente
export async function mostrarDetalhesPaciente(pacienteId) {
    if (!window.appState) return;
    
    // Encontrar paciente
    pacienteDetalhado = window.appState.pacientes.find(p => p.id == pacienteId);
    if (!pacienteDetalhado) {
        window.mostrarMensagem('Paciente não encontrado', 'error');
        return;
    }
    
    // Carregar tarefas
    await carregarTarefasPaciente(pacienteId);
    
    const mainContent = document.getElementById('mainContent');
    if (!mainContent) return;
    
    const tarefasPendentes = tarefasPaciente.filter(t => t.status === 'pendente').length;
    const tarefasConcluidas = tarefasPaciente.filter(t => t.status === 'concluida').length;
    
    mainContent.innerHTML = `
        <div class="container-fluid py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3><i class="bi bi-person me-2"></i>${pacienteDetalhado.nome}</h3>
                    <div class="d-flex gap-3 align-items-center mt-2">
                        <span class="badge bg-${getCorPrioridade(pacienteDetalhado.prioridade)} fs-6">
                            <i class="bi bi-${pacienteDetalhado.prioridade === 'alta' ? 'exclamation-triangle' : pacienteDetalhado.prioridade === 'media' ? 'clock' : 'check-circle'} me-1"></i>
                            ${pacienteDetalhado.prioridade.toUpperCase()}
                        </span>
                        <span class="text-muted">
                            <i class="bi bi-geo-alt"></i> Leito ${pacienteDetalhado.leito}
                        </span>
                        ${pacienteDetalhado.data_admissao ? `
                            <span class="text-muted">
                                <i class="bi bi-calendar"></i> Admitido em ${formatarData(pacienteDetalhado.data_admissao)}
                            </span>
                        ` : ''}
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <button class="btn btn-primary" onclick="window.modules.tarefas.mostrarFormularioNovaTarefa(${pacienteDetalhado.id})">
                        <i class="bi bi-plus-circle"></i> Nova Tarefa
                    </button>
                    <button class="btn btn-outline-secondary" onclick="window.modules.pacientes.mostrarFormularioEditarPaciente(${pacienteDetalhado.id})">
                        <i class="bi bi-pencil"></i> Editar
                    </button>
                    <button class="btn btn-danger" onclick="window.modules.pacientes.excluirPaciente(${pacienteDetalhado.id})">
                        <i class="bi bi-trash"></i> Excluir
                    </button>
                </div>
            </div>
            
            ${pacienteDetalhado.observacoes ? `
                <div class="alert alert-info">
                    <strong><i class="bi bi-info-circle"></i> Observações:</strong> ${pacienteDetalhado.observacoes}
                </div>
            ` : ''}
            
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h4 class="text-primary">${tarefasPaciente.length}</h4>
                            <p class="text-muted mb-0">Total de Tarefas</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h4 class="text-warning">${tarefasPendentes}</h4>
                            <p class="text-muted mb-0">Pendentes</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h4 class="text-success">${tarefasConcluidas}</h4>
                            <p class="text-muted mb-0">Concluídas</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card text-center">
                        <div class="card-body">
                            <h4 class="text-info">${pacienteDetalhado.prioridade === 'alta' ? 'URGENTE' : pacienteDetalhado.prioridade === 'media' ? 'ATENÇÃO' : 'ROTINA'}</h4>
                            <p class="text-muted mb-0">Status</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-list-check me-2"></i>Tarefas do Paciente</h5>
                    <div class="d-flex gap-2">
                        <button class="btn btn-sm btn-outline-primary" onclick="window.modules.tarefas.mostrarFormularioNovaTarefa(${pacienteDetalhado.id})">
                            <i class="bi bi-plus"></i> Nova Tarefa
                        </button>
                        <span class="badge bg-secondary">${tarefasPaciente.length} tarefas</span>
                    </div>
                </div>
                <div class="card-body">
                    ${tarefasPaciente.length === 0 ? `
                        <div class="text-center text-muted py-4">
                            <i class="bi bi-clipboard-x display-4 opacity-25"></i>
                            <p class="mt-2">Nenhuma tarefa cadastrada</p>
                            <button class="btn btn-primary" onclick="window.modules.tarefas.mostrarFormularioNovaTarefa(${pacienteDetalhado.id})">
                                <i class="bi bi-plus-circle"></i> Cadastrar Primeira Tarefa
                            </button>
                        </div>
                    ` : `
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Status</th>
                                        <th>Descrição</th>
                                        <th>Horário Previsto</th>
                                        <th>Concluído em</th>
                                        <th>Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    ${tarefasPaciente.map(tarefa => `
                                        <tr class="${tarefa.status === 'concluida' ? 'table-success' : ''}">
                                            <td>
                                                <span class="badge bg-${tarefa.status === 'concluida' ? 'success' : 'warning'}">
                                                    ${tarefa.status === 'concluida' ? 'Concluída' : 'Pendente'}
                                                </span>
                                            </td>
                                            <td>
                                                <strong>${tarefa.descricao}</strong>
                                            </td>
                                            <td>
                                                ${tarefa.horario_previsto ? `
                                                    <small>${formatarData(tarefa.horario_previsto)}</small>
                                                ` : '<span class="text-muted">Não definido</span>'}
                                            </td>
                                            <td>
                                                ${tarefa.concluido_em ? `
                                                    <small class="text-success">${formatarData(tarefa.concluido_em)}</small>
                                                ` : '<span class="text-muted">---</span>'}
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-${tarefa.status === 'concluida' ? 'warning' : 'success'}" 
                                                            onclick="window.modules.tarefas.alternarStatusTarefa(${tarefa.id}, ${pacienteDetalhado.id})">
                                                        <i class="bi bi-${tarefa.status === 'concluida' ? 'arrow-counterclockwise' : 'check'}"></i>
                                                    </button>
                                                    <button class="btn btn-outline-danger" 
                                                            onclick="window.modules.tarefas.excluirTarefa(${tarefa.id}, ${pacienteDetalhado.id})">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    `).join('')}
                                </tbody>
                            </table>
                        </div>
                    `}
                </div>
            </div>
        </div>
    `;
    
    // Atualizar estado
    window.appState.currentView = 'paciente';
    window.appState.currentPatient = pacienteDetalhado;
}

// Excluir paciente
export async function excluirPaciente(pacienteId) {
    if (!confirm('⚠️ ATENÇÃO!\n\nTem certeza que deseja excluir este paciente?\n\nEsta ação irá excluir TODAS as tarefas relacionadas e NÃO pode ser desfeita.')) {
        return;
    }
    
    try {
        const resultado = await window.excluirPaciente(pacienteId);
        
        if (resultado.erro) {
            window.mostrarMensagem('Erro: ' + resultado.erro, 'error');
        } else {
            window.mostrarMensagem('Paciente excluído com sucesso!', 'success');
            
            // Atualizar estado
            if (window.appState) {
                window.appState.pacientes = await window.carregarPacientes();
                window.appState.tarefasPendentes = await window.carregarTodasTarefasPendentes();
                window.appState.currentView = 'dashboard';
                window.appState.currentPatient = null;
                
                // Atualizar sidebar
                if (window.renderizarSidebar) {
                    window.renderizarSidebar();
                }
                
                // Voltar para dashboard
                window.modules.dashboard.mostrarDashboard(window.appState);
            }
        }
    } catch (error) {
        console.error('❌ Erro ao excluir paciente:', error);
        window.mostrarMensagem('Erro ao excluir paciente', 'error');
    }
}

// Mostrar todos os pacientes
export function mostrarTodosPacientes() {
    if (!window.appState) return;
    
    const mainContent = document.getElementById('mainContent');
    if (!mainContent) return;
    
    mainContent.innerHTML = `
        <div class="container-fluid py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3><i class="bi bi-people me-2"></i>Todos os Pacientes</h3>
                <div class="d-flex gap-2">
                    <button class="btn btn-primary" onclick="window.modules.pacientes.mostrarFormularioNovoPaciente()">
                        <i class="bi bi-person-plus"></i> Novo Paciente
                    </button>
                    <button class="btn btn-outline-secondary" onclick="window.modules.dashboard.mostrarDashboard(window.appState)">
                        <i class="bi bi-arrow-left"></i> Voltar
                    </button>
                </div>
            </div>
            
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Nome</th>
                                    <th>Leito</th>
                                    <th>Prioridade</th>
                                    <th>Tarefas Pendentes</th>
                                    <th>Criado em</th>
                                    <th>Ações</th>
                                </tr>
                            </thead>
                            <tbody>
                                ${window.appState.pacientes.map(paciente => `
                                    <tr>
                                        <td>
                                            <strong>${paciente.nome}</strong>
                                            ${paciente.observacoes ? `
                                                <br><small class="text-muted">${paciente.observacoes.substring(0, 50)}${paciente.observacoes.length > 50 ? '...' : ''}</small>
                                            ` : ''}
                                        </td>
                                        <td>
                                            <span class="badge bg-light text-dark">
                                                <i class="bi bi-geo-alt"></i> ${paciente.leito}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge bg-${getCorPrioridade(paciente.prioridade)}">
                                                ${paciente.prioridade.toUpperCase()}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge bg-warning">
                                                ${window.appState.tarefasPendentes.filter(t => t.paciente_id == paciente.id).length}
                                            </span>
                                        </td>
                                        <td>
                                            <small>${formatarData(paciente.criado_em)}</small>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <button class="btn btn-outline-primary" 
                                                        onclick="window.modules.pacientes.mostrarDetalhesPaciente(${paciente.id})">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                                <button class="btn btn-outline-secondary" 
                                                        onclick="window.modules.pacientes.mostrarFormularioEditarPaciente(${paciente.id})">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button class="btn btn-outline-danger" 
                                                        onclick="window.modules.pacientes.excluirPaciente(${paciente.id})">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                `).join('')}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    `;
}

// Função placeholder para editar paciente
export function mostrarFormularioEditarPaciente(pacienteId) {
    window.mostrarMensagem('Funcionalidade de edição em desenvolvimento', 'info');
}

// Exportar para escopo global
if (typeof window !== 'undefined') {
    if (!window.modules) window.modules = {};
    window.modules.pacientes = {
        mostrarFormularioNovoPaciente,
        salvarNovoPaciente,
        mostrarDetalhesPaciente,
        excluirPaciente,
        mostrarTodosPacientes,
        mostrarFormularioEditarPaciente
    };
}