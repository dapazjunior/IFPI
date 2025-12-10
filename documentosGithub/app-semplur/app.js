// app.js - Arquivo principal atualizado
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm';
import { 
  setupAuth, 
  handleLogin, 
  handleLogout, 
  checkAuth,
  loginSuccess 
} from './js/auth.js';

import { loadDocumentsModule } from './js/documents.js';
import { loadComplaintsModule } from './js/complaints.js';
import { loadAdminModule } from './js/admin.js';
import { showToast } from './js/utils.js';

// Configuração do Supabase
const SUPABASE_URL = 'https://legtaeqfjnwwmndqaffb.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxlZ3RhZXFmam53d21uZHFhZmZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ3NjcxMDUsImV4cCI6MjA4MDM0MzEwNX0.uup1pp4PFZZ_1lxgi1VJToxoNmnzHrIzmKFRUwRvyF8';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
export let currentUser = null;
export let currentUserId = null;
export let isAdmin = false;

// Inicialização da aplicação
document.addEventListener('DOMContentLoaded', async () => {
  console.log('Sistema SEMPLUR - Inicializando...');
  
  // Verificar autenticação
  const isAuthenticated = await checkAuth();
  
  if (isAuthenticated) {
    console.log('Usuário autenticado, iniciando dashboard...');
    await initializeDashboard();
  } else {
    console.log('Usuário não autenticado, mostrando login...');
    setupLoginPage();
  }
});

async function initializeDashboard() {
  try {
    console.log('Inicializando dashboard...');
    
    // Carregar navbar
    await loadNavbar();
    
    // Determinar aba inicial baseada na hash da URL
    const hash = window.location.hash.substring(1);
    let initialTab = 'documents';
    
    if (hash === 'complaints' || hash === 'admin') {
      initialTab = hash;
    }
    
    // Ativar a aba correspondente
    const tabElement = document.getElementById(`${initialTab}-tab`);
    if (tabElement) {
      tabElement.click();
    }
    
    // Carregar conteúdo da aba inicial
    await loadTabContent(initialTab);
    
    // Configurar listeners de abas
    setupTabListeners();
    
    // Configurar atualização automática
    setupAutoRefresh();
    
    console.log('Dashboard inicializado com sucesso!');
    
  } catch (error) {
    console.error('Erro ao inicializar dashboard:', error);
    showToast('Erro ao carregar dashboard: ' + error.message, 'danger');
  }
}

function setupLoginPage() {
  console.log('Configurando página de login...');
  const loginForm = document.getElementById('loginForm');
  if (loginForm) {
    loginForm.addEventListener('submit', handleLogin);
  }
}

async function loadNavbar() {
  try {
    console.log('Carregando navbar...');
    
    // Se já temos um container para navbar, carregar o componente
    const navbarContainer = document.getElementById('navbar-container');
    if (navbarContainer) {
      try {
        const response = await fetch('components/navbar.html');
        if (!response.ok) throw new Error('Falha ao carregar navbar');
        const navbarHtml = await response.text();
        navbarContainer.innerHTML = navbarHtml;
      } catch (fetchError) {
        console.warn('Não foi possível carregar navbar externa, usando fallback');
        navbarContainer.innerHTML = `
          <nav class="navbar navbar-expand-lg navbar-dark bg-dark rounded-3 mb-4">
            <div class="container-fluid">
              <a class="navbar-brand fw-bold" href="dashboard.html">
                <i class="bi bi-shield-check me-2"></i>SEMPLUR - Fiscalização
              </a>
              <div class="navbar-nav ms-auto">
                <div class="nav-item dropdown">
                  <a class="nav-link dropdown-toggle text-white" href="#" role="button" data-bs-toggle="dropdown">
                    <i class="bi bi-person-circle me-1"></i>
                    <span id="currentUser">${currentUser || 'Usuário'}</span>
                  </a>
                  <ul class="dropdown-menu dropdown-menu-end">
                    ${isAdmin ? `
                      <li><a class="dropdown-item" href="#" id="userManagementBtn">
                        <i class="bi bi-people"></i> Gerenciar Usuários
                      </a></li>
                      <li><hr class="dropdown-divider"></li>
                    ` : ''}
                    <li><a class="dropdown-item" href="#" id="logoutBtn">
                      <i class="bi bi-box-arrow-right"></i> Sair
                    </a></li>
                  </ul>
                </div>
              </div>
            </div>
          </nav>
        `;
      }
      
      // Configurar eventos da navbar
      setTimeout(() => {
        const logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) {
          logoutBtn.addEventListener('click', handleLogout);
        }
        
        const userManagementBtn = document.getElementById('userManagementBtn');
        if (userManagementBtn && isAdmin) {
          userManagementBtn.addEventListener('click', () => {
            window.location.hash = '#admin';
            const adminTab = document.getElementById('admin-tab');
            if (adminTab) adminTab.click();
          });
        }
        
        // Atualizar nome do usuário
        const currentUserSpan = document.getElementById('currentUser');
        if (currentUserSpan) {
          currentUserSpan.textContent = currentUser || 'Usuário';
        }
      }, 100);
    }
    
  } catch (error) {
    console.error('Erro ao carregar navbar:', error);
  }
}

function setupTabListeners() {
  console.log('Configurando listeners das abas...');
  
  // Atualizar URL quando mudar de aba
  document.querySelectorAll('#mainTabs button[data-bs-toggle="tab"]').forEach(tab => {
    tab.addEventListener('shown.bs.tab', (event) => {
      const tabId = event.target.getAttribute('data-bs-target').substring(1);
      window.location.hash = tabId;
      
      // Carregar módulo correspondente
      loadTabContent(tabId);
    });
  });
}

async function loadTabContent(tabId) {
  try {
    console.log(`Carregando aba: ${tabId}`);
    
    // Mostrar/ocultar aba de admin baseado na permissão
    if (tabId === 'admin' && !isAdmin) {
      showToast('Acesso não autorizado à administração', 'warning');
      window.location.hash = 'documents';
      document.getElementById('documents-tab')?.click();
      return;
    }
    
    // Carregar conteúdo da aba
    switch(tabId) {
      case 'documents':
        await loadDocumentsModule();
        break;
      case 'complaints':
        await loadComplaintsModule();
        break;
      case 'admin':
        if (isAdmin) await loadAdminModule();
        break;
    }
    
  } catch (error) {
    console.error(`Erro ao carregar aba ${tabId}:`, error);
    showToast(`Erro ao carregar ${tabId}: ${error.message}`, 'danger');
  }
}

function setupAutoRefresh() {
  // Atualizar dados a cada 30 segundos
  setInterval(async () => {
    if (currentUserId) {
      try {
        const activeTab = document.querySelector('#mainTabs .nav-link.active');
        if (activeTab) {
          const tabId = activeTab.getAttribute('data-bs-target').substring(1);
          
          switch(tabId) {
            case 'documents':
              // Recarregar contadores e histórico
              await supabase.from('documents').select('*', { count: 'exact', head: true });
              break;
            case 'complaints':
              // Recarregar contadores de denúncias
              await supabase.from('complaints').select('*', { count: 'exact', head: true });
              break;
          }
        }
      } catch (error) {
        console.error('Erro na atualização automática:', error);
      }
    }
  }, 30000);
}

// Exportar funções para uso em outros módulos
export { showToast };