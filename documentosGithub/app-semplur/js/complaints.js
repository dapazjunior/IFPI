import { supabase, currentUserId, isAdmin, showToast } from './app.js';
import { uploadFiles, deleteAttachment } from './storage.js';

let complaintsData = [];
let assigneesList = [];
let currentComplaintModal = null;

export async function loadComplaintsModule() {
  try {
    const container = document.getElementById('complaints-content');
    if (!container) return;

    // Carregar HTML do módulo
    const response = await fetch('components/complaints-module.html');
    container.innerHTML = await response.text();

    // Inicializar componentes
    await loadAssignees();
    await loadComplaints();
    await loadMyComplaints();

    // Configurar event listeners
    setupComplaintEvents();

  } catch (error) {
    console.error('Erro ao carregar módulo de denúncias:', error);
    showToast('Erro ao carregar denúncias', 'danger');
  }
}

export async function loadAssignees() {
  try {
    const { data, error } = await supabase
      .from('users')
      .select('id, full_name, role')
      .eq('active', true)
      .order('full_name', { ascending: true });

    if (error) throw error;

    assigneesList = data || [];

    // Atualizar selects de atribuição
    const assigneeSelects = [
      document.getElementById('complaintAssignee'),
      document.getElementById('editComplaintAssignee')
    ];

    assigneeSelects.forEach(select => {
      if (select) {
        select.innerHTML = '<option value="">-- Não atribuído --</option>';
        if (assigneesList.length > 0) {
          assigneesList.forEach(user => {
            const option = document.createElement('option');
            option.value = user.id;
            option.textContent = `${user.full_name} (${user.role})`;
            select.appendChild(option);
          });
        }
      }
    });

  } catch (error) {
    console.error('Erro em loadAssignees:', error);
  }
}

async function loadComplaints() {
  try {
    const { data, error } = await supabase
      .from('complaints')
      .select(`
        *,
        assignee:users!complaints_assignee_id_fkey(id, full_name),
        created_by_user:users!complaints_created_by_fkey(id, full_name)
      `)
      .order('created_at', { ascending: false });

    if (error) throw error;

    complaintsData = data || [];
    const complaintsTableBody = document.getElementById('complaintsTableBody');
    if (!complaintsTableBody) return;

    complaintsTableBody.innerHTML = '';

    if (complaintsData.length === 0) {
      complaintsTableBody.innerHTML = `
        <tr><td colspan="8" class="text-center text-muted py-4">Nenhuma denúncia cadastrada</td></tr>
      `;
      return;
    }

    complaintsData.forEach(complaint => {
      const tr = document.createElement('tr');
      const statusBadge = getStatusBadge(complaint.status);
      const priorityBadge = getPriorityBadge(complaint.priority || 'normal');
      const assigneeName = complaint.assignee ? complaint.assignee.full_name : 'Não atribuído';
      const dueDate = complaint.due_date ? new Date(complaint.due_date).toLocaleDateString('pt-BR') : '-';
      
      const complaintNumber = complaint.complaint_number || 
        `DEN${new Date(complaint.created_at).getFullYear()}XXXX`;
      
      tr.innerHTML = `
        <td>
          <small class="fw-semibold">${complaintNumber}</small>
        </td>
        <td>
          <div class="fw-semibold">${escapeHtml(complaint.title)}</div>
          <small class="text-muted">${escapeHtml(complaint.description.substring(0, 50))}...</small>
        </td>
        <td>${statusBadge} ${priorityBadge}</td>
        <td><small>${escapeHtml(complaint.location)}</small></td>
        <td>
          ${complaint.assignee ? 
            `<span class="badge bg-info">${escapeHtml(assigneeName)}</span>` : 
            '<span class="badge bg-secondary">Não atribuído</span>'
          }
        </td>
        <td><small>${dueDate}</small></td>
        <td><small>${new Date(complaint.created_at).toLocaleDateString('pt-BR')}</small></td>
        <td>
          <button class="btn btn-sm btn-outline-warning edit-complaint-btn" data-id="${complaint.id}" title="Gerenciar">
            <i class="bi bi-gear"></i>
          </button>
          ${isAdmin || complaint.created_by === currentUserId ? `
            <button class="btn btn-sm btn-outline-danger delete-complaint-btn" data-id="${complaint.id}">
              <i class="bi bi-trash"></i>
            </button>
          ` : ''}
        </td>
      `;
      
      // Event listeners para os botões
      const editBtn = tr.querySelector('.edit-complaint-btn');
      if (editBtn) {
        editBtn.addEventListener('click', () => openEditComplaintModal(complaint));
      }
      
      const deleteBtn = tr.querySelector('.delete-complaint-btn');
      if (deleteBtn) {
        deleteBtn.addEventListener('click', () => deleteComplaint(complaint.id));
      }

      complaintsTableBody.appendChild(tr);
    });

  } catch (error) {
    console.error('Erro em loadComplaints:', error);
    showToast('Erro ao carregar denúncias', 'danger');
  }
}

