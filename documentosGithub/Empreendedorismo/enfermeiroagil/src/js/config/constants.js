// Constantes do aplicativo Enfermeiro Ágil
export const APP_CONSTANTS = {
  // Informações do app
  APP_NAME: 'Enfermeiro Ágil',
  APP_VERSION: '1.0.0',
  
  // Roles de usuário
  ROLES: {
    NURSE: 'enfermeiro',
    TECH: 'tecnico',
    STUDENT: 'estudante',
    ADMIN: 'admin'
  },
  
  // Prioridades
  PRIORITIES: {
    HIGH: 'alta',
    MEDIUM: 'media',
    LOW: 'baixa'
  },
  
  // Tipos de anotações
  NOTE_TYPES: {
    EVOLUTION: 'evolucao',
    MEDICATION: 'medicacao',
    PROCEDURE: 'procedimento',
    OBSERVATION: 'observacao'
  },
  
  // Cores
  COLORS: {
    PRIMARY: '#1a73e8',
    PRIMARY_DARK: '#0d47a1',
    PRIMARY_LIGHT: '#e8f0fe',
    SECONDARY: '#4caf50',
    DANGER: '#f44336',
    WARNING: '#ff9800',
    INFO: '#17a2b8',
    SUCCESS: '#28a745'
  },
  
  // Configurações
  DEFAULT_PAGE_SIZE: 10,
  AUTO_SAVE_DELAY: 3000,
  SESSION_TIMEOUT: 30 // minutos
};

// Funções utilitárias
export const UTILS = {
  formatDate: (date) => {
    if (!date) return '';
    const d = new Date(date);
    return d.toLocaleDateString('pt-BR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  },
  
  formatTime: (date) => {
    if (!date) return '';
    const d = new Date(date);
    return d.toLocaleTimeString('pt-BR', {
      hour: '2-digit',
      minute: '2-digit'
    });
  },
  
  getPriorityColor: (priority) => {
    const colors = {
      'alta': '#dc3545',
      'media': '#ffc107',
      'baixa': '#28a745'
    };
    return colors[priority] || '#6c757d';
  },
  
  getPriorityText: (priority) => {
    const texts = {
      'alta': 'Alta Prioridade',
      'media': 'Média Prioridade',
      'baixa': 'Baixa Prioridade'
    };
    return texts[priority] || 'Não definida';
  },
  
  validateEmail: (email) => {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  },
  
  debounce: (func, wait) => {
    let timeout;
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }
};