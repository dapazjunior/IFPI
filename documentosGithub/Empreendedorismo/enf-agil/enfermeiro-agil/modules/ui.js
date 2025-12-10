// modules/ui.js - Funções de interface do usuário

// Função para mostrar tela de login
export function mostrarTelaLogin(mainContentElement) {
    if (!mainContentElement) return;
    
    mainContentElement.innerHTML = `
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card">
                    <div class="card-header text-center bg-primary text-white">
                        <h4 class="mb-0">Entrar no Sistema</h4>
                    </div>
                    <div class="card-body">
                        <form id="loginForm" onsubmit="event.preventDefault(); window.fazerLoginApp(
                            document.getElementById('loginEmail').value,
                            document.getElementById('loginSenha').value
                        )">
                            <div class="mb-3">
                                <label class="form-label">E-mail</label>
                                <input type="email" class="form-control" id="loginEmail" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Senha</label>
                                <input type="password" class="form-control" id="loginSenha" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-box-arrow-in-right"></i> Entrar
                            </button>
                        </form>
                        <div class="text-center mt-3">
                            <button class="btn btn-link" onclick="window.mostrarTelaCadastro()">
                                Criar nova conta
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `;
}

// Função para mostrar tela de cadastro
export function mostrarTelaCadastro(mainContentElement) {
    if (!mainContentElement) return;
    
    mainContentElement.innerHTML = `
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card">
                    <div class="card-header text-center bg-success text-white">
                        <h4 class="mb-0">Criar Nova Conta</h4>
                    </div>
                    <div class="card-body">
                        <form id="cadastroForm" onsubmit="event.preventDefault(); window.fazerCadastroApp(
                            document.getElementById('cadastroNome').value,
                            document.getElementById('cadastroEmail').value,
                            document.getElementById('cadastroSenha').value
                        )">
                            <div class="mb-3">
                                <label class="form-label">Nome Completo</label>
                                <input type="text" class="form-control" id="cadastroNome" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">E-mail</label>
                                <input type="email" class="form-control" id="cadastroEmail" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Senha</label>
                                <input type="password" class="form-control" id="cadastroSenha" required minlength="6">
                            </div>
                            <button type="submit" class="btn btn-success w-100">
                                <i class="bi bi-person-plus"></i> Criar Conta
                            </button>
                        </form>
                        <div class="text-center mt-3">
                            <button class="btn btn-link" onclick="window.mostrarTelaLogin()">
                                Já tenho uma conta
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `;
}

// Função para mostrar loading
export function mostrarLoading(mensagem = 'Carregando...') {
    return `
        <div class="loading-container">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Carregando...</span>
            </div>
            <p class="mt-3 text-muted">${mensagem}</p>
        </div>
    `;
}

// Exportar para escopo global
if (typeof window !== 'undefined') {
    window.mostrarTelaLogin = (elementId = 'mainContent') => {
        const element = document.getElementById(elementId);
        if (element) mostrarTelaLogin(element);
    };
    
    window.mostrarTelaCadastro = (elementId = 'mainContent') => {
        const element = document.getElementById(elementId);
        if (element) mostrarTelaCadastro(element);
    };
}