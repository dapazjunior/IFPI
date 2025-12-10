// modules/dashboard.js - Dashboard principal
import { getCorPrioridade, formatarData } from './ui-helpers.js';

export function renderizarDashboard(pacientes, tarefasPendentes) {
    const totalPacientes = pacientes.length;
    const pacientesAlta = pacientes.filter(p => p.prioridade === 'alta').length;
    const pacientesMedia = pacientes.filter(p => p.prioridade === 'media').length;
    const pacientesBaixa = pacientes.filter(p => p.prioridade === 'baixa').length;
    
    return `
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3><i class="bi bi-speedometer2 me-2"></i>Dashboard</h3>
                <button class="btn btn-primary" onclick="window.modules.pacientes.mostrarFormularioNovoPaciente()">
                    <i class="bi bi-person-plus"></i> Novo Paciente
                </button>
            </div>
            
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stats-card total">
                        <h2>${totalPacientes}</h2>
                        <p class="mb-0">Total de Pacientes</p>
                        <small><i class="bi bi-people"></i> Atendidos</small>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card alta">
                        <h2>${pacientesAlta}</h2>
                        <p class="mb-0">Prioridade Alta</p>
                        <small><i class="bi bi-exclamation-triangle"></i> Urgente</small>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card media">
                        <h2>${pacientesMedia}</h2>
                        <p class="mb-0">Prioridade Média</p>
                        <small><i class="bi bi-clock"></i> Atenção</small>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card baixa">
                        <h2>${tarefasPendentes.length}</h2>
                        <p class="mb-0">Tarefas Pendentes</p>
                        <small><i class="bi bi-list-check"></i> Para fazer</small>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-lg-8">
                    <div class="card mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="bi bi-people me-2"></i>Pacientes Recentes</h5>
                            <span class="badge bg-primary">${pacientes.length} pacientes</span>
                        </div>
                        <div class="card-body p-0">
                            ${pacientes.length === 0 ? `
                                <div class="text-center text-muted py-5">
                                    <i class="bi bi-people display-1 opacity-25"></i>
                                    <p class="mt-3">Nenhum paciente cadastrado</p>
                                    <button class="btn btn-primary" onclick="window.modules.pacientes.mostrarFormularioNovoPaciente()">
                                        Cadastrar Primeiro Paciente
                                    </button>
                                </div>
                            ` : `
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th>Nome</th>
                                                <th>Leito</th>
                                                <th>Prioridade</th>
                                                <th>Criado em</th>
                                                <th>Ações</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            ${pacientes.slice(0, 5).map(paciente => `
                                                <tr>
                                                    <td>
                                                        <strong>${paciente.nome}</strong>
                                                        ${paciente.observacoes ? `
                                                            <br><small class="text-muted">${paciente.observacoes.substring(0, 30)}${paciente.observacoes.length > 30 ? '...' : ''}</small>
                                                        ` : ''}
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-light text-dark">
                                                            <i class="bi bi-geo-alt"></i> ${paciente.leito}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-${getCorPrioridade(paciente.prioridade)}">
                                                            <i class="bi bi-${paciente.prioridade === 'alta' ? 'exclamation-triangle' : paciente.prioridade === 'media' ? 'clock' : 'check-circle'}"></i>
                                                            ${paciente.prioridade.toUpperCase()}
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
                            `}
                        </div>
                        ${pacientes.length > 5 ? `
                            <div class="card-footer text-center">
                                <button class="btn btn-link" onclick="window.modules.pacientes.mostrarTodosPacientes()">
                                    Ver todos os pacientes (${pacientes.length})
                                </button>
                            </div>
                        ` : ''}
                    </div>
                </div>
                
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="bi bi-list-check me-2"></i>Próximas Tarefas</h5>
                            <span class="badge bg-warning">${tarefasPendentes.length} pendentes</span>
                        </div>
                        <div class="card-body">
                            ${tarefasPendentes.length === 0 ? `
                                <div class="text-center text-muted py-3">
                                    <i class="bi bi-check-circle display-4 opacity-25"></i>
                                    <p class="mt-2">Todas as tarefas estão em dia!</p>
                                </div>
                            ` : `
                                <div class="list-group list-group-flush">
                                    ${tarefasPendentes.slice(0, 5).map(tarefa => `
                                        <div class="list-group-item list-group-item-action border-0 px-0 py-2"
                                             onclick="window.modules.pacientes.mostrarDetalhesPaciente(${tarefa.paciente_id})">
                                            <div class="d-flex align-items-start">
                                                <div class="flex-grow-1">
                                                    <div class="d-flex justify-content-between align-items-start">
                                                        <h6 class="mb-1">${tarefa.pacientes?.nome || 'Paciente'}</h6>
                                                        <small class="text-muted">${tarefa.horario_previsto ? formatarData(tarefa.horario_previsto) : 'Sem horário'}</small>
                                                    </div>
                                                    <p class="mb-1 text-truncate">${tarefa.descricao}</p>
                                                    <small>
                                                        <span class="badge bg-${getCorPrioridade(tarefa.pacientes?.prioridade || 'baixa')} me-2">
                                                            ${tarefa.pacientes?.prioridade?.toUpperCase() || 'N/A'}
                                                        </span>
                                                        <i class="bi bi-geo-alt"></i> Leito ${tarefa.pacientes?.leito || 'N/A'}
                                                    </small>
                                                </div>
                                            </div>
                                        </div>
                                    `).join('')}
                                </div>
                            `}
                        </div>
                        ${tarefasPendentes.length > 5 ? `
                            <div class="card-footer text-center">
                                <button class="btn btn-link" onclick="window.modules.tarefas.mostrarTodasTarefasPendentes()">
                                    Ver todas as tarefas (${tarefasPendentes.length})
                                </button>
                            </div>
                        ` : ''}
                    </div>
                    
                    <div class="card mt-3">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="bi bi-bar-chart me-2"></i>Estatísticas</h5>
                        </div>
                        <div class="card-body">
                            <div class="row text-center">
                                <div class="col-6 border-end">
                                    <h3 class="text-primary">${pacientesAlta}</h3>
                                    <small class="text-muted">Alta Prioridade</small>
                                </div>
                                <div class="col-6">
                                    <h3 class="text-success">${pacientesBaixa}</h3>
                                    <small class="text-muted">Baixa Prioridade</small>
                                </div>
                            </div>
                            <hr>
                            <div class="row text-center">
                                <div class="col-12">
                                    <small class="text-muted">Média de tarefas por paciente</small>
                                    <h4>${pacientes.length > 0 ? (tarefasPendentes.length / pacientes.length).toFixed(1) : '0'}</h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `;
}

export function mostrarDashboard(appState) {
    const mainContent = document.getElementById('mainContent');
    if (!mainContent) return;
    
    mainContent.innerHTML = renderizarDashboard(appState.pacientes, appState.tarefasPendentes);
    
    // Atualizar estado
    if (window.appState) {
        window.appState.currentView = 'dashboard';
    }
}

// Exportar para escopo global
if (typeof window !== 'undefined') {
    if (!window.modules) window.modules = {};
    window.modules.dashboard = {
        mostrarDashboard,
        renderizarDashboard
    };
}