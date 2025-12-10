// modules/tarefasUI.js - Interface para tarefas
import { formatarData } from './ui-helpers.js';

// Mostrar formulário de nova tarefa
export function mostrarFormularioNovaTarefa(pacienteId) {
    // Buscar paciente
    const pacientes = window.appState?.pacientes || [];
    const paciente = pacientes.find(p => p.id == pacienteId);
    
    if (!paciente) {
        window.mostrarMensagem('Paciente não encontrado', 'error');
        return;
    }
    
    const mainContent = document.getElementById('mainContent');
    if (!mainContent) return;
    
    mainContent.innerHTML = `
        <div class="container-fluid py-4">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                            <h4 class="mb-0"><i class="bi bi-plus-circle me-2"></i>Nova Tarefa</h4>
                            <button class="btn btn-light btn-sm" onclick="window.modules.pacientes.mostrarDetalhesPaciente(${pacienteId})">
                                <i class="bi bi-arrow-left"></i> Voltar
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="alert alert-info mb-4">
                                <strong><i class="bi bi-person"></i> Paciente:</strong> ${paciente.nome} | 
                                <strong><i class="bi bi-geo-alt"></i> Leito:</strong> ${paciente.leito}
                            </div>
                            
                            <form id="formNovaTarefa" onsubmit="event.preventDefault(); window.modules.tarefas.salvarNovaTarefa(this, ${pacienteId})">
                                <div class="mb-3">
                                    <label class="form-label">Descrição da Tarefa *</label>
                                    <input type="text" class="form-control" name="descricao" required 
                                           placeholder="Ex: Administrar medicamento, Verificar sinais vitais...">
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Tipo de Tarefa</label>
                                        <select class="form-select" name="tipo" onchange="mostrarCamposAdicionais(this.value)">
                                            <option value="">Selecione um tipo...</option>
                                            <option value="medicacao">Administração de Medicamento</option>
                                            <option value="sinais_vitais">Verificação de Sinais Vitais</option>
                                            <option value="curativo">Troca de Curativo</option>
                                            <option value="higiene">Higiene do Paciente</option>
                                            <option value="avaliacao">Avaliação de Dor</option>
                                            <option value="outro">Outro</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Horário Previsto *</label>
                                        <input type="datetime-local" class="form-control" name="horario_previsto" required>
                                    </div>
                                </div>
                                
                                <div id="camposAdicionais" class="mb-3">
                                    <!-- Campos dinâmicos baseados no tipo -->
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Observações</label>
                                    <textarea class="form-control" name="observacoes" rows="2" 
                                              placeholder="Observações adicionais sobre a tarefa..."></textarea>
                                </div>
                                
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save"></i> Salvar Tarefa
                                    </button>
                                    <button type="button" class="btn btn-outline-secondary" 
                                            onclick="window.modules.pacientes.mostrarDetalhesPaciente(${pacienteId})">
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
    
    // Configurar data/hora padrão (agora + 1 hora)
    const agora = new Date();
    const umaHoraDepois = new Date(agora.getTime() + 60 * 60 * 1000);
    const dataFormatada = umaHoraDepois.toISOString().slice(0, 16);
    
    const horarioInput = document.querySelector('input[name="horario_previsto"]');
    if (horarioInput) {
        horarioInput.value = dataFormatada;
    }
}

// Mostrar campos adicionais baseados no tipo
function mostrarCamposAdicionais(tipo) {
    const container = document.getElementById('camposAdicionais');
    if (!container) return;
    
    let campos = '';
    
    switch(tipo) {
        case 'medicacao':
            campos = `
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Nome do Medicamento</label>
                        <input type="text" class="form-control" name="medicamento_nome" 
                               placeholder="Ex: Dipirona, Captopril...">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Dose</label>
                        <input type="text" class="form-control" name="medicamento_dose" 
                               placeholder="Ex: 500mg, 25mg...">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Via de Administração</label>
                        <select class="form-select" name="medicamento_via">
                            <option value="">Selecione...</option>
                            <option value="oral">Oral</option>
                            <option value="venosa">Venosa</option>
                            <option value="intramuscular">Intramuscular</option>
                            <option value="subcutanea">Subcutânea</option>
                            <option value="topica">Tópica</option>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Horário Específico</label>
                        <input type="time" class="form-control" name="medicamento_horario">
                    </div>
                </div>
            `;
            break;
            
        case 'sinais_vitais':
            campos = `
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Pressão Arterial</label>
                        <input type="text" class="form-control" name="sinais_pa" 
                               placeholder="Ex: 120/80">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Frequência Cardíaca</label>
                        <input type="number" class="form-control" name="sinais_fc" 
                               placeholder="bpm">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Temperatura</label>
                        <input type="number" step="0.1" class="form-control" name="sinais_temp" 
                               placeholder="°C">
                    </div>
                </div>
            `;
            break;
            
        case 'curativo':
            campos = `
                <div class="mb-3">
                    <label class="form-label">Local do Curativo</label>
                    <input type="text" class="form-control" name="curativo_local" 
                           placeholder="Ex: Braço direito, Abdômen...">
                </div>
                <div class="mb-3">
                    <label class="form-label">Tipo de Curativo</label>
                    <select class="form-select" name="curativo_tipo">
                        <option value="">Selecione...</option>
                        <option value="esteril">Estéril</option>
                        <option value="compressa">Compressa</option>
                        <option value="gaze">Gaze</option>
                        <option value="adesivo">Adesivo</option>
                    </select>
                </div>
            `;
            break;
            
        default:
            campos = '';
    }
    
    container.innerHTML = campos;
}

// Salvar nova tarefa
export async function salvarNovaTarefa(form, pacienteId) {
    const formData = new FormData(form);
    const dados = {
        paciente_id: pacienteId,
        descricao: formData.get('descricao'),
        horario_previsto: formData.get('horario_previsto')
    };
    
    // Adicionar observações se existirem
    const observacoes = formData.get('observacoes');
    if (observacoes) {
        dados.observacoes = observacoes;
    }
    
    try {
        const resultado = await window.cadastrarTarefa(dados);
        
        if (resultado.erro) {
            window.mostrarMensagem('Erro: ' + resultado.erro, 'error');
        } else {
            window.mostrarMensagem('Tarefa cadastrada com sucesso!', 'success');
            
            // Atualizar estado
            if (window.appState) {
                window.appState.tarefasPendentes = await window.carregarTodasTarefasPendentes();
                
                // Atualizar sidebar
                if (window.renderizarSidebar) {
                    window.renderizarSidebar();
                }
                
                // Voltar para detalhes do paciente
                window.modules.pacientes.mostrarDetalhesPaciente(pacienteId);
            }
        }
    } catch (error) {
        console.error('❌ Erro ao salvar tarefa:', error);
        window.mostrarMensagem('Erro ao cadastrar tarefa', 'error');
    }
}

// Alternar status da tarefa
export async function alternarStatusTarefa(tarefaId, pacienteId) {
    try {
        const resultado = await window.alternarTarefa(tarefaId);
        
        if (resultado.erro) {
            window.mostrarMensagem('Erro: ' + resultado.erro, 'error');
        } else {
            window.mostrarMensagem('Tarefa atualizada!', 'success');
            
            // Atualizar estado
            if (window.appState) {
                window.appState.tarefasPendentes = await window.carregarTodasTarefasPendentes();
                
                // Atualizar sidebar
                if (window.renderizarSidebar) {
                    window.renderizarSidebar();
                }
                
                // Recarregar detalhes do paciente
                window.modules.pacientes.mostrarDetalhesPaciente(pacienteId);
            }
        }
    } catch (error) {
        console.error('❌ Erro ao alternar tarefa:', error);
        window.mostrarMensagem('Erro ao atualizar tarefa', 'error');
    }
}

// Excluir tarefa
export async function excluirTarefa(tarefaId, pacienteId) {
    if (!confirm('Tem certeza que deseja excluir esta tarefa?')) {
        return;
    }
    
    try {
        const resultado = await window.excluirTarefa(tarefaId);
        
        if (resultado.erro) {
            window.mostrarMensagem('Erro: ' + resultado.erro, 'error');
        } else {
            window.mostrarMensagem('Tarefa excluída com sucesso!', 'success');
            
            // Atualizar estado
            if (window.appState) {
                window.appState.tarefasPendentes = await window.carregarTodasTarefasPendentes();
                
                // Atualizar sidebar
                if (window.renderizarSidebar) {
                    window.renderizarSidebar();
                }
                
                // Recarregar detalhes do paciente
                window.modules.pacientes.mostrarDetalhesPaciente(pacienteId);
            }
        }
    } catch (error) {
        console.error('❌ Erro ao excluir tarefa:', error);
        window.mostrarMensagem('Erro ao excluir tarefa', 'error');
    }
}

// Mostrar todas as tarefas pendentes
export function mostrarTodasTarefasPendentes() {
    if (!window.appState) return;
    
    const mainContent = document.getElementById('mainContent');
    if (!mainContent) return;
    
    const tarefasPendentes = window.appState.tarefasPendentes;
    
    mainContent.innerHTML = `
        <div class="container-fluid py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3><i class="bi bi-list-check me-2"></i>Todas as Tarefas Pendentes</h3>
                <button class="btn btn-outline-secondary" onclick="window.modules.dashboard.mostrarDashboard(window.appState)">
                    <i class="bi bi-arrow-left"></i> Voltar
                </button>
            </div>
            
            <div class="card">
                <div class="card-body">
                    ${tarefasPendentes.length === 0 ? `
                        <div class="text-center text-muted py-5">
                            <i class="bi bi-check-circle display-1 opacity-25"></i>
                            <p class="mt-3">Todas as tarefas estão em dia!</p>
                            <p class="text-muted">Nenhuma tarefa pendente encontrada.</p>
                        </div>
                    ` : `
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Paciente</th>
                                        <th>Leito</th>
                                        <th>Tarefa</th>
                                        <th>Horário Previsto</th>
                                        <th>Prioridade</th>
                                        <th>Ações</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    ${tarefasPendentes.map(tarefa => `
                                        <tr>
                                            <td>
                                                <strong>${tarefa.pacientes?.nome || 'Paciente'}</strong>
                                            </td>
                                            <td>
                                                <span class="badge bg-light text-dark">
                                                    <i class="bi bi-geo-alt"></i> ${tarefa.pacientes?.leito || 'N/A'}
                                                </span>
                                            </td>
                                            <td>
                                                ${tarefa.descricao}
                                                ${tarefa.observacoes ? `
                                                    <br><small class="text-muted">${tarefa.observacoes.substring(0, 50)}${tarefa.observacoes.length > 50 ? '...' : ''}</small>
                                                ` : ''}
                                            </td>
                                            <td>
                                                ${tarefa.horario_previsto ? `
                                                    <strong>${formatarData(tarefa.horario_previsto)}</strong>
                                                    <br><small class="text-muted">${calcularTempoRestante(tarefa.horario_previsto)}</small>
                                                ` : '<span class="text-muted">Não definido</span>'}
                                            </td>
                                            <td>
                                                <span class="badge bg-${getCorPrioridade(tarefa.pacientes?.prioridade || 'baixa')}">
                                                    ${tarefa.pacientes?.prioridade?.toUpperCase() || 'N/A'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm">
                                                    <button class="btn btn-outline-primary" 
                                                            onclick="window.modules.pacientes.mostrarDetalhesPaciente(${tarefa.paciente_id})">
                                                        <i class="bi bi-eye"></i> Ver
                                                    </button>
                                                    <button class="btn btn-outline-success" 
                                                            onclick="window.modules.tarefas.alternarStatusTarefa(${tarefa.id}, ${tarefa.paciente_id})">
                                                        <i class="bi bi-check"></i> Concluir
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
                <div class="card-footer">
                    <div class="d-flex justify-content-between align-items-center">
                        <small class="text-muted">
                            <i class="bi bi-info-circle"></i> ${tarefasPendentes.length} tarefas pendentes
                        </small>
                        <button class="btn btn-sm btn-outline-primary" onclick="window.modules.dashboard.mostrarDashboard(window.appState)">
                            <i class="bi bi-speedometer2"></i> Voltar ao Dashboard
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;
}

// Funções auxiliares
function getCorPrioridade(prioridade) {
    const cores = {
        'alta': 'danger',
        'media': 'warning',
        'baixa': 'success'
    };
    return cores[prioridade] || 'secondary';
}

function calcularTempoRestante(dataString) {
    if (!dataString) return '';
    
    try {
        const data = new Date(dataString);
        const agora = new Date();
        const diffMs = data - agora;
        
        if (diffMs < 0) {
            const horasAtraso = Math.abs(Math.floor(diffMs / (1000 * 60 * 60)));
            return `${horasAtraso}h atrasada`;
        } else {
            const horas = Math.floor(diffMs / (1000 * 60 * 60));
            if (horas < 1) {
                const minutos = Math.floor(diffMs / (1000 * 60));
                return `em ${minutos} minutos`;
            } else if (horas < 24) {
                return `em ${horas} horas`;
            } else {
                const dias = Math.floor(horas / 24);
                return `em ${dias} dias`;
            }
        }
    } catch (e) {
        return '';
    }
}

// Exportar para escopo global
if (typeof window !== 'undefined') {
    if (!window.modules) window.modules = {};
    window.modules.tarefas = {
        mostrarFormularioNovaTarefa,
        salvarNovaTarefa,
        alternarStatusTarefa,
        excluirTarefa,
        mostrarTodasTarefasPendentes
    };
    
    // Exportar funções auxiliares
    window.mostrarCamposAdicionais = mostrarCamposAdicionais;
    window.getCorPrioridade = getCorPrioridade;
}