async function loadMyComplaints() {
  try {
    const { data, error } = await supabase
      .from('complaints')
      .select('*')
      .eq('assignee_id', currentUserId)
      .in('status', ['pendente', 'em_andamento'])
      .order('created_at', { ascending: false })
      .limit(10);

    if (error) throw error;

    const myComplaintsBody = document.getElementById('myComplaintsBody');
    if (!myComplaintsBody) return;

    myComplaintsBody.innerHTML = '';

    if (!data || data.length === 0) {
      myComplaintsBody.innerHTML = `
        <tr><td colspan="4" class="text-center text-muted py-4">Nenhuma denúncia atribuída</td></tr>
      `;
      return;
    }

    data.forEach(complaint => {
      const tr = document.createElement('tr');
      const statusBadge = getStatusBadge(complaint.status);
      const complaintNumber = complaint.complaint_number || 
        `DEN${new Date(complaint.created_at).getFullYear()}XXXX`;
      
      tr.innerHTML = `
        <td>
          <div class="fw-semibold">${escapeHtml(complaint.title)}</div>
          <small class="text-muted">${complaintNumber} • ${escapeHtml(complaint.location.substring(0, 30))}...</small>
        </td>
        <td>${statusBadge}</td>
        <td><small>${new Date(complaint.created_at).toLocaleDateString('pt-BR')}</small></td>
        <td>
          <button class="btn btn-sm btn-outline-warning edit-complaint-btn" data-id="${complaint.id}" title="Gerenciar">
            <i class="bi bi-gear"></i>
          </button>
        </td>
      `;
      
      const editBtn = tr.querySelector('.edit-complaint-btn');
      if (editBtn) {
        editBtn.addEventListener('click', () => openEditComplaintModal(complaint));
      }

      myComplaintsBody.appendChild(tr);
    });

  } catch (error) {
    console.error('Erro em loadMyComplaints:', error);
  }
}

async function handleAddComplaint(e) {
  e.preventDefault();

  const title = document.getElementById('complaintTitle').value.trim();
  const description = document.getElementById('complaintDescription').value.trim();
  const location = document.getElementById('complaintLocation').value.trim();
  const priority = document.getElementById('complaintPriority')?.value || 'normal';
  const assigneeId = document.getElementById('complaintAssignee')?.value || null;
  const attachmentInput = document.getElementById('newComplaintAttachments');

  if (!title || !description || !location) {
    showToast('Preencha todos os campos obrigatórios', 'warning');
    return;
  }

  const submitBtn = e.target.querySelector('button[type="submit"]');
  const originalText = submitBtn.innerHTML;
  submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Cadastrando...';
  submitBtn.disabled = true;

  try {
    const { data, error } = await supabase
      .from('complaints')
      .insert([
        {
          title,
          description,
          location,
          priority,
          status: 'pendente',
          assignee_id: assigneeId,
          created_by: currentUserId
        }
      ])
      .select()
      .single();

    if (error) throw error;

    // Se houver anexos, fazer upload
    if (attachmentInput && attachmentInput.files.length > 0) {
      await uploadFiles(attachmentInput.files, data.id, `Anexos da denúncia: ${title}`);
    }

    // Limpar formulário
    e.target.reset();
    if (attachmentInput) attachmentInput.value = '';
    
    // Recarregar listas
    await Promise.all([loadComplaints(), loadMyComplaints()]);
    
    showToast(`Denúncia "${title}" cadastrada com sucesso! Número: ${data.complaint_number || 'DENXXXX'}`, 'success');
  } catch (error) {
    console.error('Erro ao cadastrar denúncia:', error);
    showToast('Erro ao cadastrar denúncia: ' + error.message, 'danger');
  } finally {
    submitBtn.innerHTML = originalText;
    submitBtn.disabled = false;
  }
}

