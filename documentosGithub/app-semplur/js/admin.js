import { supabase, currentUserId, isAdmin, showToast } from './app.js';

export async function loadAdminModule() {
  try {
    // Verificar se usuário é admin
    if (!isAdmin) {
      window.location.hash = 'documents';
      showToast('Acesso não autorizado', 'danger');
      return;
    }

    const container = document.getElementById('admin-content');
    if (!container) return;

    // Carregar HTML do módulo
    const response = await fetch('components/admin-module.html');
    container.innerHTML = await response.text();

    // Carregar usuários
    await loadUsers();

    // Configurar event listeners
    setupAdminEvents();

  } catch (error) {
    console.error('Erro ao carregar módulo administrativo:', error);
    showToast('Erro ao carregar administração', 'danger');
  }
}

async function loadUsers() {
  try {
    const { data, error } = await supabase
      .from('users')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) throw error;

    const usersTableBody = document.getElementById('usersTableBody');
    if (!usersTableBody) return;

    usersTableBody.innerHTML = '';

    if (!data || data.length === 0) {
      usersTableBody.innerHTML = `
        <tr><td colspan="5" class="text-center text-muted py-4">Nenhum usuário cadastrado</td></tr>
      `;
      return;
    }

    data.forEach(user => {
      const tr = document.createElement('tr');
      const roleBadge = user.role === 'admin' 
        ? '<span class="badge bg-danger">Administrador</span>' 
        : '<span class="badge bg-primary">Usuário</span>';
      
      const statusBadge = user.active
        ? '<span class="badge bg-success">Ativo</span>'
        : '<span class="badge bg-secondary">Inativo</span>';
      
      tr.innerHTML = `
        <td>${escapeHtml(user.full_name)}</td>
        <td><code>${escapeHtml(user.username)}</code></td>
        <td>${roleBadge}</td>
        <td>${statusBadge}</td>
        <td><small>${new Date(user.created_at).toLocaleDateString('pt-BR')}</small></td>
        <td>
          ${user.username !== 'admin' ? `
            <button class="btn btn-sm btn-outline-warning edit-user-btn me-1" data-id="${user.id}">
              <i class="bi bi-pencil"></i>
            </button>
            <button class="btn btn-sm btn-outline-danger toggle-user-btn" data-id="${user.id}" data-active="${user.active}">
              <i class="bi bi-power"></i>
            </button>
          ` : '<small class="text-muted">Admin padrão</small>'}
        </td>
      `;
      
      // Botão editar
      const editBtn = tr.querySelector('.edit-user-btn');
      if (editBtn) {
        editBtn.addEventListener('click', () => editUser(user));
      }
      
      // Botão ativar/desativar
      const toggleBtn = tr.querySelector('.toggle-user-btn');
      if (toggleBtn) {
        toggleBtn.addEventListener('click', () => toggleUserStatus(user.id, !user.active));
      }

      usersTableBody.appendChild(tr);
    });

  } catch (error) {
    console.error('Erro em loadUsers:', error);
    showToast('Erro ao carregar usuários', 'danger');
  }
}

async function handleAddUser(e) {
  e.preventDefault();

  const fullName = document.getElementById('userFullName').value.trim();
  const username = document.getElementById('userUsername').value.trim();
  const password = document.getElementById('userPassword').value.trim();
  const role = document.getElementById('userRole').value;

  if (!fullName || !username || !password) {
    showToast('Preencha todos os campos', 'warning');
    return;
  }

  // Validar username único
  const { data: existingUser } = await supabase
    .from('users')
    .select('id')
    .eq('username', username)
    .single();

  if (existingUser) {
    showToast('Username já está em uso', 'danger');
    return;
  }

  const submitBtn = e.target.querySelector('button[type="submit"]');
  const originalText = submitBtn.innerHTML;
  submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Adicionando...';
  submitBtn.disabled = true;

  try {
    const { error } = await supabase
      .from('users')
      .insert([
        {
          full_name: fullName,
          username: username,
          password: password,
          role: role,
          active: true,
          created_by: currentUserId
        }
      ]);

    if (error) throw error;

    // Limpar formulário e recarregar
    e.target.reset();
    await loadUsers();
    
    showToast(`Usuário "${fullName}" adicionado com sucesso!`, 'success');
  } catch (error) {
    console.error('Erro ao adicionar usuário:', error);
    showToast('Erro ao adicionar usuário: ' + error.message, 'danger');
  } finally {
    submitBtn.innerHTML = originalText;
    submitBtn.disabled = false;
  }
}

async function editUser(user) {
  // Aqui você pode implementar um modal de edição
  // Por enquanto, apenas mostra os dados
  showToast(`Editando usuário: ${user.full_name}`, 'info');
  
  // Para implementação completa, crie um modal de edição
  // similar ao de denúncias
}

async function toggleUserStatus(userId, newStatus) {
  const action = newStatus ? 'ativar' : 'desativar';
  
  if (!confirm(`Tem certeza que deseja ${action} este usuário?`)) return;

  try {
    const { error } = await supabase
      .from('users')
      .update({ active: newStatus })
      .eq('id', userId);

    if (error) throw error;

    await loadUsers();
    showToast(`Usuário ${action}do com sucesso!`, 'success');
  } catch (error) {
    console.error('Erro ao alterar status do usuário:', error);
    showToast('Erro ao alterar status do usuário', 'danger');
  }
}

function setupAdminEvents() {
  // Formulário de novo usuário
  const formAddUser = document.getElementById('formAddUser');
  if (formAddUser) {
    formAddUser.addEventListener('submit', handleAddUser);
  }
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