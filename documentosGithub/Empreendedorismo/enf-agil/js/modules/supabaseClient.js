/**
 * MÓDULO 1: supabaseClient.js
 */
import { createClient } from 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js/+esm';

// ⚠️ ATENÇÃO: Cole suas chaves reais AQUI, dentro das aspas!
// Vá no Supabase > Project Settings > API para pegar esses valores.

const SUPABASE_URL = 'https://payxrnrbsqjqmgcvvxah.supabase.co'; // Cole sua URL aqui
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBheXhybnJic3FqcW1nY3Z2eGFoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUyMjA5NTMsImV4cCI6MjA4MDc5Njk1M30.1nqTL1fKUZKyv4zwQhWSHgBLbVAdxA_HqCLLnrwBoLs'; // Cole sua ANON KEY aqui

// Validação simples
if (!SUPABASE_URL || !SUPABASE_ANON_KEY || SUPABASE_URL.includes('SUA_URL')) {
    console.error('ERRO: Você esqueceu de configurar as chaves do Supabase no arquivo supabaseClient.js!');
    alert('Erro de configuração: Chaves do Supabase não encontradas.');
}

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);