async function deleteComplaint(id) {
  if (!confirm('Tem certeza que deseja excluir esta denúncia?')) return;

  try {
    const { error } = await supabase
      .from('complaints')
      .delete()
      .eq('id', id);

    if (error) throw error;

    await Promise.all([loadComplaints(), loadMyComplaints()]);
    showToast('Denúncia excluída com sucesso!', 'success');
  } catch (error) {
    console.error('Erro ao excluir denúncia:', error);
    showToast('Erro ao excluir denúncia: ' + error.message, 'danger');
  }
}

export async function openEditComplaintModal(complaint) {
  try {
    // Carregar modal se não estiver carregado
    if (!currentComplaintModal) {
      await loadComplaintModal();
    }

    const complaintId = complaint.id;
    const complaintNumber = complaint.complaint_number || 
      `DEN${new Date(complaint.created_at).getFullYear()}XXXX`;
    
    // Atualizar título do modal
    const modalTitle = document.querySelector('#editComplaintModal .modal-title');
    if (modalTitle) {
      modalTitle.innerHTML = `<i class="bi bi-pencil-square"></i> Gerenciar Denúncia <small class="text-muted">(${complaintNumber})</small>`;
    }
    
    // Preencher formulário
    document.getElementById('editComplaintId').value = complaintId;
    document.getElementById('editComplaintTitle').value = complaint.title;
    document.getElementById('editComplaintDescription').value = complaint.description;
    document.getElementById('editComplaintLocation').value = complaint.location;
    document.getElementById('editComplaintStatus').value = complaint.status;
    document.getElementById('editComplaintPriority').value = complaint.priority || 'normal';
    document.getElementById('editComplaintDueDate').value = complaint.due_date ? complaint.due_date.split('T')[0] : '';
    document.getElementById('editComplaintResolution').value = complaint.resolution_details || '';
    
    // Mostrar/ocultar seção de resolução
    const resolutionSection = document.getElementById('resolutionSection');
    if (resolutionSection) {
      resolutionSection.style.display = complaint.status === 'concluido' ? 'block' : 'none';
    }
    
    // Configurar assignee
    const assigneeSelect = document.getElementById('editComplaintAssignee');
    if (assigneeSelect) {
      assigneeSelect.value = complaint.assignee_id || '';
    }
    
    // Carregar anexos e comentários
    await loadAttachments(complaintId);
    await loadComments(complaintId);
    
    // Configurar eventos para esta denúncia
    setupModalEvents(complaintId);
    
    // Mostrar modal
    const modalElement = document.getElementById('editComplaintModal');
    if (modalElement) {
      currentComplaintModal = new bootstrap.Modal(modalElement);
      currentComplaintModal.show();
    }

  } catch (error) {
    console.error('Erro ao abrir modal de denúncia:', error);
    showToast('Erro ao carregar detalhes da denúncia', 'danger');
  }
}

async function loadComplaintModal() {
  try {
    const response = await fetch('components/modal-complaint.html');
    const modalHtml = await response.text();
    
    const modalContainer = document.getElementById('modal-container') || document.body;
    modalContainer.insertAdjacentHTML('beforeend', modalHtml);
    
    // Configurar formulário de edição
    const editComplaintForm = document.getElementById('editComplaintForm');
    if (editComplaintForm) {
      editComplaintForm.addEventListener('submit', handleEditComplaint);
    }
    
  } catch (error) {
    console.error('Erro ao carregar modal:', error);
  }
}

async function handleEditComplaint(e) {
  e.preventDefault();

  const id = document.getElementById('editComplaintId').value;
  const title = document.getElementById('editComplaintTitle').value.trim();
  const description = document.getElementById('editComplaintDescription').value.trim();
  const location = document.getElementById('editComplaintLocation').value.trim();
  const status = document.getElementById('editComplaintStatus').value;
  const priority = document.getElementById('editComplaintPriority').value;
  const dueDate = document.getElementById('editComplaintDueDate').value || null;
  const resolutionDetails = document.getElementById('editComplaintResolution').value.trim() || null;
  const assigneeId = document.getElementById('editComplaintAssignee').value || null;

  if (!title || !description || !location) {
    showToast('Preencha todos os campos obrigatórios', 'warning');
    return;
  }

  const submitBtn = e.target.querySelector('button[type="submit"]');
  const originalText = submitBtn.innerHTML;
  submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Salvando...';
  submitBtn.disabled = true;

  try {
    const { error } = await supabase
      .from('complaints')
      .update({
        title,
        description,
        location,
        status,
        priority,
        due_date: dueDate,
        resolution_details: resolutionDetails,
        assignee_id: assigneeId,
        updated_at: new Date().toISOString()
      })
      .eq('id', id);

    if (error) throw error;

    // Fechar modal e recarregar
    if (currentComplaintModal) {
      currentComplaintModal.hide();
    }
    
    await Promise.all([loadComplaints(), loadMyComplaints()]);
    
    showToast('Denúncia atualizada com sucesso!', 'success');
  } catch (error) {
    console.error('Erro ao atualizar denúncia:', error);
    showToast('Erro ao atualizar denúncia: ' + error.message, 'danger');
  } finally {
    submitBtn.innerHTML = originalText;
    submitBtn.disabled = false;
  }
}

