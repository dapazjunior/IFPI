import { getSupabase } from '../config/supabase.js';
import { APP_CONSTANTS, UTILS } from '../config/constants.js';
import authService from './auth.js';

class PatientService {
  constructor() {
    this.currentPatient = null;
    this.patientsCache = [];
    this.filters = {
      search: '',
      priority: '',
      isActive: true
    };
  }

  async getPatients(filters = {}, page = 1, limit = 10) {
    try {
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      const supabase = getSupabase();
      const user = authService.getUser();
      
      let query = supabase
        .from('patients')
        .select('*', { count: 'exact' })
        .eq('user_id', user.id)
        .eq('is_active', true);

      // Aplicar filtros
      if (filters.search) {
        query = query.or(`name.ilike.%${filters.search}%,bed_number.ilike.%${filters.search}%,room.ilike.%${filters.search}%`);
      }

      if (filters.priority) {
        query = query.eq('priority', filters.priority);
      }

      // Ordenação
      query = query.order('created_at', { ascending: false });

      // Paginação
      const from = (page - 1) * limit;
      const to = from + limit - 1;
      query = query.range(from, to);

      const { data, error, count } = await query;

      if (error) throw error;

      return {
        success: true,
        data,
        pagination: {
          page,
          limit,
          total: count || 0,
          totalPages: Math.ceil((count || 0) / limit)
        }
      };
      
    } catch (error) {
      console.error('Erro ao buscar pacientes:', error);
      return { success: false, error: error.message };
    }
  }

  async getPatient(id) {
    try {
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      const supabase = getSupabase();
      
      const { data, error } = await supabase
        .from('patients')
        .select(`
          *,
          nursing_notes(*),
          medication_administered(*)
        `)
        .eq('id', id)
        .single();

      if (error) throw error;

      // Verificar permissão
      const user = authService.getUser();
      if (data.user_id !== user.id) {
        throw new Error('Acesso não autorizado');
      }

      this.currentPatient = data;
      return { success: true, data };
      
    } catch (error) {
      console.error('Erro ao buscar paciente:', error);
      return { success: false, error: error.message };
    }
  }

  async createPatient(patientData) {
    try {
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      const supabase = getSupabase();
      const user = authService.getUser();
      
      const patient = {
        ...patientData,
        user_id: user.id,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      };

      const { data, error } = await supabase
        .from('patients')
        .insert([patient])
        .select()
        .single();

      if (error) throw error;

      // Limpar cache
      this.patientsCache = [];
      
      return { 
        success: true, 
        data,
        message: 'Paciente cadastrado com sucesso!' 
      };
      
    } catch (error) {
      console.error('Erro ao criar paciente:', error);
      return { success: false, error: error.message };
    }
  }

  async updatePatient(id, patientData) {
    try {
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      const supabase = getSupabase();
      
      const { data, error } = await supabase
        .from('patients')
        .update({
          ...patientData,
          updated_at: new Date().toISOString()
        })
        .eq('id', id)
        .select()
        .single();

      if (error) throw error;

      // Limpar cache
      this.patientsCache = [];
      
      return { 
        success: true, 
        data,
        message: 'Paciente atualizado com sucesso!' 
      };
      
    } catch (error) {
      console.error('Erro ao atualizar paciente:', error);
      return { success: false, error: error.message };
    }
  }

  async deletePatient(id) {
    try {
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      const supabase = getSupabase();
      
      const { error } = await supabase
        .from('patients')
        .update({ 
          is_active: false,
          updated_at: new Date().toISOString()
        })
        .eq('id', id);

      if (error) throw error;

      // Limpar cache
      this.patientsCache = [];
      
      return { 
        success: true, 
        message: 'Paciente removido com sucesso!' 
      };
      
    } catch (error) {
      console.error('Erro ao deletar paciente:', error);
      return { success: false, error: error.message };
    }
  }

