class AlertComponent {
    constructor() {
        this.containerId = 'alerts-container';
        this.createContainer();
    }

    createContainer() {
        if (!document.getElementById(this.containerId)) {
            const container = document.createElement('div');
            container.id = this.containerId;
            container.className = 'alerts-container position-fixed top-0 end-0 p-3';
            container.style.zIndex = '9999';
            document.body.appendChild(container);
        }
    }

    show(message, type = 'info', duration = 5000) {
        const alertId = `alert-${Date.now()}`;
        const icon = this.getIconForType(type);
        
        const alertHtml = `
            <div id="${alertId}" class="alert alert-${type} alert-dismissible fade show shadow" role="alert">
                <div class="d-flex align-items-center">
                    ${icon}
                    <div class="ms-2">${message}</div>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;
        
        const container = document.getElementById(this.containerId);
        container.insertAdjacentHTML('afterbegin', alertHtml);
        
        // Auto-remover após duração
        if (duration > 0) {
            setTimeout(() => {
                this.remove(alertId);
            }, duration);
        }
        
        return alertId;
    }

    getIconForType(type) {
        const icons = {
            'success': '<i class="bi bi-check-circle-fill me-2"></i>',
            'danger': '<i class="bi bi-exclamation-triangle-fill me-2"></i>',
            'warning': '<i class="bi bi-exclamation-circle-fill me-2"></i>',
            'info': '<i class="bi bi-info-circle-fill me-2"></i>'
        };
        return icons[type] || '';
    }

    remove(alertId) {
        const alert = document.getElementById(alertId);
        if (alert) {
            alert.classList.remove('show');
            setTimeout(() => alert.remove(), 300);
        }
    }

    clearAll() {
        const container = document.getElementById(this.containerId);
        if (container) {
            container.innerHTML = '';
        }
    }

    // Métodos de conveniência
    success(message, duration = 3000) {
        return this.show(message, 'success', duration);
    }

    error(message, duration = 5000) {
        return this.show(message, 'danger', duration);
    }

    warning(message, duration = 4000) {
        return this.show(message, 'warning', duration);
    }

    info(message, duration = 3000) {
        return this.show(message, 'info', duration);
    }
}

// Exportar instância singleton
const alertComponent = new AlertComponent();
export default alertComponent;