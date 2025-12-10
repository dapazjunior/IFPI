import { getSupabase } from '../config/supabase.js';
import { APP_CONSTANTS, UTILS } from '../config/constants.js';
import authService from './auth.js';

class AIService {
  constructor() {
    this.conversationHistory = [];
    this.isLoading = false;
    this.maxHistoryLength = 50;
  }

  async askQuestion(question, context = {}) {
    try {
      this.isLoading = true;
      this.showLoading();
      
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      // Preparar contexto do enfermeiro
      const nurseContext = this.buildNurseContext(context);
      
      // Em produção, isso chamaria uma API real de IA
      // Por enquanto, simularemos respostas baseadas em regras
      const answer = await this.simulateAIResponse(question, nurseContext);
      
      // Salvar no histórico local
      this.addToHistory({
        question,
        answer,
        timestamp: new Date().toISOString(),
        context: nurseContext
      });
      
      // Salvar no banco de dados
      await this.saveConversation(question, answer, nurseContext);
      
      this.hideLoading();
      return {
        success: true,
        data: {
          question,
          answer,
          timestamp: new Date().toISOString(),
          source: 'ai-assistant'
        }
      };
      
    } catch (error) {
      this.hideLoading();
      console.error('Erro no assistente IA:', error);
      return { 
        success: false, 
        error: 'Desculpe, não consegui processar sua pergunta no momento.' 
      };
    } finally {
      this.isLoading = false;
    }
  }

  buildNurseContext(additionalContext = {}) {
    const user = authService.getUser();
    const profile = user?.profile || {};
    
    return {
      professional: {
        role: profile.role || 'enfermeiro',
        specialization: profile.specialization || 'geral',
        institution: profile.institution || 'não informada'
      },
      patientContext: additionalContext.patient || null,
      setting: additionalContext.setting || 'hospitalar',
      time: new Date().toLocaleTimeString('pt-BR'),
      date: new Date().toLocaleDateString('pt-BR'),
      ...additionalContext
    };
  }