  async createNursingNote(patientId, noteData) {
    try {
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      const supabase = getSupabase();
      const user = authService.getUser();
      
      const note = {
        patient_id: patientId,
        user_id: user.id,
        ...noteData,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      };

      const { data, error } = await supabase
        .from('nursing_notes')
        .insert([note])
        .select()
        .single();

      if (error) throw error;

      return { 
        success: true, 
        data,
        message: 'Evolução registrada com sucesso!' 
      };
      
    } catch (error) {
      console.error('Erro ao criar evolução:', error);
      return { success: false, error: error.message };
    }
  }

  async getNursingNotes(patientId, filters = {}) {
    try {
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      const supabase = getSupabase();
      
      let query = supabase
        .from('nursing_notes')
        .select('*, profiles(full_name)')
        .eq('patient_id', patientId)
        .order('created_at', { ascending: false });

      if (filters.note_type) {
        query = query.eq('note_type', filters.note_type);
      }

      const { data, error } = await query;

      if (error) throw error;

      return { success: true, data };
      
    } catch (error) {
      console.error('Erro ao buscar evoluções:', error);
      return { success: false, error: error.message };
    }
  }

  async getStatistics() {
    try {
      if (!authService.isAuthenticated()) {
        throw new Error('Usuário não autenticado');
      }

      const supabase = getSupabase();
      const user = authService.getUser();
      
      // Total de pacientes
      const { count: totalPatients, error: patientsError } = await supabase
        .from('patients')
        .select('*', { count: 'exact', head: true })
        .eq('user_id', user.id)
        .eq('is_active', true);

      if (patientsError) throw patientsError;

      // Pacientes por prioridade
      const { data: priorityData, error: priorityError } = await supabase
        .from('patients')
        .select('priority')
        .eq('user_id', user.id)
        .eq('is_active', true);

      if (priorityError) throw priorityError;

      const priorityStats = {
        alta: priorityData.filter(p => p.priority === 'alta').length,
        media: priorityData.filter(p => p.priority === 'media').length,
        baixa: priorityData.filter(p => p.priority === 'baixa').length
      };

      // Evoluções dos últimos 7 dias
      const sevenDaysAgo = new Date();
      sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
      
      const { count: recentNotes, error: notesError } = await supabase
        .from('nursing_notes')
        .select('*', { count: 'exact', head: true })
        .eq('user_id', user.id)
        .gte('created_at', sevenDaysAgo.toISOString());

      if (notesError) throw notesError;

      return {
        success: true,
        data: {
          totalPatients: totalPatients || 0,
          priorityStats,
          recentNotes: recentNotes || 0
        }
      };
      
    } catch (error) {
      console.error('Erro ao buscar estatísticas:', error);
      return { success: false, error: error.message };
    }
  }

  // Templates de evolução
  getDefaultTemplates() {
    return [
      {
        id: 'template-evolucao',
        name: 'Evolução Padrão',
        content: `Paciente em estado geral [estado].
Consciente, orientado, [outros].
PA: [valor] mmHg, FC: [valor] bpm, FR: [valor] rpm, T: [valor]°C.
Realizado [procedimentos].
Medicações administradas conforme prescrição.
Permanecer em observação.`,
        category: 'evolucao'
      },
      {
        id: 'template-medicacao',
        name: 'Administração de Medicamento',
        content: `Administrado [medicamento] [dose] [via] às [horário].
Local de punção: [local].
Sem intercorrências.
Paciente tolerou bem o procedimento.`,
        category: 'medicacao'
      },
      {
        id: 'template-procedimento',
        name: 'Procedimento Realizado',
        content: `Realizado [procedimento] às [horário].
Técnica: [descrição].
Materiais utilizados: [materiais].
Paciente colaborou durante o procedimento.
Sem intercorrências.`,
        category: 'procedimento'
      }
    ];
  }

  // Métodos auxiliares para UI
  formatPatientForDisplay(patient) {
    return {
      ...patient,
      formattedCreatedAt: UTILS.formatDate(patient.created_at),
      formattedUpdatedAt: UTILS.formatDate(patient.updated_at),
      priorityColor: UTILS.getPriorityColor(patient.priority),
      priorityText: UTILS.getPriorityText(patient.priority)
    };
  }
}

// Exportar instância singleton
const patientService = new PatientService();
export default patientService;