async function loadAttachments(complaintId) {
  try {
    const { data: attachments, error } = await supabase
      .from('complaint_attachments')
      .select(`
        *,
        uploaded_by_user:users(id, full_name)
      `)
      .eq('complaint_id', complaintId)
      .order('created_at', { ascending: false });

    if (error) throw error;

    const attachmentsList = document.getElementById('attachmentsList');
    if (!attachmentsList) return;

    attachmentsList.innerHTML = '';

    if (!attachments || attachments.length === 0) {
      attachmentsList.innerHTML = `
        <div class="text-center py-4 text-muted">
          <i class="bi bi-folder-x fs-1"></i>
          <p class="mt-2">Nenhum anexo adicionado</p>
        </div>
      `;
      return;
    }

    attachments.forEach(attachment => {
      const isImage = attachment.file_type?.startsWith('image/');
      const fileSize = attachment.file_size ? formatFileSize(attachment.file_size) : 'Tamanho desconhecido';
      const uploadedBy = attachment.uploaded_by_user?.full_name || 'Desconhecido';
      
      const attachmentElement = document.createElement('div');
      attachmentElement.className = 'attachment-card';
      attachmentElement.innerHTML = `
        <div class="d-flex justify-content-between align-items-start">
          <div class="flex-grow-1">
            <div class="d-flex align-items-center mb-2">
              <i class="bi ${getFileIcon(attachment.file_type)} me-2 fs-4"></i>
              <div>
                <h6 class="mb-0">${escapeHtml(attachment.file_name)}</h6>
                <small class="text-muted">
                  ${fileSize} • ${uploadedBy} • ${new Date(attachment.created_at).toLocaleString('pt-BR')}
                </small>
              </div>
            </div>
            
            ${attachment.description ? `
              <p class="mb-2 small">${escapeHtml(attachment.description)}</p>
            ` : ''}
            
            <div class="mt-2">
              <a href="${attachment.file_url}" target="_blank" class="btn btn-sm btn-outline-primary me-2">
                <i class="bi bi-download"></i> Baixar
              </a>
              <a href="${attachment.file_url}" target="_blank" class="btn btn-sm btn-outline-info me-2">
                <i class="bi bi-eye"></i> Visualizar
              </a>
              ${isAdmin || currentUserId === attachment.uploaded_by ? `
                <button class="btn btn-sm btn-outline-danger delete-attachment-btn" data-id="${attachment.id}">
                  <i class="bi bi-trash"></i> Excluir
                </button>
              ` : ''}
            </div>
          </div>
        </div>
        
        ${isImage ? `
          <div class="mt-3 text-center">
            <img src="${attachment.file_url}" alt="${attachment.file_name}" class="img-preview">
          </div>
        ` : ''}
      `;

      // Event listener para excluir anexo
      const deleteBtn = attachmentElement.querySelector('.delete-attachment-btn');
      if (deleteBtn) {
        deleteBtn.addEventListener('click', () => deleteAttachment(attachment.id, complaintId));
      }

      attachmentsList.appendChild(attachmentElement);
    });
  } catch (error) {
    console.error('Erro ao carregar anexos:', error);
    const attachmentsList = document.getElementById('attachmentsList');
    if (attachmentsList) {
      attachmentsList.innerHTML = `
        <div class="alert alert-danger">
          <i class="bi bi-exclamation-triangle"></i> Erro ao carregar anexos
        </div>
      `;
    }
  }
}

