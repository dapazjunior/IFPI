// Navegação entre telas
function navigateTo(page) {
    window.location.href = page;
}

// Controle de modais
function openModal(modalId) {
    const modal = new bootstrap.Modal(document.getElementById(modalId));
    modal.show();
}

function closeModal(modalId) {
    const modal = bootstrap.Modal.getInstance(document.getElementById(modalId));
    modal.hide();
}

// Seleção de opções de alerta
function selectAlertOption(element) {
    document.querySelectorAll('.alert-option').forEach(option => {
        option.classList.remove('active', 'btn-primary');
        option.classList.add('btn-outline-primary');
    });
    element.classList.remove('btn-outline-primary');
    element.classList.add('active', 'btn-primary');
}

// Envio de alerta
function sendAlert() {
    const selectedOption = document.querySelector('.alert-option.active');
    if (selectedOption) {
        alert('Alerta enviado com sucesso!');
        closeModal('alertModal');
    } else {
        alert('Selecione um tipo de ocorrência primeiro.');
    }
}

// Login form submission
document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            e.preventDefault();
            // Simulação de login bem-sucedido
            navigateTo('feed.html');
        });
    }
    
    // Inicialização de tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});

// Simulação de envio de mensagem no chat
document.addEventListener('DOMContentLoaded', function() {
    const chatForm = document.querySelector('.chat-input .input-group');
    if (chatForm) {
        chatForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const input = this.querySelector('input');
            const message = input.value.trim();
            
            if (message) {
                // Aqui iria a lógica para enviar a mensagem
                console.log('Mensagem enviada:', message);
                input.value = '';
                
                // Simulação de resposta após 1-2 segundos
                setTimeout(() => {
                    // Simular resposta automática
                    const responses = [
                        "Obrigado pela informação!",
                        "Vou verificar isso.",
                        "Alguém mais pode confirmar?",
                        "Já foi resolvido?"
                    ];
                    
                    const randomResponse = responses[Math.floor(Math.random() * responses.length)];
                    
                    // Adicionar uma mensagem simulada (apenas para demonstração)
                    const chatContainer = document.querySelector('.chat-container');
                    const newMessage = document.createElement('div');
                    newMessage.className = 'chat-message d-flex mb-3';
                    newMessage.innerHTML = `
                        <div class="message-avatar me-2">M</div>
                        <div class="message-content">
                            <div class="message-sender">Maria Silva</div>
                            <div>${randomResponse}</div>
                        </div>
                    `;
                    
                    chatContainer.appendChild(newMessage);
                    chatContainer.scrollTop = chatContainer.scrollHeight;
                }, 1000 + Math.random() * 1000);
            }
        });
    }
    
    // Simulação de carregamento de ocorrências no mapa
    if (document.querySelector('.map-container')) {
        // Aqui iria a lógica para carregar ocorrências no mapa
        console.log('Mapa carregado - carregando ocorrências...');
    }
    
    // Configuração de alternância de temas
    const darkModeToggle = document.querySelector('input[type="checkbox"][value="dark-mode"]');
    if (darkModeToggle) {
        darkModeToggle.addEventListener('change', function() {
            document.body.classList.toggle('dark-mode', this.checked);
            // Aqui iria a lógica para salvar a preferência do usuário
        });
    }
});

// Função para simular o envio de alerta
function sendAlert() {
    const selectedOption = document.querySelector('.alert-option.active');
    if (selectedOption) {
        const alertDetails = document.getElementById('alert-details').value;
        
        // Simular envio do alerta
        console.log('Alerta enviado:', {
            type: selectedOption.textContent,
            details: alertDetails,
            timestamp: new Date().toISOString()
        });
        
        // Fechar o modal
        const alertModal = document.getElementById('alertModal');
        const modal = bootstrap.Modal.getInstance(alertModal);
        modal.hide();
        
        // Mostrar mensagem de sucesso
        alert('Alerta enviado com sucesso!');
    } else {
        alert('Selecione um tipo de ocorrência primeiro.');
    }
}