import authService from '../modules/auth.js';

class SidebarComponent {
    constructor() {
        this.currentPath = window.location.pathname;
    }

    init() {
        this.highlightCurrentItem();
        this.setupMobileToggle();
        this.loadPlanStatus();
    }

    highlightCurrentItem() {
        const items = {
            'dashboard': 'sidebar-dashboard',
            'patients': 'sidebar-patients',
            'medications': 'sidebar-medications',
            'ai-assistant': 'sidebar-ai',
            'protocols': 'sidebar-protocols',
            'templates': 'sidebar-templates',
            'settings': 'sidebar-settings'
        };
        
        for (const [key, id] of Object.entries(items)) {
            if (this.currentPath.includes(key)) {
                const element = document.getElementById(id);
                if (element) {
                    element.classList.add('active');
                    element.style.fontWeight = '600';
                    element.style.background = 'var(--light-blue)';
                    element.style.borderRadius = '8px';
                }
                break;
            }
        }
    }

    setupMobileToggle() {
        const toggleBtn = document.querySelector('.sidebar-toggle');
        const sidebar = document.querySelector('.sidebar');
        
        if (toggleBtn && sidebar) {
            toggleBtn.addEventListener('click', () => {
                sidebar.classList.toggle('show');
                sidebar.style.transform = sidebar.classList.contains('show') ? 
                    'translateX(0)' : 'translateX(-100%)';
            });
            
            // Fechar sidebar ao clicar fora (mobile)
            document.addEventListener('click', (e) => {
                if (window.innerWidth <= 768 && 
                    sidebar.classList.contains('show') &&
                    !sidebar.contains(e.target) && 
                    e.target !== toggleBtn) {
                    sidebar.classList.remove('show');
                    sidebar.style.transform = 'translateX(-100%)';
                }
            });
        }
    }

    async loadPlanStatus() {
        try {
            const planCard = document.getElementById('plan-status-card');
            if (!planCard) return;
            
            // Buscar dados do plano do usuário
            const user = authService.getUser();
            if (!user) return;
            
            // Em produção, buscar da API
            const planData = {
                name: 'Básico',
                status: 'Ativo',
                usedPatients: 12,
                maxPatients: 50,
                percentage: 25
            };
            
            // Atualizar UI
            const badge = planCard.querySelector('.badge');
            const progress = planCard.querySelector('.progress-bar');
            const text = planCard.querySelector('small:nth-of-type(2)');
            
            if (badge) badge.textContent = planData.name;
            if (progress) progress.style.width = `${planData.percentage}%`;
            if (text) text.textContent = `${planData.usedPatients}/${planData.maxPatients} pacientes`;
            
        } catch (error) {
            console.error('Erro ao carregar status do plano:', error);
        }
    }
}

// Funções globais para sidebar
window.upgradePlan = function() {
    window.location.href = '/pages/app/settings/index.html#plan';
};

// Exportar instância singleton
const sidebarComponent = new SidebarComponent();
export default sidebarComponent;