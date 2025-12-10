import { verificarSessao, fazerLogout } from './modules/auth.js';
import { carregarPacientes, cadastrarPaciente, buscarPacientePorId, excluirPaciente, compartilharPaciente, carregarAcessosDePaciente } from './modules/pacientes.js';
import { carregarTarefas, cadastrarTarefa, alternarTarefa, excluirTarefa, carregarTodasTarefasPendentes } from './modules/tarefas.js';

// Estado Global Simples
let estado = {
    usuario: null,
    pacienteAtual: null,
    pacientes: []
};

// Elementos DOM
const views = {
    dashboard: document.getElementById('view-dashboard'),
    detalhes: document.getElementById('view-detalhes')
};

// --- INICIALIZAÇÃO ---
window.onload = async () => {
    try {
        const { data: session } = await verificarSessao();
        if (!session) {
            window.location.href = 'login.html';
            return;
        }
        estado.usuario = session.user;
        await initDashboard();
    } catch (error) {
        console.error("Erro no init:", error);
    } finally {
        document.getElementById('loading').classList.add('hidden');
    }
};

// --- FUNÇÕES DE NAVEGAÇÃO ---
function showView(viewName) {
    Object.values(views).forEach(el => el.classList.add('hidden'));
    views[viewName].classList.remove('hidden');
}

document.getElementById('btnVoltarDashboard').addEventListener('click', () => {
    initDashboard(); // Recarrega dados ao voltar
    showView('dashboard');
});

document.getElementById('btnLogout').addEventListener('click', async () => {
    await fazerLogout();
    window.location.href = 'login.html';
});

// --- DASHBOARD ---
async function initDashboard() {
    showView('dashboard');
    estado.pacienteAtual = null;

    // Carregar Pacientes
    const { data: pacientes, error } = await carregarPacientes();
    if (error) return alert('Erro ao carregar pacientes: ' + error.message);
    
    estado.pacientes = pacientes || [];
    renderPacientesList(estado.pacientes);
    updateStats(estado.pacientes);

    // Carregar Sidebar de Tarefas
    loadSidebarTarefas();
}

function renderPacientesList(lista) {
    const container = document.getElementById('containerPacientes');
    container.innerHTML = '';

    if (lista.length === 0) {
        container.innerHTML = '<div class="col-12 text-center text-muted mt-5"><p>Nenhum paciente cadastrado.</p></div>';
        return;
    }

    lista.forEach(p => {
        const div = document.createElement('div');
        div.className = 'col-md-6 col-lg-4 mb-4';
        div.innerHTML = `
            <div class="card card-patient h-100 border-left-${p.prioridade}">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <h5 class="card-title text-truncate">${p.nome}</h5>
                        <small class="text-muted">${p.permissao_do_usuario === 'dono' ? '👑' : '🔗'}</small>
                    </div>
                    <h6 class="card-subtitle mb-2 text-muted">Leito: ${p.leito}</h6>
                    <span class="badge badge-${p.prioridade}">${p.prioridade.toUpperCase()}</span>
                    <p class="card-text mt-2 small text-muted text-truncate">${p.observacoes || 'Sem observações'}</p>
                </div>
            </div>
        `;
        // Evento de Click no Card
        div.querySelector('.card').addEventListener('click', () => abrirDetalhesPaciente(p.id));
        container.appendChild(div);
    });
}

function updateStats(pacientes) {
    document.getElementById('statTotalPacientes').innerText = pacientes.length;
    const altas = pacientes.filter(p => p.prioridade === 'alta').length;
    document.getElementById('statAlta').innerText = altas;
}

