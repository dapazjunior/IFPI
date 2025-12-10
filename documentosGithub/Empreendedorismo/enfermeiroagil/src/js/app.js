// Arquivo principal do aplicativo
import authService from './modules/auth.js';
import { APP_CONSTANTS, UTILS } from './config/constants.js';

// Verificar autenticação em páginas protegidas
function checkAuth() {
  const protectedPages = [
    'dashboard.html',
    'patients',
    'medications',
    'ai-assistant',
    'protocols',
    'settings'
  ];
  
  const currentPath = window.location.pathname;
  
  // Verificar se está em uma página protegida
  const isProtectedPage = protectedPages.some(page => currentPath.includes(page));
  
  if (isProtectedPage && !authService.isAuthenticated()) {
    authService.redirectToLogin();
  }
}

// Inicializar aplicação
async function initApp() {
  try {
    // Inicializar auth
    await authService.init();
    
    // Verificar autenticação
    checkAuth();
    
    // Carregar dados do usuário se autenticado
    if (authService.isAuthenticated()) {
      await loadUserData();
      setupProtectedFeatures();
    }
    
    // Configurar listeners gerais
    setupEventListeners();
    
    console.log('Aplicação inicializada com sucesso');
    
  } catch (error) {
    console.error('Erro ao inicializar aplicação:', error);
  }
}

// Carregar dados do usuário
async function loadUserData() {
  try {
    const user = authService.getUser();
    const profile = authService.getUserProfile();
    
    if (user) {
      // Atualizar UI com dados do usuário
      updateUserUI(user, profile);
    }
    
  } catch (error) {
    console.error('Erro ao carregar dados do usuário:', error);
  }
}

// Atualizar UI com dados do usuário
function updateUserUI(user, profile) {
  // Atualizar nome do usuário
  const userNameElements = document.querySelectorAll('.user-name');
  userNameElements.forEach(el => {
    if (profile?.full_name) {
      el.textContent = profile.full_name;
    } else if (user.email) {
      el.textContent = user.email.split('@')[0];
    }
  });
  
  // Atualizar role
  const userRoleElements = document.querySelectorAll('.user-role');
  userRoleElements.forEach(el => {
    if (profile?.role) {
      const roleNames = {
        'enfermeiro': 'Enfermeiro(a)',
        'tecnico': 'Técnico(a) de Enfermagem',
        'estudante': 'Estudante de Enfermagem',
        'admin': 'Administrador'
      };
      el.textContent = roleNames[profile.role] || profile.role;
    }
  });
}

// Configurar funcionalidades protegidas
function setupProtectedFeatures() {
  // Logout button
  const logoutButtons = document.querySelectorAll('.logout-btn');
  logoutButtons.forEach(button => {
    button.addEventListener('click', async (e) => {
      e.preventDefault();
      await authService.logout();
    });
  });
  
  // Sidebar toggle para mobile
  const sidebarToggle = document.querySelector('.sidebar-toggle');
  const sidebar = document.querySelector('.sidebar');
  
  if (sidebarToggle && sidebar) {
    sidebarToggle.addEventListener('click', () => {
      sidebar.classList.toggle('show');
    });
  }
}

// Configurar listeners gerais
function setupEventListeners() {
  // Fechar alertas automaticamente
  const alerts = document.querySelectorAll('.alert-auto-dismiss');
  alerts.forEach(alert => {
    setTimeout(() => {
      alert.style.opacity = '0';
      setTimeout(() => alert.remove(), 300);
    }, 5000);
  });
  
  // Formulários com validação
  const forms = document.querySelectorAll('form[data-validate]');
  forms.forEach(form => {
    form.addEventListener('submit', function(e) {
      if (!validateForm(this)) {
        e.preventDefault();
      }
    });
  });
}

// Validação de formulário genérica
function validateForm(form) {
  let isValid = true;
  const inputs = form.querySelectorAll('[required]');
  
  inputs.forEach(input => {
    if (!input.value.trim()) {
      input.classList.add('is-invalid');
      isValid = false;
    } else {
      input.classList.remove('is-invalid');
    }
  });
  
  return isValid;
}

// Funções globais disponíveis
window.EnfermeiroAgil = {
  auth: authService,
  utils: UTILS,
  constants: APP_CONSTANTS,
  
  // Helper para mostrar loading
  showLoading: () => {
    const loader = document.getElementById('global-loader');
    if (loader) loader.style.display = 'flex';
  },
  
  hideLoading: () => {
    const loader = document.getElementById('global-loader');
    if (loader) loader.style.display = 'none';
  },
  
  // Helper para mostrar mensagens
  showAlert: (message, type = 'info') => {
    const alert = document.createElement('div');
    alert.className = `alert-custom alert-custom-${type} alert-auto-dismiss`;
    alert.textContent = message;
    
    const container = document.querySelector('.alerts-container') || document.body;
    container.insertBefore(alert, container.firstChild);
  }
};

// Inicializar quando o DOM estiver pronto
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initApp);
} else {
  initApp();
}