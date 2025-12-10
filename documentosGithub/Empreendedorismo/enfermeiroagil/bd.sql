-- 1. Primeiro criar as tabelas que não dependem de outras
CREATE TABLE profiles (
  id UUID REFERENCES auth.users PRIMARY KEY,
  full_name TEXT,
  cpf TEXT UNIQUE,
  professional_id TEXT,
  role TEXT CHECK (role IN ('enfermeiro', 'tecnico', 'estudante', 'admin')),
  specialization TEXT,
  institution TEXT,
  phone TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Tabela de Templates de Evolução (não depende de nursing_notes ainda)
CREATE TABLE note_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id),
  name TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT,
  is_public BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Tabela de Pacientes
CREATE TABLE patients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id),
  name TEXT NOT NULL,
  bed_number TEXT,
  room TEXT,
  priority TEXT CHECK (priority IN ('alta', 'media', 'baixa')),
  age INTEGER,
  gender TEXT,
  main_diagnosis TEXT,
  allergies TEXT[],
  notes TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Agora criar nursing_notes que depende de patients e note_templates
CREATE TABLE nursing_notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id),
  note_type TEXT CHECK (note_type IN ('evolucao', 'medicacao', 'procedimento', 'observacao')),
  content TEXT NOT NULL,
  template_id UUID REFERENCES note_templates(id) ON DELETE SET NULL,
  tags TEXT[],
  is_private BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Tabela de Medicamentos Favoritos
CREATE TABLE favorite_medications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id),
  medication_id TEXT,
  custom_name TEXT,
  dosage TEXT,
  route TEXT,
  frequency TEXT,
  indications TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Tabela de Protocolos e Boas Práticas
CREATE TABLE protocols (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT,
  tags TEXT[],
  source TEXT,
  is_approved BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. Tabela de Conversas com IA
CREATE TABLE ai_conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id),
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  context TEXT,
  feedback INTEGER CHECK (feedback >= 1 AND feedback <= 5),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 8. Tabela de Equipes
CREATE TABLE teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 9. Tabela de Membros da Equipe
CREATE TABLE team_members (
  team_id UUID REFERENCES teams(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  role TEXT CHECK (role IN ('owner', 'member', 'viewer')),
  PRIMARY KEY (team_id, user_id)
);

-- 10. Tabela de Logs de Atividade
CREATE TABLE activity_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id),
  action TEXT NOT NULL,
  resource_type TEXT,
  resource_id UUID,
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 11. Tabela para Compartilhamento de Pacientes
CREATE TABLE shared_patients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
  shared_by UUID REFERENCES profiles(id),
  shared_with UUID REFERENCES profiles(id),
  permission_level TEXT CHECK (permission_level IN ('view', 'edit')),
  expires_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(patient_id, shared_with)
);

-- 12. Tabela para Histórico de Medicamentos Administrados
CREATE TABLE medication_administered (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID REFERENCES patients(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id),
  medication_name TEXT NOT NULL,
  dosage TEXT NOT NULL,
  route TEXT NOT NULL,
  administered_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para melhor performance
CREATE INDEX idx_patients_user_id ON patients(user_id);
CREATE INDEX idx_patients_is_active ON patients(is_active);
CREATE INDEX idx_nursing_notes_patient_id ON nursing_notes(patient_id);
CREATE INDEX idx_nursing_notes_user_id ON nursing_notes(user_id);
CREATE INDEX idx_nursing_notes_created_at ON nursing_notes(created_at DESC);
CREATE INDEX idx_favorite_medications_user_id ON favorite_medications(user_id);
CREATE INDEX idx_ai_conversations_user_id ON ai_conversations(user_id);
CREATE INDEX idx_ai_conversations_created_at ON ai_conversations(created_at DESC);
CREATE INDEX idx_activity_logs_user_id ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at DESC);
CREATE INDEX idx_shared_patients_patient_id ON shared_patients(patient_id);
CREATE INDEX idx_shared_patients_shared_with ON shared_patients(shared_with);

-- Políticas RLS (Row Level Security)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE nursing_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE note_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorite_medications ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE shared_patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE medication_administered ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para profiles
CREATE POLICY "Usuários podem ver apenas seu próprio perfil" ON profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Usuários podem atualizar apenas seu próprio perfil" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Políticas RLS para patients
CREATE POLICY "Usuários podem ver seus próprios pacientes" ON patients
  FOR SELECT USING (auth.uid() = user_id OR 
    EXISTS (SELECT 1 FROM shared_patients 
            WHERE shared_patients.patient_id = patients.id 
            AND shared_patients.shared_with = auth.uid()));