async function loadSidebarTarefas() {
    const ul = document.getElementById('listaTarefasSidebar');
    const statTarefas = document.getElementById('statTarefas');
    ul.innerHTML = '<li class="list-group-item small text-muted">Atualizando...</li>';

    const { data: tarefas } = await carregarTodasTarefasPendentes();
    
    ul.innerHTML = '';
    statTarefas.innerText = tarefas ? tarefas.length : 0;

    if (!tarefas || tarefas.length === 0) {
        ul.innerHTML = '<li class="list-group-item small text-muted">Nenhuma pendência.</li>';
        return;
    }

    tarefas.forEach(t => {
        const li = document.createElement('li');
        li.className = 'list-group-item d-flex justify-content-between align-items-center small';
        li.innerHTML = `
            <div>
                <strong>${t.nome_paciente}</strong><br>
                ${t.descricao}
            </div>
            <button class="btn btn-sm btn-outline-success ms-2 check-btn"><i class="bi bi-check"></i></button>
        `;
        li.querySelector('.check-btn').addEventListener('click', async () => {
            await alternarTarefa(t.id, 'pendente');
            loadSidebarTarefas(); // Recarrega
            if(estado.pacienteAtual && estado.pacienteAtual.id === t.paciente_id) renderTarefasPaciente(t.paciente_id);
        });
        ul.appendChild(li);
    });
}

// --- DETALHES DO PACIENTE ---
async function abrirDetalhesPaciente(id) {
    document.getElementById('loading').classList.remove('hidden');
    
    const { data: paciente, error } = await buscarPacientePorId(id);
    if (error) {
        alert('Erro ao abrir paciente.');
        document.getElementById('loading').classList.add('hidden');
        return;
    }

    estado.pacienteAtual = paciente;

    // Preencher UI
    document.getElementById('detNome').innerText = paciente.nome;
    document.getElementById('detLeito').innerText = 'Leito ' + paciente.leito;
    document.getElementById('detObs').innerText = paciente.observacoes || 'Nenhuma observação.';
    
    const badgePrio = document.getElementById('detPrioridade');
    badgePrio.innerText = paciente.prioridade.toUpperCase();
    badgePrio.className = `badge badge-${paciente.prioridade}`;

    document.getElementById('detPermissao').innerText = paciente.permissao_do_usuario.toUpperCase();

    // Controle de Permissões (Esconder Botões)
    const permissao = paciente.permissao_do_usuario;
    const botoesAcao = document.querySelectorAll('.action-btn');
    
    botoesAcao.forEach(btn => {
        if (permissao === 'ver') {
            btn.classList.add('hidden'); // Quem só vê, não edita nada
        } else {
            btn.classList.remove('hidden');
        }
    });

    // Se não for dono nem total, esconde botão excluir paciente
    if (permissao !== 'dono' && permissao !== 'total') {
        document.getElementById('btnExcluirPaciente').classList.add('hidden');
    }

    await renderTarefasPaciente(id);
    showView('detalhes');
    document.getElementById('loading').classList.add('hidden');
}

async function renderTarefasPaciente(id) {
    const lista = document.getElementById('listaTarefasPaciente');
    lista.innerHTML = '<div class="text-center p-3">Carregando tarefas...</div>';

    const { data: tarefas } = await carregarTarefas(id);
    lista.innerHTML = '';

    if (!tarefas || tarefas.length === 0) {
        lista.innerHTML = '<div class="text-center p-3 text-muted">Nenhuma tarefa cadastrada.</div>';
        return;
    }

    tarefas.forEach(t => {
        const item = document.createElement('div');
        const concluida = t.status === 'concluida';
        item.className = `list-group-item d-flex justify-content-between align-items-center ${concluida ? 'bg-light text-decoration-line-through text-muted' : ''}`;
        
        // Data formatada
        const hora = t.horario_previsto ? new Date(t.horario_previsto).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'}) : '--:--';

        item.innerHTML = `
            <div>
                <span class="badge bg-secondary me-2">${hora}</span>
                <span>${t.descricao}</span>
            </div>
            <div>
                ${!concluida ? `<button class="btn btn-sm btn-success me-1 btn-concluir"><i class="bi bi-check-lg"></i></button>` : `<button class="btn btn-sm btn-outline-secondary me-1 btn-concluir"><i class="bi bi-arrow-counterclockwise"></i></button>`}
                ${estado.pacienteAtual.permissao_do_usuario !== 'ver' ? `<button class="btn btn-sm btn-outline-danger btn-excluir"><i class="bi bi-trash"></i></button>` : ''}
            </div>
        `;

        // Ações da Tarefa
        const btnConcluir = item.querySelector('.btn-concluir');
        if(btnConcluir) {
            btnConcluir.addEventListener('click', async () => {
                await alternarTarefa(t.id, t.status);
                renderTarefasPaciente(id);
                loadSidebarTarefas();
            });
        }

        const btnExcluir = item.querySelector('.btn-excluir');
        if(btnExcluir) {
            btnExcluir.addEventListener('click', async () => {
                if(confirm('Excluir esta tarefa?')) {
                    await excluirTarefa(t.id);
                    renderTarefasPaciente(id);
                    loadSidebarTarefas();
                }
            });
        }

        lista.appendChild(item);
    });
}

