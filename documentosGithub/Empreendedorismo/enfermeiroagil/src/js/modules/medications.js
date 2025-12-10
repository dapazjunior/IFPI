import { getSupabase } from '../config/supabase.js';
import { APP_CONSTANTS, UTILS } from '../config/constants.js';
import authService from './auth.js';

class MedicationService {
  constructor() {
    this.medicationsCache = new Map();
    this.favoritesCache = null;
    this.categories = [
      'Analgésicos',
      'Antibióticos',
      'Anti-hipertensivos',
      'Anticoagulantes',
      'Broncodilatadores',
      'Diuréticos',
      'Hormônios',
      'Psicotrópicos',
      'Quimioterápicos',
      'Vacinas'
    ];
    
    this.routes = [
      'Oral',
      'Intravenosa (IV)',
      'Intramuscular (IM)',
      'Subcutânea (SC)',
      'Tópica',
      'Inalatória',
      'Retal',
      'Vaginal',
      'Oftálmica',
      'Otológica'
    ];
  }

  async searchMedications(query, filters = {}) {
    try {
      // Em produção, integrar com API de medicamentos
      // Por enquanto, usar dados mockados
      
      const mockMedications = this.getMockMedications();
      
      let results = mockMedications.filter(med => 
        med.name.toLowerCase().includes(query.toLowerCase()) ||
        med.activePrinciple.toLowerCase().includes(query.toLowerCase())
      );

      // Aplicar filtros
      if (filters.category) {
        results = results.filter(med => med.category === filters.category);
      }

      if (filters.route) {
        results = results.filter(med => 
          med.administrationRoutes.includes(filters.route)
        );
      }

      return {
        success: true,
        data: results.slice(0, 50),
        total: results.length
      };
      
    } catch (error) {
      console.error('Erro ao buscar medicamentos:', error);
      return { success: false, error: error.message };
    }
  }

  async getMedicationDetails(id) {
    try {
      // Verificar cache
      if (this.medicationsCache.has(id)) {
        return { 
          success: true, 
          data: this.medicationsCache.get(id) 
        };
      }

      // Buscar de API externa ou mock
      const mockMedications = this.getMockMedications();
      const medication = mockMedications.find(med => med.id === id);
      
      if (!medication) {
        throw new Error('Medicamento não encontrado');
      }

      // Adicionar ao cache
      this.medicationsCache.set(id, medication);
      
      return { success: true, data: medication };
      
    } catch (error) {
      console.error('Erro ao buscar detalhes do medicamento:', error);
      return { success: false, error: error.message };
    }
  }

  async getFavorites() {
    try {
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      const supabase = getSupabase();
      const user = authService.getUser();
      
      // Usar cache se disponível
      if (this.favoritesCache) {
        return { success: true, data: this.favoritesCache };
      }

      const { data, error } = await supabase
        .from('favorite_medications')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', { ascending: false });

      if (error) throw error;

      // Enriquecer com dados dos medicamentos
      const enrichedData = await Promise.all(
        data.map(async (fav) => {
          const medDetails = await this.getMedicationDetails(fav.medication_id);
          return {
            ...fav,
            medication: medDetails.success ? medDetails.data : null
          };
        })
      );

      this.favoritesCache = enrichedData;
      return { success: true, data: enrichedData };
      
    } catch (error) {
      console.error('Erro ao buscar favoritos:', error);
      return { success: false, error: error.message };
    }
  }

  async addFavorite(medicationId, customData = {}) {
    try {
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      const supabase = getSupabase();
      const user = authService.getUser();
      
      // Verificar se já é favorito
      const { data: existing } = await supabase
        .from('favorite_medications')
        .select('*')
        .eq('user_id', user.id)
        .eq('medication_id', medicationId)
        .single();

      if (existing) {
        throw new Error('Medicamento já está nos favoritos');
      }

      const { data, error } = await supabase
        .from('favorite_medications')
        .insert([{
          user_id: user.id,
          medication_id: medicationId,
          custom_name: customData.customName,
          dosage: customData.dosage,
          route: customData.route,
          frequency: customData.frequency,
          indications: customData.indications,
          created_at: new Date().toISOString()
        }])
        .select()
        .single();

      if (error) throw error;

      // Limpar cache
      this.favoritesCache = null;
      
      return { 
        success: true, 
        data,
        message: 'Medicamento adicionado aos favoritos!' 
      };
      
    } catch (error) {
      console.error('Erro ao adicionar favorito:', error);
      return { success: false, error: error.message };
    }
  }

