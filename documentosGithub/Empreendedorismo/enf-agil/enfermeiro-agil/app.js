// app.js - Script principal ATUALIZADO
import { supabase } from './supabaseClient.js';
import { fazerLogin, fazerCadastro, fazerLogout, verificarSessao } from './auth.js';
import { carregarPacientes, cadastrarPaciente, excluirPaciente } from './pacientes.js';
import { carregarTarefas, cadastrarTarefa, alternarTarefa, excluirTarefa, carregarTodasTarefasPendentes } from './tarefas.js';

// Importar módulos de UI
import * as ui from './modules/ui.js';
import * as dashboard from './modules/dashboard.js';
import * as pacientesUI from './modules/pacientesUI.js';
import * as tarefasUI from './modules/tarefasUI.js';
import * as uiHelpers from './modules/ui-helpers.js';

// Estado da aplicação
let appState = {
    usuario: null,
    pacientes: [],
    tarefasPendentes: [],
    currentView: 'dashboard',
    currentPatient: null,
    isLoading: true
};

// Exportar para escopo global
window.supabase = supabase;
window.appState = appState;

// Inicializar aplicação
document.addEventListener('DOMContentLoaded', async () => {
    console.log('🚀 Enfermeiro Ágil - Inicializando...');
    
    try {
        // Verificar sessão
        const sessao = await verificarSessao();
        
        if (sessao.user) {
            appState.usuario = sessao.user;
            console.log('✅ Usuário logado:', appState.usuario.nome);
            await inicializarApp();
        } else {
            console.log('ℹ️ Usuário não logado');
            ui.mostrarTelaLogin('mainContent');
        }
    } catch (error) {
        console.error('❌ Erro ao inicializar:', error);
        ui.mostrarTelaLogin('mainContent');
    }
});

// Inicializar app logado
async function inicializarApp() {
    try {
        // Mostrar loading
        const mainContent = document.getElementById('mainContent');
        if (mainContent) {
            mainContent.innerHTML = uiHelpers.mostrarLoading('Carregando sistema...');
        }
        
        // Carregar dados
        await carregarDados();
        
        // Renderizar interface
        renderizarHeader();
        renderizarSidebar();
        dashboard.mostrarDashboard(appState);
        
        appState.isLoading = false;
    } catch (error) {
        console.error('❌ Erro ao inicializar app:', error);
        mostrarMensagem('Erro ao carregar dados do sistema', 'error');
    }
}

// Carregar dados
async function carregarDados() {
    console.log('📥 Carregando dados do sistema...');
    
    try {
        // Carregar pacientes
        appState.pacientes = await carregarPacientes();
        console.log(`✅ ${appState.pacientes.length} pacientes carregados`);
        
        // Carregar tarefas pendentes
        appState.tarefasPendentes = await carregarTodasTarefasPendentes();
        console.log(`✅ ${appState.tarefasPendentes.length} tarefas pendentes`);
    } catch (error) {
        console.error('❌ Erro ao carregar dados:', error);
        throw error;
    }
}

// Funções de UI
function renderizarHeader() {
    const headerActions = document.getElementById('headerActions');
    if (!headerActions) return;
    
    if (appState.usuario) {
        headerActions.innerHTML = `
            <div class="d-flex align-items-center gap-3">
                <span class="text-dark">
                    <i class="bi bi-person-circle me-1"></i>
                    ${appState.usuario.nome}
                </span>
                <button class="btn btn-outline-danger btn-sm" onclick="fazerLogoutApp()">
                    <i class="bi bi-box-arrow-right"></i> Sair
                </button>
            </div>
        `;
    } else {
        headerActions.innerHTML = `
            <div class="d-flex gap-2">
                <button class="btn btn-outline-primary btn-sm" onclick="ui.mostrarTelaLogin('mainContent')">
                    Entrar
                </button>
                <button class="btn btn-primary btn-sm" onclick="ui.mostrarTelaCadastro('mainContent')">
                    Cadastrar
                </button>
            </div>
        `;
    }
}