async function loadComments(complaintId) {
  try {
    const { data: comments, error } = await supabase
      .from('complaint_comments')
      .select(`
        *,
        user:users(id, full_name, role)
      `)
      .eq('complaint_id', complaintId)
      .order('created_at', { ascending: true });

    if (error) throw error;

    const commentsList = document.getElementById('commentsList');
    if (!commentsList) return;

    commentsList.innerHTML = '';

    if (!comments || comments.length === 0) {
      commentsList.innerHTML = `
        <div class="text-center py-4 text-muted">
          <i class="bi bi-chat-left fs-1"></i>
          <p class="mt-2">Nenhum comentário ainda</p>
        </div>
      `;
      return;
    }

    comments.forEach(comment => {
      const userRole = comment.user?.role === 'admin' ? '<span class="badge bg-danger ms-2">Admin</span>' : '';
      
      const commentElement = document.createElement('div');
      commentElement.className = 'comment-item';
      commentElement.innerHTML = `
        <div class="comment-header">
          <div>
            <span class="comment-user">${escapeHtml(comment.user?.full_name || 'Usuário')}</span>
            ${userRole}
          </div>
          <small class="comment-date">${new Date(comment.created_at).toLocaleString('pt-BR')}</small>
        </div>
        <div class="comment-content">
          <p class="mb-0">${escapeHtml(comment.comment)}</p>
        </div>
        ${comment.updated_at !== comment.created_at ? `
          <small class="text-muted d-block mt-1">
            <i class="bi bi-pencil"></i> Editado em ${new Date(comment.updated_at).toLocaleString('pt-BR')}
          </small>
        ` : ''}
      `;

      commentsList.appendChild(commentElement);
    });

    // Rolagem automática para o último comentário
    commentsList.scrollTop = commentsList.scrollHeight;
  } catch (error) {
    console.error('Erro ao carregar comentários:', error);
    const commentsList = document.getElementById('commentsList');
    if (commentsList) {
      commentsList.innerHTML = `
        <div class="alert alert-danger">
          <i class="bi bi-exclamation-triangle"></i> Erro ao carregar comentários
        </div>
      `;
    }
  }
}

function setupComplaintEvents() {
  // Formulário de nova denúncia
  const formComplaint = document.getElementById('formComplaint');
  if (formComplaint) {
    formComplaint.addEventListener('submit', handleAddComplaint);
  }

  // Drag and drop para upload
  setupDragAndDrop();
}

function setupModalEvents(complaintId) {
  // Upload de anexos no modal
  const attachmentInput = document.getElementById('complaintAttachmentInput');
  if (attachmentInput) {
    attachmentInput.addEventListener('change', async (e) => {
      const files = e.target.files;
      if (files.length > 0) {
        await uploadFiles(files, complaintId);
        attachmentInput.value = '';
      }
    });
  }

  // Sistema de comentários
  const addCommentBtn = document.getElementById('addCommentBtn');
  const commentInput = document.getElementById('newCommentText');
  const commentAttachmentInput = document.getElementById('commentAttachmentInput');
  const commentAttachmentName = document.getElementById('commentAttachmentName');

  if (addCommentBtn) {
    addCommentBtn.addEventListener('click', async () => {
      const commentText = commentInput ? commentInput.value.trim() : '';
      const attachmentFile = commentAttachmentInput?.files[0] || null;
      
      await addComment(complaintId, commentText, attachmentFile);
    });
  }

  if (commentInput) {
    commentInput.addEventListener('keypress', (e) => {
      if (e.key === 'Enter' && e.ctrlKey) {
        const commentText = commentInput.value.trim();
        addComment(complaintId, commentText, commentAttachmentInput?.files[0] || null);
      }
    });
  }

  if (commentAttachmentInput) {
    commentAttachmentInput.addEventListener('change', (e) => {
      const file = e.target.files[0];
      if (file && commentAttachmentName) {
        commentAttachmentName.textContent = file.name;
        commentAttachmentName.style.display = 'inline';
      }
    });
  }

  // Drag and drop no modal
  setupModalDragAndDrop(complaintId);
}

function setupDragAndDrop() {
  const dropZone = document.querySelector('.card.border-dashed');
  if (dropZone) {
    dropZone.addEventListener('dragover', (e) => {
      e.preventDefault();
      dropZone.style.borderColor = '#0d6efd';
      dropZone.style.backgroundColor = 'rgba(13, 110, 253, 0.05)';
    });
    
    dropZone.addEventListener('dragleave', () => {
      dropZone.style.borderColor = '#dee2e6';
      dropZone.style.backgroundColor = '';
    });
    
    dropZone.addEventListener('drop', (e) => {
      e.preventDefault();
      dropZone.style.borderColor = '#dee2e6';
      dropZone.style.backgroundColor = '';
      
      const files = e.dataTransfer.files;
      if (files.length > 0) {
        const complaintId = document.getElementById('editComplaintId')?.value;
        if (complaintId) {
          uploadFiles(files, complaintId);
        }
      }
    });
  }
}