  async removeFavorite(id) {
    try {
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      const supabase = getSupabase();
      const user = authService.getUser();
      
      const { error } = await supabase
        .from('favorite_medications')
        .delete()
        .eq('id', id)
        .eq('user_id', user.id);

      if (error) throw error;

      // Limpar cache
      this.favoritesCache = null;
      
      return { 
        success: true, 
        message: 'Medicamento removido dos favoritos!' 
      };
      
    } catch (error) {
      console.error('Erro ao remover favorito:', error);
      return { success: false, error: error.message };
    }
  }

  async updateFavorite(id, updateData) {
    try {
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      const supabase = getSupabase();
      const user = authService.getUser();
      
      const { data, error } = await supabase
        .from('favorite_medications')
        .update(updateData)
        .eq('id', id)
        .eq('user_id', user.id)
        .select()
        .single();

      if (error) throw error;

      // Limpar cache
      this.favoritesCache = null;
      
      return { 
        success: true, 
        data,
        message: 'Favorito atualizado!' 
      };
      
    } catch (error) {
      console.error('Erro ao atualizar favorito:', error);
      return { success: false, error: error.message };
    }
  }

  getCategories() {
    return { success: true, data: this.categories };
  }

  getRoutes() {
    return { success: true, data: this.routes };
  }