  async simulateAIResponse(question, context) {
    // Simulação de respostas baseadas em perguntas comuns
    const questionLower = question.toLowerCase().trim();
    
    // Banco de conhecimento em enfermagem
    const knowledgeBase = {
      // Medicamentos
      'como administrar': `A administração de medicamentos deve seguir os "10 certos" da enfermagem:
1. Paciente certo
2. Medicamento certo
3. Dose certa
4. Via certa
5. Horário certo
6. Registro certo
7. Resposta certa
8. Orientação certa
9. Forma certa
10. Avaliação certa

Sempre verifique a prescrição médica, confirme alergias e observe reações adversas.`,
      
      'dipirona': `Dipirona Monoidratada:
• Classe: Analgésico e antipirético
• Apresentações: Comprimidos 500mg, solução oral, ampola
• Dose adulto: 500-1000mg a cada 6-8h (máx 4000mg/24h)
• Dose criança: 10-15mg/kg/dose a cada 6-8h
• Via: Oral, IV, IM
• Cuidados: Monitorar reações alérgicas, evitar uso prolongado
• Contraindicações: Porfiria, alergia, gravidez (3º trimestre)
• Interações: Potencializa anticoagulantes`,
      
      'insulina': `Insulina:
• Tipos: Rápida (Regular), Intermediária (NPH), Lenta, Ultra-lenta
• Armazenamento: Fechada: 2-8°C. Aberta: até 28 dias em temperatura ambiente
• Administração SC: Rotacionar locais (abdômen, coxa, braço, glúteo)
• Técnica: Prega cutânea, ângulo 90° (45° para magros), aspirar levemente
• Monitoramento: Glicemia capilar antes e após administração
• Hipoglicemia: Administrar 15g de carboidrato simples (suco, balas)`,
      
      // Procedimentos
      'curativo': `Curativo estéril - Passo a passo:
1. Higienizar as mãos
2. Preparar material em campo estéril
3. Retirar curativo anterior (centro para borda)
4. Avaliar lesão (tamanho, cor, secreção, odor)
5. Limpar com SF 0,9% (centro para periferia em lesão infectada, periferia para centro em lesão limpa)
6. Secar com gazes estéreis
7. Aplicar pomada/cobertura conforme prescrição
8. Cobrir com gazes estéreis
9. Fixar com micropore/film
10. Registrar no prontuário

Trocar curativo: Diário ou conforme necessidade`,
      
      'sondagem nasogástrica': `Sondagem Nasogástrica:
• Medida: Ponta do nariz → lóbulo da orelha → processo xifoide
• Materiais: Sonda apropriada, lubrificante, fita, seringa 20ml, estetoscópio
• Técnica:
  1. Posicionar paciente sentado ou semi-Fowler
  2. Lubrificar sonda
  3. Inserir delicadamente pela narina
  4. Pedir para deglutir água (se consciente)
  5. Avançar até marcação
• Verificação:
  1. Aspirar conteúdo gástrico
  2. Insuflar ar e auscultar epigástrico
  3. Verificar pH do aspirado (<5)
• Fixação: Fita hipoalergênica no nariz e bochecha
• Contraindicações: Trauma facial, cirurgia nasal recente`,
      
      'punção venosa': `Punção Venosa Periférica:
• Materiais: Cateter adequado, garrote, álcool 70%, clorexidina, luvas, equipo
• Técnica:
  1. Escolher veia (dorsal da mão, antebraço)
  2. Garrotear proximalmente
  3. Antissepsia: álcool 70% → clorexidina 2% (circular, centro→periferia)
  4. Punção: Ângulo 15-30°, bevel para cima
  5. Verificar retorno sanguíneo
  6. Avançar cateter, retirar agulha
  7. Conectar equipo, fixar
• Cuidados: Trogar a cada 72-96h, observar sinais de flebite
• Escala de flebite: 0-4 (0=nenhuma, 4=tromboflebite)`,
      
      // Protocolos
      'reanimação cardiopulmonar': `RCP Adulto - Atualização 2023:
1. Verificar segurança da cena
2. Avaliar resposta: "Senhor(a), está bem?"
3. Chamar ajuda (192) e trazer DEA
4. Abrir vias aéreas (inclinação da cabeça, elevação do queixo)
5. Verificar respiração (ver, ouvir, sentir - máximo 10s)
6. Iniciar compressões:
   • Posição: Centro do tórax
   • Profundidade: 5-6 cm
   • Frequência: 100-120/min
   • Permitir recoil completo
7. Ventilações: 30 compressões : 2 ventilações
8. DEA: Ligar, seguir comandos de voz
• Ciclos: 2 minutos cada, trocar reanimador
• Parada: Quando retorno da circulação espontânea ou equipe médica assume`,
      
      'precauções padrão': `Precauções Padrão (Ministério da Saúde):
1. Higiene das mãos: Antes e após contato, após remover luvas
2. Uso de EPI conforme risco: Luvas, avental, máscara, óculos
3. Descarte adequado de perfurocortantes
4. Limpeza e desinfecção de equipamentos
5. Manejo adequado de roupas/lençóis
6. Higiene respiratória (etiqueta da tosse)
7. Uso de recipientes adequados para descarte
• Adicionais: Contato, gotículas, aerossóis conforme doença`,
      
      'escala de braden': `Escala de Braden - Avaliação de Risco para Úlcera por Pressão:
1. Percepção sensorial (1-4)
2. Umidade (1-4)
3. Atividade (1-4)
4. Mobilidade (1-4)
5. Nutrição (1-4)
6. Fricção/cisalhamento (1-3)

Pontuação:
• ≤9: Alto risco
• 10-12: Risco moderado
• 13-14: Baixo risco
• 15-18: Sem risco

Intervenções conforme pontuação`,
      
      // Evolução
      'evolução enfermagem': `Evolução de Enfermagem - Modelo SOAP:
S (Subjetivo): Queixas, relatos do paciente/família
O (Objetivo): Sinais vitais, exame físico, exames
A (Avaliação): Interpretação, análise, julgamento clínico
P (Plano): Intervenções, metas, educação

Registrar:
• Data, hora, assinatura e registro
• Linguagem clara, objetiva, sem abreviações
• Dados mensuráveis
• Respostas às intervenções
• Comunicação com equipe`,
      
      // Emergências
      'reação alérgica': `Reação Alérgica - Protocolo:
Leve a Moderada:
1. Suspender medicamento/agente causal
2. Manter vias aéreas
3. Administrar anti-histamínico (prometazina/difenidramina)
4. Corticosteroide (dexametasona)
5. Monitorar sinais vitais
6. Registrar detalhadamente

Anafilaxia:
1. Suspender agente causal
2. Posicionar decúbito dorsal, elevar MMII
3. Adrenalina IM 1:1000 (0,3-0,5mg adulto) - repetir a cada 5-15min se necessário
4. Suplementar O2 (8-10L/min)
5. Acesso venoso, SF 0,9%
6. Anti-histamínico + corticoide
7. β2-agonista se broncoespasmo
8. Monitorar continuamente`,
      
      // Geral
      'boas práticas': `Boas Práticas em Enfermagem:
1. Comunicação efetiva (SBAR, checklists)
2. Trabalho em equipe multidisciplinar
3. Prática baseada em evidências
4. Segurança do paciente (identificação, medicamentos, cirurgia segura)
5. Gestão de riscos
6. Educação continuada
7. Humanização do cuidado
8. Registro adequado
9. Autocuidado do profissional
10. Ética e bioética`
    };
    
    // Encontrar melhor correspondência
    let bestMatch = '';
    let maxScore = 0;
    let matchedKey = '';
    
    for (const [key, response] of Object.entries(knowledgeBase)) {
      const score = this.calculateMatchScore(questionLower, key);
      if (score > maxScore) {
        maxScore = score;
        bestMatch = response;
        matchedKey = key;
      }
    }
    
    // Se não encontrar boa correspondência
    if (maxScore < 0.3) {
      return this.getGenericResponse(question, context);
    }
    
    // Adicionar disclaimer
    return `${bestMatch}

---
*Esta resposta é baseada em protocolos gerais de enfermagem. 
Sempre consulte: 
1. Protocolos específicos da sua instituição
2. Prescrição médica atualizada
3. Supervisor/enfermeiro chefe para orientações específicas
4. Literatura científica recente

Contexto profissional: ${context.professional.role} - ${context.professional.specialization}*`;
  }

