import { getSupabase } from '../config/supabase.js';
import { APP_CONSTANTS } from '../config/constants.js';

class AuthService {
  constructor() {
    this.currentUser = null;
    this.userProfile = null;
    this.initialized = false;
    this.init();
  }

  async init() {
    try {
      const supabase = getSupabase();
      
      // Verificar sessão existente
      const { data: { session } } = await supabase.auth.getSession();
      
      if (session) {
        this.currentUser = session.user;
        await this.loadUserProfile();
        console.log('Usuário autenticado:', this.currentUser.email);
      }
      
      // Escutar mudanças de autenticação
      supabase.auth.onAuthStateChange((event, session) => {
        console.log('Auth state changed:', event);
        
        if (event === 'SIGNED_IN') {
          this.currentUser = session.user;
          this.loadUserProfile();
          this.redirectToDashboard();
        } else if (event === 'SIGNED_OUT') {
          this.currentUser = null;
          this.userProfile = null;
          this.redirectToLogin();
        }
      });
      
      this.initialized = true;
      
    } catch (error) {
      console.error('Erro ao inicializar autenticação:', error);
    }
  }

  async login(email, password) {
    try {
      this.showLoading();
      
      const supabase = getSupabase();
      const { data, error } = await supabase.auth.signInWithPassword({
        email: email.trim().toLowerCase(),
        password
      });

      if (error) throw error;

      this.currentUser = data.user;
      await this.loadUserProfile();
      
      this.hideLoading();
      return { 
        success: true, 
        user: data.user,
        redirect: '/pages/app/dashboard.html'
      };
      
    } catch (error) {
      this.hideLoading();
      console.error('Erro no login:', error);
      
      let message = 'Erro ao fazer login. Verifique suas credenciais.';
      if (error.message.includes('Invalid login credentials')) {
        message = 'Email ou senha incorretos.';
      }
      
      return { success: false, error: message };
    }
  }

  async register(userData) {
    try {
      this.showLoading();
      
      // Validar dados
      if (userData.password !== userData.confirmPassword) {
        throw new Error('As senhas não coincidem.');
      }
      
      const supabase = getSupabase();
      
      // Registrar no Auth
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email: userData.email.trim().toLowerCase(),
        password: userData.password,
        options: {
          data: {
            full_name: userData.fullName,
            role: userData.role,
            cpf: userData.cpf
          }
        }
      });

      if (authError) throw authError;

      // Criar perfil
      const { error: profileError } = await supabase
        .from('profiles')
        .insert([{
          id: authData.user.id,
          full_name: userData.fullName,
          cpf: userData.cpf,
          professional_id: userData.professionalId,
          role: userData.role,
          specialization: userData.specialization,
          institution: userData.institution,
          phone: userData.phone
        }]);

      if (profileError) {
        // Se erro no perfil, deletar usuário auth
        await supabase.auth.admin.deleteUser(authData.user.id);
        throw profileError;
      }

      this.hideLoading();
      return { 
        success: true, 
        user: authData.user,
        message: 'Conta criada com sucesso! Você já pode fazer login.'
      };
      
    } catch (error) {
      this.hideLoading();
      console.error('Erro no registro:', error);
      return { success: false, error: error.message };
    }
  }

  async logout() {
    try {
      const supabase = getSupabase();
      const { error } = await supabase.auth.signOut();
      
      if (error) throw error;
      
      this.currentUser = null;
      this.userProfile = null;
      
      window.location.href = '/pages/auth/login.html';
      
    } catch (error) {
      console.error('Erro no logout:', error);
    }
  }

  async loadUserProfile() {
    if (!this.currentUser) return null;

    try {
      const supabase = getSupabase();
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', this.currentUser.id)
        .single();

      if (error) throw error;

      this.userProfile = data;
      return data;
      
    } catch (error) {
      console.error('Erro ao carregar perfil:', error);
      return null;
    }
  }

  async resetPassword(email) {
    try {
      const supabase = getSupabase();
      const { error } = await supabase.auth.resetPasswordForEmail(email, {
        redirectTo: `${window.location.origin}/pages/auth/reset-password.html`
      });

      if (error) throw error;

      return { 
        success: true, 
        message: 'Email de recuperação enviado! Verifique sua caixa de entrada.'
      };
      
    } catch (error) {
      console.error('Erro ao resetar senha:', error);
      return { success: false, error: error.message };
    }
  }

  isAuthenticated() {
    return this.currentUser !== null;
  }

  getUser() {
    return this.currentUser;
  }

  getUserProfile() {
    return this.userProfile;
  }

  getUserRole() {
    return this.userProfile?.role || null;
  }

  hasPermission(requiredRole) {
    const userRole = this.getUserRole();
    if (!userRole) return false;
    
    const roleHierarchy = {
      'admin': 4,
      'enfermeiro': 3,
      'tecnico': 2,
      'estudante': 1
    };
    
    return roleHierarchy[userRole] >= (roleHierarchy[requiredRole] || 0);
  }

  redirectToDashboard() {
    if (window.location.pathname.includes('/auth/')) {
      window.location.href = '/pages/app/dashboard.html';
    }
  }

  redirectToLogin() {
    if (!window.location.pathname.includes('/auth/')) {
      window.location.href = '/pages/auth/login.html';
    }
  }

  showLoading() {
    const loader = document.getElementById('global-loader');
    if (loader) loader.style.display = 'flex';
  }

  hideLoading() {
    const loader = document.getElementById('global-loader');
    if (loader) loader.style.display = 'none';
  }

  requireAuth() {
    if (!this.isAuthenticated()) {
      this.redirectToLogin();
      return false;
    }
    return true;
  }
}

// Exportar instância singleton
const authService = new AuthService();
export default authService;