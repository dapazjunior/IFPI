// modules/ui-helpers.js - Funções auxiliares para UI

// Formatar data
export function formatarData(dataString) {
    if (!dataString) return '';
    
    try {
        const data = new Date(dataString);
        if (isNaN(data.getTime())) return dataString;
        
        const temHorario = dataString.includes('T');
        if (temHorario) {
            return data.toLocaleString('pt-BR', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        } else {
            return data.toLocaleDateString('pt-BR');
        }
    } catch (e) {
        console.error('Erro ao formatar data:', e);
        return dataString;
    }
}

// Obter cor da prioridade
export function getCorPrioridade(prioridade) {
    const cores = {
        'alta': 'danger',
        'media': 'warning',
        'baixa': 'success'
    };
    return cores[prioridade] || 'secondary';
}

// Mostrar loading
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

// Validar email
export function validarEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

// Exportar para escopo global
if (typeof window !== 'undefined') {
    window.formatarData = formatarData;
    window.getCorPrioridade = getCorPrioridade;
    window.validarEmail = validarEmail;
}