function setupModalDragAndDrop(complaintId) {
  const dropZone = document.querySelector('#attachments .card.border-dashed');
  if (dropZone) {
    dropZone.addEventListener('dragover', (e) => {
      e.preventDefault();
      dropZone.style.borderColor = '#0d6efd';
      dropZone.style.backgroundColor = 'rgba(13, 110, 253, 0.05)';
    });
    
    dropZone.addEventListener('dragleave', () => {
      dropZone.style.borderColor = '#dee2e6';
      dropZone.style.backgroundColor = '';
    });
    
    dropZone.addEventListener('drop', async (e) => {
      e.preventDefault();
      dropZone.style.borderColor = '#dee2e6';
      dropZone.style.backgroundColor = '';
      
      const files = e.dataTransfer.files;
      if (files.length > 0) {
        await uploadFiles(files, complaintId);
      }
    });
  }
}

async function addComment(complaintId, commentText, attachmentFile = null) {
  if (!commentText.trim() && !attachmentFile) {
    showToast('Digite um comentário ou selecione um arquivo', 'warning');
    return;
  }

  const addCommentBtn = document.getElementById('addCommentBtn');
  if (!addCommentBtn) return;

  const originalText = addCommentBtn.innerHTML;
  addCommentBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Enviando...';
  addCommentBtn.disabled = true;

  try {
    // Primeiro, salvar o comentário
    const { data: comment, error: commentError } = await supabase
      .from('complaint_comments')
      .insert([
        {
          complaint_id: complaintId,
          user_id: currentUserId,
          comment: commentText.trim()
        }
      ])
      .select()
      .single();

    if (commentError) throw commentError;

    // Se houver anexo, fazer upload
    if (attachmentFile) {
      await uploadFiles([attachmentFile], complaintId, `Anexo do comentário: ${commentText.substring(0, 50)}...`);
    }

    // Limpar campos
    const commentInput = document.getElementById('newCommentText');
    const commentAttachmentName = document.getElementById('commentAttachmentName');
    if (commentInput) commentInput.value = '';
    if (commentAttachmentName) {
      commentAttachmentName.style.display = 'none';
      commentAttachmentName.textContent = '';
    }

    // Recarregar comentários e anexos
    await Promise.all([
      loadComments(complaintId),
      loadAttachments(complaintId)
    ]);

    showToast('Comentário adicionado com sucesso!', 'success');

  } catch (error) {
    console.error('Erro ao adicionar comentário:', error);
    showToast('Erro ao adicionar comentário: ' + error.message, 'danger');
  } finally {
    addCommentBtn.innerHTML = originalText;
    addCommentBtn.disabled = false;
  }
}

// Funções auxiliares
function getStatusBadge(status) {
  const badges = {
    pendente: '<span class="badge bg-warning">Pendente</span>',
    em_andamento: '<span class="badge bg-primary">Em Andamento</span>',
    concluido: '<span class="badge bg-success">Concluído</span>',
    cancelado: '<span class="badge bg-secondary">Cancelado</span>'
  };
  return badges[status] || '<span class="badge bg-light text-dark">Desconhecido</span>';
}

function getPriorityBadge(priority) {
  const badges = {
    baixa: '<span class="badge priority-baixa">Baixa</span>',
    normal: '<span class="badge priority-normal">Normal</span>',
    alta: '<span class="badge priority-alta">Alta</span>',
    urgente: '<span class="badge priority-urgente">Urgente</span>'
  };
  return badges[priority] || badges.normal;
}

function getFileIcon(fileType) {
  if (!fileType) return 'bi-file-earmark';
  
  if (fileType.startsWith('image/')) return 'bi-file-earmark-image';
  if (fileType.includes('pdf')) return 'bi-file-earmark-pdf';
  if (fileType.includes('word') || fileType.includes('document')) return 'bi-file-earmark-word';
  if (fileType.includes('excel') || fileType.includes('spreadsheet')) return 'bi-file-earmark-excel';
  if (fileType.includes('zip') || fileType.includes('compressed')) return 'bi-file-earmark-zip';
  return 'bi-file-earmark';
}

function formatFileSize(bytes) {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

function escapeHtml(str) {
  if (str === null || str === undefined) return '';
  return String(str)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;');
}