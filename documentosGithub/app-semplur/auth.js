import { supabase, currentUser, currentUserId, isAdmin, showToast } from './app.js';

export async function checkAuth() {
  console.log('Verificando autenticação...');
  
  // Verificar localStorage
  const savedUser = localStorage.getItem('currentUser');
  const savedUserId = localStorage.getItem('currentUserId');
  const savedIsAdmin = localStorage.getItem('isAdmin') === 'true';

  if (savedUser && savedUserId) {
    console.log('Usuário encontrado no localStorage:', savedUser);
    currentUser = savedUser;
    currentUserId = savedUserId;
    isAdmin = savedIsAdmin;
    return true;
  }
  
  console.log('Nenhum usuário autenticado encontrado');
  return false;
}

export async function handleLogin(e) {
  e.preventDefault();
  console.log('Processando login...');
  
  const username = document.getElementById('loginUsername').value.trim();
  const password = document.getElementById('loginPassword').value.trim();

  if (!username || !password) {
    showToast('Preencha todos os campos', 'warning');
    return;
  }

  const submitBtn = e.target.querySelector('button[type="submit"]');
  const originalText = submitBtn.innerHTML;
  submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Entrando...';
  submitBtn.disabled = true;

  try {
    console.log(`Buscando usuário: ${username}`);
    
    // Buscar usuário no banco de dados
    const { data, error } = await supabase
      .from('users')
      .select('id, full_name, username, role, active')
      .eq('username', username)
      .eq('password', password)
      .eq('active', true)
      .maybeSingle();  // Usar maybeSingle para não dar erro se não encontrar

    if (error) {
      console.error('Erro na consulta:', error);
      throw new Error('Erro ao conectar com o servidor');
    }

    if (!data) {
      throw new Error('Usuário não encontrado ou senha incorreta');
    }

    console.log('Login bem sucedido para:', data.full_name);
    await loginSuccess(data.full_name, data.id, data.role === 'admin');
    
    // Redirecionar para dashboard
    window.location.href = 'dashboard.html';

  } catch (error) {
    console.error('Erro no login:', error);
    showToast(error.message || 'Usuário ou senha incorretos', 'danger');
  } finally {
    submitBtn.innerHTML = originalText;
    submitBtn.disabled = false;
  }
}

export async function loginSuccess(fullName, userId, admin = false) {
  console.log(`Login success: ${fullName} (${userId}), Admin: ${admin}`);
  
  currentUser = fullName;
  currentUserId = userId;
  isAdmin = admin;

  // Salvar no localStorage
  localStorage.setItem('currentUser', fullName);
  localStorage.setItem('currentUserId', userId);
  localStorage.setItem('isAdmin', admin);
  
  showToast(`Bem-vindo, ${fullName}!`, 'success');
}

export async function handleLogout() {
  console.log('Processando logout...');
  
  if (!confirm('Tem certeza que deseja sair?')) return;
  
  currentUser = null;
  currentUserId = null;
  isAdmin = false;

  localStorage.removeItem('currentUser');
  localStorage.removeItem('currentUserId');
  localStorage.removeItem('isAdmin');

  // Redirecionar para login
  window.location.href = 'index.html';
  
  showToast('Logout realizado com sucesso', 'info');
}

export async function setupAuth() {
  const isAuthenticated = await checkAuth();
  
  // Verificar se está tentando acessar dashboard sem estar logado
  if (!isAuthenticated && window.location.pathname.includes('dashboard')) {
    console.log('Redirecionando para login...');
    window.location.href = 'index.html';
    return false;
  }
  
  // Verificar se está na página de login já autenticado
  if (isAuthenticated && window.location.pathname.includes('index.html')) {
    console.log('Redirecionando para dashboard...');
    window.location.href = 'dashboard.html';
    return false;
  }
  
  return isAuthenticated;
}

// Criar admin padrão se não existir
export async function createDefaultAdmin() {
  try {
    console.log('Verificando admin padrão...');
    
    const { data: existingAdmins } = await supabase
      .from('users')
      .select('id')
      .eq('username', 'admin');

    if (!existingAdmins || existingAdmins.length === 0) {
      console.log('Criando admin padrão...');
      const { error } = await supabase
        .from('users')
        .insert([
          {
            full_name: 'Administrador',
            username: 'admin',
            password: 'admin123',
            role: 'admin',
            active: true,
            created_by: null
          }
        ]);
      
      if (!error) {
        console.log('Usuário administrador padrão criado com sucesso');
      } else {
        console.error('Erro ao criar admin:', error);
      }
    } else {
      console.log('Admin já existe');
    }
  } catch (error) {
    console.error('Erro ao verificar admin padrão:', error);
  }
}