  // Dados mockados para desenvolvimento
  getMockMedications() {
    return [
      {
        id: 'med-001',
        name: 'Dipirona Monoidratada',
        activePrinciple: 'Dipirona',
        concentration: '500mg',
        presentation: 'Comprimido',
        category: 'Analgésicos',
        administrationRoutes: ['Oral'],
        indications: 'Analgesia e antipirese',
        contraindications: 'Hipersensibilidade, porfiria, gravidez',
        sideEffects: 'Reações alérgicas, hipotensão',
        dosage: 'Adultos: 500-1000mg a cada 6-8h. Máximo 4000mg/24h. Crianças: 10-15mg/kg/dose a cada 6-8h.',
        storage: 'Temperatura ambiente (15-30°C)',
        anvisaRegister: '10347020019',
        laboratory: 'Medley',
        precautions: 'Monitorar sinais de reação alérgica. Evitar uso prolongado.',
        interactions: 'Pode potencializar efeitos de anticoagulantes.'
      },
      {
        id: 'med-002',
        name: 'Amoxicilina',
        activePrinciple: 'Amoxicilina Tri-hidratada',
        concentration: '500mg',
        presentation: 'Cápsula',
        category: 'Antibióticos',
        administrationRoutes: ['Oral'],
        indications: 'Infecções bacterianas (respiratórias, urinárias, etc.)',
        contraindications: 'Hipersensibilidade a penicilinas',
        sideEffects: 'Diarréia, náuseas, reações alérgicas, candidíase',
        dosage: 'Adultos: 500mg a cada 8h ou 875mg a cada 12h. Crianças: 25-50mg/kg/dia dividido a cada 8h.',
        storage: 'Temperatura ambiente',
        anvisaRegister: '10110032007',
        laboratory: 'EMS',
        precautions: 'Administrar com alimentos para reduzir desconforto gástrico.',
        interactions: 'Anticoncepcionais podem ter eficácia reduzida.'
      },
      {
        id: 'med-003',
        name: 'Insulina Regular',
        activePrinciple: 'Insulina Humana',
        concentration: '100UI/mL',
        presentation: 'Frasco',
        category: 'Hormônios',
        administrationRoutes: ['Subcutânea (SC)', 'Intravenosa (IV)'],
        indications: 'Diabetes mellitus tipo 1 e 2',
        contraindications: 'Hipoglicemia, alergia à insulina',
        sideEffects: 'Hipoglicemia, lipodistrofia, reações alérgicas',
        dosage: 'Individualizada conforme glicemia. Início usual: 0.5-1UI/kg/dia.',
        storage: 'Refrigerar entre 2-8°C. Após aberto: até 28 dias em temperatura ambiente.',
        anvisaRegister: '10414005471',
        laboratory: 'Novo Nordisk',
        precautions: 'Rodar locais de aplicação. Monitorar glicemia capilar.',
        interactions: 'Efeito hipoglicemiante potencializado por álcool, betabloqueadores.'
      },
      {
        id: 'med-004',
        name: 'Heparina Sódica',
        activePrinciple: 'Heparina',
        concentration: '5000UI/mL',
        presentation: 'Frasco-ampola',
        category: 'Anticoagulantes',
        administrationRoutes: ['Subcutânea (SC)', 'Intravenosa (IV)'],
        indications: 'Prevenção e tratamento de trombose, embolia',
        contraindications: 'Hemorragia ativa, trombocitopenia induzida por heparina',
        sideEffects: 'Hemorragia, trombocitopenia, osteoporose (uso prolongado)',
        dosage: 'Profilaxia: 5000UI SC a cada 8-12h. Tratamento: bolus 80UI/kg IV, depois infusão 18UI/kg/h.',
        storage: 'Temperatura ambiente',
        anvisaRegister: '10043015358',
        laboratory: 'Blau',
        precautions: 'Monitorar TTPa e plaquetas. Antídoto: sulfato de protamina.',
        interactions: 'Potencializado por AAS, AINEs, anticoagulantes orais.'
      },
      {
        id: 'med-005',
        name: 'Furosemida',
        activePrinciple: 'Furosemida',
        concentration: '40mg',
        presentation: 'Comprimido',
        category: 'Diuréticos',
        administrationRoutes: ['Oral', 'Intravenosa (IV)'],
        indications: 'Edema (ICC, hepático, renal), hipertensão',
        contraindications: 'Anúria, desidratação, hipocalemia grave',
        sideEffects: 'Hipotensão, desidratação, hipocalemia, ototoxicidade',
        dosage: 'Adultos: 20-80mg/dia, máximo 600mg/dia. IV: 20-40mg, pode repetir.',
        storage: 'Temperatura ambiente',
        anvisaRegister: '10047028906',
        laboratory: 'Sanofi',
        precautions: 'Monitorar eletrólitos, função renal, PA. Administrar pela manhã.',
        interactions: 'Efeito diminuído por AINEs. Potencializa glicosídeos cardíacos.'
      }
    ];
  }

  getSimplifiedBula(medication) {
    return {
      nome: medication.name,
      principioAtivo: medication.activePrinciple,
      apresentacao: `${medication.concentration} - ${medication.presentation}`,
      indicacao: medication.indications,
      dose: medication.dosage,
      via: medication.administrationRoutes.join(', '),
      cuidados: medication.precautions,
      efeitosAdversos: medication.sideEffects,
      contraIndicacao: medication.contraindications,
      interacoes: medication.interactions,
      armazenamento: medication.storage
    };
  }

  getBulaForNursing(medication) {
    // Versão simplificada para enfermagem
    return {
      nome: medication.name,
      apresentacao: `${medication.concentration} - ${medication.presentation}`,
      doseUsual: medication.dosage.split('.')[0], // Primeira parte da dosagem
      via: medication.administrationRoutes.join(' ou '),
      cuidadosEnfermagem: `
        1. Verificar prescrição médica
        2. Confirmar alergias do paciente
        3. ${medication.precautions || 'Seguir protocolo padrão'}
        4. Observar reações adversas: ${medication.sideEffects?.split(',')[0] || 'nenhuma específica'}
        5. Registrar administração
      `.trim(),
      observacoes: medication.interactions ? 
        `Interações importantes: ${medication.interactions}` : 
        'Sem interações medicamentosas significativas'
    };
  }
}

// Exportar instância singleton
const medicationService = new MedicationService();
export default medicationService;