// --- FORMS & MODALS ---

// 1. Novo Paciente
document.getElementById('formNovoPaciente').addEventListener('submit', async (e) => {
    e.preventDefault();
    const dados = {
        nome: document.getElementById('npNome').value,
        leito: document.getElementById('npLeito').value,
        prioridade: document.getElementById('npPrioridade').value,
        observacoes: document.getElementById('npObs').value
    };
    
    const { error } = await cadastrarPaciente(dados);
    if(error) alert('Erro: ' + error.message);
    else {
        // Fechar modal bootstrap
        const modal = bootstrap.Modal.getInstance(document.getElementById('modalNovoPaciente'));
        modal.hide();
        document.getElementById('formNovoPaciente').reset();
        initDashboard(); // Recarrega
    }
});

// 2. Nova Tarefa
document.getElementById('formNovaTarefa').addEventListener('submit', async (e) => {
    e.preventDefault();
    if(!estado.pacienteAtual) return;

    const dados = {
        paciente_id: estado.pacienteAtual.id,
        descricao: document.getElementById('ntDescricao').value,
        horario_previsto: document.getElementById('ntHorario').value
    };

    const { error } = await cadastrarTarefa(dados);
    if(error) alert('Erro: ' + error.message);
    else {
        const modal = bootstrap.Modal.getInstance(document.getElementById('modalNovaTarefa'));
        modal.hide();
        document.getElementById('formNovaTarefa').reset();
        renderTarefasPaciente(estado.pacienteAtual.id);
        loadSidebarTarefas();
    }
});

// 3. Compartilhar
const modalCompartilharEl = document.getElementById('modalCompartilhar');
modalCompartilharEl.addEventListener('show.bs.modal', async () => {
    // Carregar lista de acessos ao abrir o modal
    const listaUl = document.getElementById('listaAcessos');
    listaUl.innerHTML = '<li>Carregando...</li>';
    if(estado.pacienteAtual) {
        const { data } = await carregarAcessosDePaciente(estado.pacienteAtual.id);
        listaUl.innerHTML = '';
        if(data && data.length > 0) {
            data.forEach(acc => {
                listaUl.innerHTML += `<li>Usuário ID: ...${acc.usuario_id.slice(-4)} (${acc.permissao})</li>`;
            });
        } else {
            listaUl.innerHTML = '<li class="text-muted">Ninguém além de você.</li>';
        }
    }
});

document.getElementById('formCompartilhar').addEventListener('submit', async (e) => {
    e.preventDefault();
    if(!estado.pacienteAtual) return;

    const email = document.getElementById('compEmail').value;
    const permissao = document.getElementById('compPermissao').value;
    const btn = e.target.querySelector('button');
    
    btn.disabled = true; 
    btn.innerText = 'Compartilhando...';

    const { error } = await compartilharPaciente(email, estado.pacienteAtual.id, permissao);
    
    btn.disabled = false; 
    btn.innerText = 'Compartilhar';

    if(error) alert(error.message);
    else {
        alert(`Paciente compartilhado com ${email}!`);
        const modal = bootstrap.Modal.getInstance(modalCompartilharEl);
        modal.hide();
        document.getElementById('formCompartilhar').reset();
    }
});

// 4. Excluir Paciente
document.getElementById('btnExcluirPaciente').addEventListener('click', async () => {
    if(confirm('Tem certeza que deseja excluir este paciente e todas as tarefas?')) {
        const { error } = await excluirPaciente(estado.pacienteAtual.id);
        if(error) alert('Erro: ' + error.message);
        else {
            initDashboard();
        }
    }
});