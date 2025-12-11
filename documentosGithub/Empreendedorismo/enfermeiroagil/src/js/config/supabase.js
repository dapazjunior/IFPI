// Configuração do Supabase
const SUPABASE_URL = 'https://eskczlbhjnmwyioojzyt.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVza2N6bGJoam5td3lpb29qenl0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzODk2MTgsImV4cCI6MjA4MDk2NTYxOH0.K9LCxM1JuU2T9h2WjQ_3eeUpJnBV1UfaOL_iW0Sp6Hc';

// Verificar se estamos no navegador
const isBrowser = typeof window !== 'undefined';

// Criar cliente Supabase apenas no navegador
let supabase = null;

if (isBrowser) {
  // Carregar dinamicamente para evitar problemas de importação
  import('https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm').then(({ createClient }) => {
    supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
      auth: {
        autoRefreshToken: true,
        persistSession: true,
        detectSessionInUrl: true,
        storage: window.localStorage
      },
      db: {
        schema: 'public'
      }
    });
    
    // Disponibilizar globalmente para os módulos
    window.supabaseClient = supabase;
    
    console.log('Supabase inicializado');
  }).catch(error => {
    console.error('Erro ao carregar Supabase:', error);
  });
}

// Função para obter o cliente de forma segura
export function getSupabase() {
  if (!isBrowser) {
    throw new Error('Supabase só pode ser usado no navegador');
  }
  
  if (!supabase && window.supabaseClient) {
    supabase = window.supabaseClient;
  }
  
  if (!supabase) {
    throw new Error('Supabase não foi inicializado');
  }
  
  return supabase;
}

// Exportar constantes
export { SUPABASE_URL, SUPABASE_ANON_KEY };