  calculateMatchScore(question, pattern) {
    const questionWords = question.split(/\s+/);
    const patternWords = pattern.split(/\s+/);
    
    let matches = 0;
    for (const qWord of questionWords) {
      if (qWord.length < 3) continue;
      for (const pWord of patternWords) {
        if (qWord.includes(pWord) || pWord.includes(qWord)) {
          matches++;
          break;
        }
      }
    }
    
    return matches / Math.max(questionWords.length, patternWords.length);
  }

  getGenericResponse(question, context) {
    return `Sobre "${question}", como ${context.professional.role}, recomendo:

**Para uma resposta mais precisa:**
1. Forneça mais detalhes do contexto clínico
2. Especifique se é para um paciente específico
3. Informe a situação atual

**Fontes para consulta:**
• Manual de procedimentos da instituição
• Protocolos do Ministério da Saúde/ANVISA
• Literaturas atualizadas (SOBEN, Cofen)
• Supervisor/enfermeiro chefe

**Áreas comuns de dúvida em enfermagem:**
- Administração de medicamentos
- Procedimentos técnicos
- Cálculos de medicação
- Cuidados com feridas
- Manejo de dispositivos
- Educação em saúde
- Registro de enfermagem

Posso ajudar com informações mais específicas se você detalhar sua dúvida!`;
  }

