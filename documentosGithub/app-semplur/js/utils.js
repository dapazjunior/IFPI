import { showToast as appShowToast } from './app.js';

// Configuração do sistema de toast
export function setupToast() {
  // Remover toasts antigos se existirem
  const oldToasts = document.querySelectorAll('.toast-notice');
  oldToasts.forEach(toast => toast.remove());
}

export function showToast(message, type = 'info') {
  const colors = {
    success: '#198754',
    danger: '#dc3545',
    warning: '#ffc107',
    info: '#0dcaf0',
    primary: '#0d6efd',
    secondary: '#6c757d'
  };

  const icons = {
    success: 'bi-check-circle',
    danger: 'bi-exclamation-circle',
    warning: 'bi-exclamation-triangle',
    info: 'bi-info-circle',
    primary: 'bi-info-circle',
    secondary: 'bi-info-circle'
  };

  // Criar elemento toast
  const el = document.createElement('div');
  el.className = 'toast-notice';
  el.style.backgroundColor = colors[type] || colors.info;
  el.innerHTML = `
    <div class="toast-content">
      <i class="bi ${icons[type] || 'bi-info-circle'} me-2"></i>
      ${escapeHtml(message)}
    </div>
  `;
  
  document.body.appendChild(el);
  
  // Animação de entrada
  requestAnimationFrame(() => {
    el.style.opacity = '1';
    el.style.transform = 'translateY(0) scale(1)';
  });
  
  // Remover após 3.5 segundos
  setTimeout(() => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(100px) scale(0.9)';
    setTimeout(() => el.remove(), 300);
  }, 3500);
}

// Função para formatar datas
export function formatDate(date, includeTime = true) {
  if (!date) return '-';
  
  const d = new Date(date);
  const dateStr = d.toLocaleDateString('pt-BR');
  
  if (!includeTime) return dateStr;
  
  const timeStr = d.toLocaleTimeString('pt-BR', { 
    hour: '2-digit', 
    minute: '2-digit' 
  });
  
  return `${dateStr} ${timeStr}`;
}

// Função para formatar tamanho de arquivo
export function formatFileSize(bytes) {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

// Função para escapar HTML
export function escapeHtml(str) {
  if (str === null || str === undefined) return '';
  return String(str)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;');
}

// Função para debounce (evitar múltiplas chamadas)
export function debounce(func, wait) {
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

// Função para throttle (limitar frequência)
export function throttle(func, limit) {
  let inThrottle;
  return function() {
    const args = arguments;
    const context = this;
    if (!inThrottle) {
      func.apply(context, args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}

// Validação de email
export function isValidEmail(email) {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return re.test(email);
}

// Validação de CPF (simplificada)
export function isValidCPF(cpf) {
  cpf = cpf.replace(/[^\d]+/g, '');
  if (cpf.length !== 11) return false;
  
  // Elimina CPFs com todos os dígitos iguais
  if (/^(\d)\1+$/.test(cpf)) return false;
  
  // Validação dos dígitos verificadores
  let sum = 0;
  for (let i = 0; i < 9; i++) {
    sum += parseInt(cpf.charAt(i)) * (10 - i);
  }
  let remainder = 11 - (sum % 11);
  if (remainder === 10 || remainder === 11) remainder = 0;
  if (remainder !== parseInt(cpf.charAt(9))) return false;
  
  sum = 0;
  for (let i = 0; i < 10; i++) {
    sum += parseInt(cpf.charAt(i)) * (11 - i);
  }
  remainder = 11 - (sum % 11);
  if (remainder === 10 || remainder === 11) remainder = 0;
  if (remainder !== parseInt(cpf.charAt(10))) return false;
  
  return true;
}

// Máscara para CPF
export function maskCPF(cpf) {
  return cpf.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
}

// Máscara para telefone
export function maskPhone(phone) {
  phone = phone.replace(/\D/g, '');
  if (phone.length === 11) {
    return phone.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
  } else if (phone.length === 10) {
    return phone.replace(/(\d{2})(\d{4})(\d{4})/, '($1) $2-$3');
  }
  return phone;
}

// Gerar ID único
export function generateId() {
  return Date.now().toString(36) + Math.random().toString(36).substr(2);
}

// Download de arquivo
export function downloadFile(url, filename) {
  const link = document.createElement('a');
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

// Copiar para área de transferência
export async function copyToClipboard(text) {
  try {
    await navigator.clipboard.writeText(text);
    return true;
  } catch (err) {
    console.error('Erro ao copiar para clipboard:', err);
    return false;
  }
}

// Verificar se é mobile
export function isMobile() {
  return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

// Capitalizar primeira letra
export function capitalize(str) {
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}

// Remover acentos
export function removeAccents(str) {
  return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
}

// Formatar moeda brasileira
export function formatCurrency(value) {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL'
  }).format(value);
}

// Sleep function
export function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}