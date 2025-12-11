import authService from '../modules/auth.js';

class HeaderComponent {
    constructor() {
        this.notifications = [];
    }

    async init() {
        await this.loadUserData();
        await this.loadNotifications();
        this.setupEventListeners();
    }

    async loadUserData() {
        const user = authService.getUser();
        const profile = authService.getUserProfile();
        
        // Atualizar nome do usuário
        document.querySelectorAll('.user-name').forEach(el => {
            if (profile?.full_name) {
                el.textContent = profile.full_name;
            } else if (user?.email) {
                el.textContent = user.email.split('@')[0];
            }
        });
        
        // Atualizar role
        document.querySelectorAll('.user-role').forEach(el => {
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

    async loadNotifications() {
        try {
            // Em produção, buscar do backend
            this.notifications = [
                {
                    id: 1,
                    title: 'Bem-vindo!',
                    message: 'Seja bem-vindo ao Enfermeiro Ágil',
                    time: 'há 2 horas',
                    read: false
                },
                {
                    id: 2,
                    title: 'Atualização',
                    message: 'Novos recursos disponíveis',
                    time: 'há 1 dia',
                    read: true
                }
            ];
            
            this.renderNotifications();
            
        } catch (error) {
            console.error('Erro ao carregar notificações:', error);
        }
    }

    renderNotifications() {
        const container = document.getElementById('notifications-list');
        const countBadge = document.getElementById('notification-count');
        
        if (!container) return;
        
        const unreadCount = this.notifications.filter(n => !n.read).length;
        
        // Atualizar badge
        if (countBadge) {
            countBadge.textContent = unreadCount;
            countBadge.style.display = unreadCount > 0 ? 'block' : 'none';
        }
        
        // Renderizar lista
        if (this.notifications.length === 0) {
            container.innerHTML = `
                <div class="list-group-item text-center py-4">
                    <div class="text-muted">Nenhuma notificação</div>
                </div>
            `;
            return;
        }
        
        let html = '';
        this.notifications.forEach(notification => {
            html += `
                <a href="#" class="list-group-item list-group-item-action ${notification.read ? '' : 'bg-light'}" 
                     onclick="markAsRead(${notification.id})">
                    <div class="d-flex w-100 justify-content-between">
                        <h6 class="mb-1">${notification.title}</h6>
                        <small>${notification.time}</small>
                    </div>
                    <p class="mb-1 small">${notification.message}</p>
                </a>
            `;
        });
        
        container.innerHTML = html;
    }

    setupEventListeners() {
        // Logout
        document.querySelectorAll('.logout-btn').forEach(btn => {
            btn.addEventListener('click', async (e) => {
                e.preventDefault();
                await authService.logout();
            });
        });
    }
}

// Funções globais para notificações
window.markAsRead = function(id) {
    // Implementar marcação como lida
    console.log('Marcar notificação como lida:', id);
};

// Exportar instância singleton
const headerComponent = new HeaderComponent();
export default headerComponent;