  addToHistory(conversation) {
    this.conversationHistory.unshift(conversation);
    
    // Limitar histórico
    if (this.conversationHistory.length > this.maxHistoryLength) {
      this.conversationHistory = this.conversationHistory.slice(0, this.maxHistoryLength);
    }
    
    // Salvar no localStorage
    this.saveHistoryToStorage();
    
    // Atualizar UI se existir
    this.updateHistoryUI();
  }

  async saveConversation(question, answer, context) {
    try {
      const supabase = getSupabase();
      const user = authService.getUser();
      
      await supabase
        .from('ai_conversations')
        .insert([{
          user_id: user.id,
          question,
          answer,
          context: JSON.stringify(context),
          created_at: new Date().toISOString()
        }]);
        
    } catch (error) {
      console.error('Erro ao salvar conversa:', error);
    }
  }

  async getConversationHistory(limit = 20) {
    try {
      if (!authService.isAuthenticated()) {
        return { success: true, data: this.conversationHistory.slice(0, limit) };
      }

      const supabase = getSupabase();
      const user = authService.getUser();
      
      const { data, error } = await supabase
        .from('ai_conversations')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false })
        .limit(limit);

      if (error) throw error;

      return { success: true, data };
      
    } catch (error) {
      console.error('Erro ao buscar histórico:', error);
      return { success: false, error: error.message };
    }
  }

  saveHistoryToStorage() {
    try {
      localStorage.setItem(
        'ai_conversation_history',
        JSON.stringify(this.conversationHistory)
      );
    } catch (error) {
      console.error('Erro ao salvar histórico:', error);
    }
  }

  loadHistoryFromStorage() {
    try {
      const saved = localStorage.getItem('ai_conversation_history');
      if (saved) {
        this.conversationHistory = JSON.parse(saved);
      }
    } catch (error) {
      console.error('Erro ao carregar histórico:', error);
    }
  }

  clearHistory() {
    this.conversationHistory = [];
    this.saveHistoryToStorage();
    this.updateHistoryUI();
  }

  updateHistoryUI() {
    // Esta função seria chamada pela UI para atualizar o histórico
    const historyElement = document.getElementById('ai-conversation-history');
    if (historyElement) {
      // Implementação específica da UI
    }
  }

  showLoading() {
    const loader = document.getElementById('ai-loader');
    if (loader) loader.style.display = 'block';
  }

  hideLoading() {
    const loader = document.getElementById('ai-loader');
    if (loader) loader.style.display = 'none';
  }

  getSuggestedQuestions() {
    return [
      'Como administrar medicamento endovenoso?',
      'Qual a dose de dipirona para adulto?',
      'Como fazer curativo estéril?',
      'Quais são as precauções padrão?',
      'Como avaliar risco para úlcera por pressão?',
      'Passos para punção venosa?',
      'Como registrar evolução de enfermagem?',
      'O que fazer em caso de reação alérgica?',
      'Como calcular gotejamento de soro?',
      'Cuidados com paciente diabético?'
    ];
  }

  // Métodos específicos para enfermagem
  calculateDripRate(volume, time, dropFactor = 20) {
    // Cálculo de gotejamento
    const minutes = time * 60;
    return Math.round((volume * dropFactor) / minutes);
  }

  getMedicationCalculations() {
    return {
      pediatricDose: (adultDose, childWeight) => {
        // Fórmula de Clark
        return (childWeight * adultDose) / 70;
      },
      bsaDose: (dosePerM2, bsa) => {
        return dosePerM2 * bsa;
      },
      dripRate: this.calculateDripRate
    };
  }
}

// Exportar instância singleton
const aiService = new AIService();
export default aiService;