// supabaseClient.js
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.38.4';

// Substitua com suas credenciais do Supabase
const SUPABASE_URL = 'https://bybgvuxcfzklqegvwcpy.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ5Ymd2dXhjZnprbHFlZ3Z3Y3B5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ3OTcwMjIsImV4cCI6MjA4MDM3MzAyMn0.WMEM_fzFKc4XgIBFtQdDFk6LwgPQ95M3UUZke9TCg1E';

// Criar cliente do Supabase
export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
    auth: {
        autoRefreshToken: true,
        persistSession: true,
        detectSessionInUrl: true
    }
});

// Helper para verificar sessão
export async function getCurrentUser() {
    const { data: { user }, error } = await supabase.auth.getUser();
    return { user, error };
}

// Helper para pegar token
export async function getSession() {
    const { data: { session }, error } = await supabase.auth.getSession();
    return { session, error };
}