CREATE POLICY "Usuários podem criar pacientes" ON patients
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuários podem atualizar seus próprios pacientes" ON patients
  FOR UPDATE USING (auth.uid() = user_id OR
    EXISTS (SELECT 1 FROM shared_patients 
            WHERE shared_patients.patient_id = patients.id 
            AND shared_patients.shared_with = auth.uid()
            AND shared_patients.permission_level = 'edit'));

CREATE POLICY "Usuários podem deletar apenas seus próprios pacientes" ON patients
  FOR DELETE USING (auth.uid() = user_id);

-- Políticas RLS para nursing_notes
CREATE POLICY "Usuários podem ver anotações de seus pacientes" ON nursing_notes
  FOR SELECT USING (
    auth.uid() = user_id OR
    (EXISTS (SELECT 1 FROM patients 
             WHERE patients.id = nursing_notes.patient_id 
             AND patients.user_id = auth.uid())) OR
    (EXISTS (SELECT 1 FROM shared_patients 
             WHERE shared_patients.patient_id = nursing_notes.patient_id 
             AND shared_patients.shared_with = auth.uid()))
  );

CREATE POLICY "Usuários podem criar anotações" ON nursing_notes
  FOR INSERT WITH CHECK (
    auth.uid() = user_id AND
    (EXISTS (SELECT 1 FROM patients 
             WHERE patients.id = nursing_notes.patient_id 
             AND patients.user_id = auth.uid()))
  );

-- Políticas RLS para note_templates
CREATE POLICY "Usuários podem ver templates públicos ou próprios" ON note_templates
  FOR SELECT USING (is_public = true OR auth.uid() = user_id);

CREATE POLICY "Usuários podem criar templates" ON note_templates
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuários podem atualizar seus próprios templates" ON note_templates
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem deletar seus próprios templates" ON note_templates
  FOR DELETE USING (auth.uid() = user_id);

-- Políticas RLS para favorite_medications
CREATE POLICY "Usuários podem ver apenas seus medicamentos favoritos" ON favorite_medications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem gerenciar seus medicamentos favoritos" ON favorite_medications
  FOR ALL USING (auth.uid() = user_id);

-- Políticas RLS para ai_conversations
CREATE POLICY "Usuários podem ver apenas suas conversas com IA" ON ai_conversations
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem criar conversas com IA" ON ai_conversations
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Função para atualizar o campo updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para campos updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_patients_updated_at BEFORE UPDATE ON patients
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_nursing_notes_updated_at BEFORE UPDATE ON nursing_notes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Função para registrar logs de atividade automaticamente
CREATE OR REPLACE FUNCTION log_activity()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO activity_logs (user_id, action, resource_type, resource_id)
    VALUES (NEW.user_id, 'CREATE', TG_TABLE_NAME, NEW.id);
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO activity_logs (user_id, action, resource_type, resource_id)
    VALUES (NEW.user_id, 'UPDATE', TG_TABLE_NAME, NEW.id);
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO activity_logs (user_id, action, resource_type, resource_id)
    VALUES (OLD.user_id, 'DELETE', TG_TABLE_NAME, OLD.id);
  END IF;
  RETURN NULL;
END;
$$ language 'plpgsql';

-- Triggers para logs de atividade
CREATE TRIGGER log_patient_activity AFTER INSERT OR UPDATE OR DELETE ON patients
  FOR EACH ROW EXECUTE FUNCTION log_activity();

CREATE TRIGGER log_note_activity AFTER INSERT OR UPDATE OR DELETE ON nursing_notes
  FOR EACH ROW EXECUTE FUNCTION log_activity();

-- Inserir alguns protocolos padrão
INSERT INTO protocols (title, content, category, tags, source) VALUES
('Administração de Medicamentos Endovenosos', 'Verificar: 1. Prescrição médica; 2. Identificação do paciente; 3. Medicamento, dose, via e horário; 4. Data de validade; 5. Compatibilidade; 6. Sítio de punção.', 'medicacao', ARRAY['IV', 'segurança', 'medicação'], 'Protocolo Hospitalar'),
('Prevenção de Úlcera por Pressão', '1. Avaliar risco (Escala de Braden); 2. Reposicionar a cada 2h; 3. Uso de superficiais especiais; 4. Inspeção diária da pele; 5. Manutenção da integridade cutânea.', 'cuidados', ARRAY['UPP', 'prevenção', 'pele'], 'Consenso Nacional'),
('Coleta de Hemocultura', '1. Higienizar as mãos; 2. Identificar paciente; 3. Preparar material estéril; 4. Antissepsia do local (álcool 70% + clorexidina); 5. Coletar 10-20ml por frasco; 6. Identificar amostras.', 'coleta', ARRAY['exames', 'sangue', 'infecção'], 'Manual de Coleta');

-- Criar usuário admin padrão (senha: Admin123)
-- Nota: Execute após criar um usuário manualmente no painel do Supabase