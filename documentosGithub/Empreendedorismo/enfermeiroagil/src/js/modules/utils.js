import { APP_CONSTANTS } from '../config/constants.js';

class UtilsService {
  constructor() {
    this.storagePrefix = 'enfermeiro-agil_';
  }

  // ===== STORAGE =====
  setLocalStorage(key, value) {
    try {
      const fullKey = this.storagePrefix + key;
      const data = JSON.stringify(value);
      localStorage.setItem(fullKey, data);
      return true;
    } catch (error) {
      console.error('Erro ao salvar no localStorage:', error);
      return false;
    }
  }

  getLocalStorage(key, defaultValue = null) {
    try {
      const fullKey = this.storagePrefix + key;
      const data = localStorage.getItem(fullKey);
      return data ? JSON.parse(data) : defaultValue;
    } catch (error) {
      console.error('Erro ao ler do localStorage:', error);
      return defaultValue;
    }
  }

  removeLocalStorage(key) {
    try {
      const fullKey = this.storagePrefix + key;
      localStorage.removeItem(fullKey);
      return true;
    } catch (error) {
      console.error('Erro ao remover do localStorage:', error);
      return false;
    }
  }

  clearLocalStorage() {
    try {
      // Remove apenas as chaves do nosso app
      Object.keys(localStorage).forEach(key => {
        if (key.startsWith(this.storagePrefix)) {
          localStorage.removeItem(key);
        }
      });
      return true;
    } catch (error) {
      console.error('Erro ao limpar localStorage:', error);
      return false;
    }
  }