function renderizarSidebar() {
    const tasksList = document.getElementById('tasksList');
    if (!tasksList) return;
    
    if (!appState.usuario) {
        tasksList.innerHTML = `
            <div class="text-center p-4 text-muted">
                <i class="bi bi-person-lock fs-1"></i>
                <p class="mt-2">Faça login para ver as tarefas</p>
            </div>
        `;
        return;
    }
    
    if (appState.tarefasPendentes.length === 0) {
        tasksList.innerHTML = `
            <div class="text-center p-4 text-muted">
                <i class="bi bi-check-circle fs-1"></i>
                <p class="mt-2">Nenhuma tarefa pendente</p>
                <small>Todas as tarefas estão em dia! 🎉</small>
            </div>
        `;
        return;
    }
    
    tasksList.innerHTML = `
        <div class="list-group list-group-flush">
            ${appState.tarefasPendentes.map(tarefa => {
                const prioridade = tarefa.pacientes?.prioridade || 'baixa';
                return `
                    <div class="list-group-item list-group-item-action sidebar-task-item ${prioridade}" 
                         onclick="pacientesUI.mostrarDetalhesPaciente(${tarefa.paciente_id})"
                         style="cursor: pointer;">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="flex-grow-1">
                                <small class="text-muted d-block">
                                    <i class="bi bi-person"></i> ${tarefa.pacientes?.nome || 'Paciente'}
                                </small>
                                <strong class="d-block">${tarefa.descricao}</strong>
                                ${tarefa.horario_previsto ? `
                                    <small class="text-muted">
                                        <i class="bi bi-clock"></i> 
                                        ${uiHelpers.formatarData(tarefa.horario_previsto)}
                                    </small>
                                ` : ''}
                            </div>
                            <div class="text-end">
                                <span class="badge bg-${uiHelpers.getCorPrioridade(prioridade)}">
                                    ${prioridade.toUpperCase()}
                                </span>
                            </div>
                        </div>
                    </div>
                `;
            }).join('')}
        </div>
    `;
}

// Funções de autenticação
async function fazerLoginApp(email, senha) {
    try {
        const resultado = await fazerLogin(email, senha);
        
        if (resultado.erro) {
            mostrarMensagem('Erro: ' + resultado.erro, 'error');
            return false;
        }
        
        appState.usuario = resultado.user;
        mostrarMensagem('Login realizado! Bem-vindo ' + appState.usuario.nome, 'success');
        await inicializarApp();
        return true;
    } catch (error) {
        console.error('❌ Erro no login:', error);
        mostrarMensagem('Erro ao fazer login', 'error');
        return false;
    }
}

async function fazerCadastroApp(nome, email, senha) {
    try {
        const resultado = await fazerCadastro(nome, email, senha);
        
        if (resultado.erro) {
            mostrarMensagem('Erro no cadastro: ' + resultado.erro, 'error');
            return false;
        }
        
        mostrarMensagem('Cadastro realizado com sucesso!', 'success');
        ui.mostrarTelaLogin('mainContent');
        return true;
    } catch (error) {
        console.error('❌ Erro no cadastro:', error);
        mostrarMensagem('Erro ao cadastrar', 'error');
        return false;
    }
}

async function fazerLogoutApp() {
    try {
        const resultado = await fazerLogout();
        
        if (resultado.erro) {
            mostrarMensagem('Erro ao fazer logout: ' + resultado.erro, 'error');
        } else {
            mostrarMensagem('Logout realizado com sucesso!', 'info');
            // Redirecionar para index.html
            window.location.href = 'index.html';
        }
    } catch (error) {
        console.error('❌ Erro no logout:', error);
        mostrarMensagem('Erro ao fazer logout', 'error');
    }
}

// Função para mostrar mensagens
function mostrarMensagem(texto, tipo = 'info') {
    console.log(`📢 ${tipo}: ${texto}`);
    
    const toastElement = document.getElementById('liveToast');
    const toastMessage = document.getElementById('toastMessage');
    
    if (toastElement && toastMessage && bootstrap && bootstrap.Toast) {
        const toastHeader = toastElement.querySelector('.toast-header i');
        if (toastHeader) {
            if (tipo === 'success') {
                toastHeader.className = 'bi bi-check-circle text-success me-2';
            } else if (tipo === 'error' || tipo === 'danger') {
                toastHeader.className = 'bi bi-exclamation-triangle text-danger me-2';
            } else if (tipo === 'warning') {
                toastHeader.className = 'bi bi-exclamation-triangle text-warning me-2';
            } else {
                toastHeader.className = 'bi bi-info-circle text-primary me-2';
            }
        }
        
        toastMessage.textContent = texto;
        const toast = new bootstrap.Toast(toastElement);
        toast.show();
    } else {
        alert(texto);
    }
}

// Exportar funções para escopo global
window.fazerLoginApp = fazerLoginApp;
window.fazerCadastroApp = fazerCadastroApp;
window.fazerLogoutApp = fazerLogoutApp;
window.mostrarMensagem = mostrarMensagem;
window.renderizarSidebar = renderizarSidebar;
window.renderizarHeader = renderizarHeader;

// Exportar módulos
window.ui = ui;
window.dashboard = dashboard;
window.pacientesUI = pacientesUI;
window.tarefasUI = tarefasUI;
window.uiHelpers = uiHelpers;

// Exportar funções do backend
window.carregarPacientes = carregarPacientes;
window.cadastrarPaciente = cadastrarPaciente;
window.excluirPaciente = excluirPaciente;
window.carregarTarefas = carregarTarefas;
window.cadastrarTarefa = cadastrarTarefa;
window.alternarTarefa = alternarTarefa;
window.excluirTarefa = excluirTarefa;
window.carregarTodasTarefasPendentes = carregarTodasTarefasPendentes;

console.log('✅ app.js carregado com sucesso!');