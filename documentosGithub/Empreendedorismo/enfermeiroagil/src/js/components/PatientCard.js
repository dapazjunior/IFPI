import { UTILS } from '../config/constants.js';

class PatientCardComponent {
    constructor(patientData) {
        this.patient = patientData;
    }

    render() {
        const priorityClass = `priority-${this.patient.priority}`;
        const formattedDate = UTILS.formatDate(this.patient.created_at);
        const priorityText = UTILS.getPriorityText(this.patient.priority);
        const priorityColor = UTILS.getPriorityColor(this.patient.priority);
        
        return `
            <div class="patient-card ${priorityClass}" data-patient-id="${this.patient.id}">
                <div class="d-flex justify-content-between align-items-start mb-2">
                    <div>
                        <h6 class="mb-1 patient-name">${this.patient.name}</h6>
                        <div class="d-flex align-items-center">
                            <span class="priority-badge ${priorityClass} me-2" style="background: ${priorityColor}; color: white;">
                                ${priorityText}
                            </span>
                            <small class="text-muted">
                                <i class="bi bi-hospital me-1"></i>${this.patient.bed_number || 'Sem leito'}
                            </small>
                        </div>
                    </div>
                    <div class="text-end">
                        <small class="text-muted">${formattedDate}</small>
                    </div>
                </div>
                ${this.patient.main_diagnosis ? `
                    <p class="text-muted small mb-0">
                        <i class="bi bi-clipboard2-pulse me-1"></i>
                        ${this.patient.main_diagnosis}
                    </p>
                ` : ''}
                
                <div class="patient-actions mt-2 d-flex justify-content-end gap-2">
                    <button class="btn btn-sm btn-outline-primary view-btn">
                        <i class="bi bi-eye"></i>
                    </button>
                    <button class="btn btn-sm btn-outline-secondary edit-btn">
                        <i class="bi bi-pencil"></i>
                    </button>
                </div>
            </div>
        `;
    }

    attachEventListeners(element) {
        if (!element) return;
        
        const patientId = this.patient.id;
        
        // Botão de visualizar
        const viewBtn = element.querySelector('.view-btn');
        if (viewBtn) {
            viewBtn.addEventListener('click', () => {
                window.location.href = `view.html?id=${patientId}`;
            });
        }
        
        // Botão de editar
        const editBtn = element.querySelector('.edit-btn');
        if (editBtn) {
            editBtn.addEventListener('click', () => {
                window.location.href = `edit.html?id=${patientId}`;
            });
        }
        
        // Clicar no card inteiro (exceto nos botões)
        element.addEventListener('click', (e) => {
            if (!e.target.closest('button')) {
                window.location.href = `view.html?id=${patientId}`;
            }
        });
    }

    static createPatientCard(patientData) {
        const component = new PatientCardComponent(patientData);
        const html = component.render();
        
        // Criar elemento temporário
        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = html;
        const element = tempDiv.firstElementChild;
        
        // Anexar event listeners
        component.attachEventListeners(element);
        
        return element;
    }

    static renderPatientList(patients, containerId) {
        const container = document.getElementById(containerId);
        if (!container) return;
        
        container.innerHTML = '';
        
        if (!patients || patients.length === 0) {
            container.innerHTML = `
                <div class="text-center py-4">
                    <i class="bi bi-people text-muted" style="font-size: 3rem;"></i>
                    <p class="text-muted mt-2">Nenhum paciente encontrado</p>
                </div>
            `;
            return;
        }
        
        patients.forEach(patient => {
            const cardElement = PatientCardComponent.createPatientCard(patient);
            container.appendChild(cardElement);
        });
    }
}

// Estilos CSS para o card
const patientCardStyles = `
    <style>
        .patient-card {
            background: white;
            border-radius: 12px;
            padding: 1.25rem;
            margin-bottom: 1rem;
            border-left: 4px solid;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .patient-card:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .priority-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .priority-high {
            border-left-color: #dc3545;
        }
        
        .priority-medium {
            border-left-color: #ffc107;
        }
        
        .priority-low {
            border-left-color: #28a745;
        }
        
        .patient-actions {
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .patient-card:hover .patient-actions {
            opacity: 1;
        }
    </style>
`;

// Adicionar estilos ao documento
if (typeof document !== 'undefined') {
    document.head.insertAdjacentHTML('beforeend', patientCardStyles);
}

export default PatientCardComponent;