  // ===== FORMATAÇÃO =====
  formatCurrency(value) {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: 'BRL'
    }).format(value);
  }

  formatPhone(phone) {
    if (!phone) return '';
    
    const cleaned = phone.replace(/\D/g, '');
    
    if (cleaned.length === 11) {
      return cleaned.replace(/^(\d{2})(\d{5})(\d{4})$/, '($1) $2-$3');
    } else if (cleaned.length === 10) {
      return cleaned.replace(/^(\d{2})(\d{4})(\d{4})$/, '($1) $2-$3');
    }
    
    return phone;
  }

  formatCPF(cpf) {
    if (!cpf) return '';
    
    const cleaned = cpf.replace(/\D/g, '');
    
    if (cleaned.length === 11) {
      return cleaned.replace(/^(\d{3})(\d{3})(\d{3})(\d{2})$/, '$1.$2.$3-$4');
    }
    
    return cpf;
  }

  formatTimeAgo(date) {
    const now = new Date();
    const past = new Date(date);
    const diffMs = now - past;
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMins / 60);
    const diffDays = Math.floor(diffHours / 24);
    
    if (diffMins < 1) return 'agora mesmo';
    if (diffMins < 60) return `há ${diffMins} minuto${diffMins !== 1 ? 's' : ''}`;
    if (diffHours < 24) return `há ${diffHours} hora${diffHours !== 1 ? 's' : ''}`;
    if (diffDays < 7) return `há ${diffDays} dia${diffDays !== 1 ? 's' : ''}`;
    
    return past.toLocaleDateString('pt-BR');
  }

  // ===== VALIDAÇÃO =====
  validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }

  validateCPF(cpf) {
    cpf = cpf.replace(/[^\d]+/g, '');
    
    if (cpf.length !== 11 || /^(\d)\1{10}$/.test(cpf)) {
      return false;
    }
    
    let sum = 0;
    let remainder;
    
    for (let i = 1; i <= 9; i++) {
      sum += parseInt(cpf.substring(i - 1, i)) * (11 - i);
    }
    
    remainder = (sum * 10) % 11;
    if (remainder === 10 || remainder === 11) remainder = 0;
    if (remainder !== parseInt(cpf.substring(9, 10))) return false;
    
    sum = 0;
    for (let i = 1; i <= 10; i++) {
      sum += parseInt(cpf.substring(i - 1, i)) * (12 - i);
    }
    
    remainder = (sum * 10) % 11;
    if (remainder === 10 || remainder === 11) remainder = 0;
    return remainder === parseInt(cpf.substring(10, 11));
  }

  validatePhone(phone) {
    const cleaned = phone.replace(/\D/g, '');
    return cleaned.length >= 10 && cleaned.length <= 11;
  }

  // ===== STRING =====
  capitalize(text) {
    return text
      .toLowerCase()
      .split(' ')
      .map(word => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' ');
  }

  truncate(text, maxLength = 100, suffix = '...') {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + suffix;
  }

  sanitizeHTML(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  // ===== DATES =====
  getCurrentDate() {
    return new Date().toISOString().split('T')[0];
  }

  getCurrentDateTime() {
    return new Date().toISOString();
  }

  formatDateForInput(date) {
    if (!date) return '';
    const d = new Date(date);
    return d.toISOString().split('T')[0];
  }

  formatTimeForInput(date) {
    if (!date) return '';
    const d = new Date(date);
    return d.toISOString().split('T')[1].substring(0, 5);
  }

  addDays(date, days) {
    const result = new Date(date);
    result.setDate(result.getDate() + days);
    return result;
  }

  // ===== ARRAYS E OBJETOS =====
  sortByProperty(array, property, ascending = true) {
    return array.sort((a, b) => {
      let aValue = a[property];
      let bValue = b[property];
      
      if (typeof aValue === 'string') {
        aValue = aValue.toLowerCase();
        bValue = bValue.toLowerCase();
      }
      
      if (aValue < bValue) return ascending ? -1 : 1;
      if (aValue > bValue) return ascending ? 1 : -1;
      return 0;
    });
  }

  groupBy(array, property) {
    return array.reduce((groups, item) => {
      const key = item[property];
      if (!groups[key]) {
        groups[key] = [];
      }
      groups[key].push(item);
      return groups;
    }, {});
  }

  deepClone(obj) {
    return JSON.parse(JSON.stringify(obj));
  }

  mergeObjects(target, source) {
    return { ...target, ...source };
  }

  // ===== UI HELPERS =====
  debounce(func, wait) {
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

  throttle(func, limit) {
    let inThrottle;
    return function executedFunction(...args) {
      if (!inThrottle) {
        func(...args);
        inThrottle = true;
        setTimeout(() => inThrottle = false, limit);
      }
    };
  }

  copyToClipboard(text) {
    return new Promise((resolve, reject) => {
      if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(text)
          .then(() => resolve(true))
          .catch(err => reject(err));
      } else {
        // Fallback para navegadores mais antigos
        const textArea = document.createElement('textarea');
        textArea.value = text;
        textArea.style.position = 'fixed';
        textArea.style.opacity = '0';
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        
        try {
          const successful = document.execCommand('copy');
          document.body.removeChild(textArea);
          successful ? resolve(true) : reject(new Error('Falha ao copiar'));
        } catch (err) {
          document.body.removeChild(textArea);
          reject(err);
        }
      }
    });
  }

  // ===== MÉDICAS/ENFERMAGEM =====
  calculateBMI(weight, height) {
    if (!weight || !height) return null;
    const heightInMeters = height / 100;
    return (weight / (heightInMeters * heightInMeters)).toFixed(1);
  }

  getBMICategory(bmi) {
    if (bmi < 18.5) return 'Abaixo do peso';
    if (bmi < 25) return 'Peso normal';
    if (bmi < 30) return 'Sobrepeso';
    if (bmi < 35) return 'Obesidade Grau I';
    if (bmi < 40) return 'Obesidade Grau II';
    return 'Obesidade Grau III';
  }

  calculateIdealWeight(height, gender = 'M') {
    const heightInMeters = height / 100;
    if (gender === 'F') {
      return (62.1 * heightInMeters - 44.7).toFixed(1);
    }
    return (72.7 * heightInMeters - 58).toFixed(1);
  }

  calculateBSA(weight, height) {
    // Superfície Corporal (Mosteller)
    if (!weight || !height) return null;
    return Math.sqrt((weight * height) / 3600).toFixed(2);
  }

  calculateCreatinineClearance(creatinine, age, weight, gender = 'M') {
    // Fórmula de Cockcroft-Gault
    if (!creatinine || !age || !weight) return null;
    
    let result = ((140 - age) * weight) / (72 * creatinine);
    
    if (gender === 'F') {
      result *= 0.85;
    }
    
    return Math.round(result);
  }

  // ===== EXPORTAÇÃO =====
  exportToCSV(data, filename) {
    if (!data || data.length === 0) return;
    
    const headers = Object.keys(data[0]);
    const csvRows = [
      headers.join(','),
      ...data.map(row => headers.map(header => {
        const cell = row[header];
        return typeof cell === 'string' ? `"${cell.replace(/"/g, '""')}"` : cell;
      }).join(','))
    ];
    
    const csvString = csvRows.join('\n');
    const blob = new Blob([csvString], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    
    const a = document.createElement('a');
    a.setAttribute('hidden', '');
    a.setAttribute('href', url);
    a.setAttribute('download', `${filename}.csv`);
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
  }

  exportToJSON(data, filename) {
    const jsonString = JSON.stringify(data, null, 2);
    const blob = new Blob([jsonString], { type: 'application/json' });
    const url = window.URL.createObjectURL(blob);
    
    const a = document.createElement('a');
    a.setAttribute('hidden', '');
    a.setAttribute('href', url);
    a.setAttribute('download', `${filename}.json`);
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
  }

  // ===== TEMPLATES =====
  generatePatientSummary(patient) {
    return `
      Nome: ${patient.name}
      Leito: ${patient.bed_number || 'Não informado'}
      Idade: ${patient.age || 'Não informada'}
      Sexo: ${patient.gender === 'M' ? 'Masculino' : patient.gender === 'F' ? 'Feminino' : 'Não informado'}
      Prioridade: ${APP_CONSTANTS.PRIORITIES[patient.priority?.toUpperCase()] || 'Não definida'}
      Diagnóstico: ${patient.main_diagnosis || 'Não informado'}
      Alergias: ${patient.allergies?.join(', ') || 'Nenhuma conhecida'}
      Observações: ${patient.notes || 'Nenhuma'}
    `.trim();
  }

  generateMedicationSummary(medication) {
    return `
      Medicamento: ${medication.name}
      Princípio Ativo: ${medication.activePrinciple}
      Apresentação: ${medication.concentration} - ${medication.presentation}
      Via: ${medication.administrationRoutes.join(', ')}
      Dose: ${medication.dosage}
      Indicações: ${medication.indications}
      Cuidados: ${medication.precautions}
    `.trim();
  }
}

// Exportar instância singleton
const utilsService = new UtilsService();
export default utilsService;