import { supabase, currentUserId, showToast } from './app.js';
import { escapeHtml } from './utils.js';

let typesData = [];

export async function loadDocumentsModule() {
  try {
    console.log('Carregando módulo de documentos...');
    
    const container = document.getElementById('documents-content');
    if (!container) {
      console.error('Container de documentos não encontrado');
      return;
    }

    // Carregar HTML do módulo
    try {
      const response = await fetch('components/documents-module.html');
      if (!response.ok) throw new Error('Falha ao carregar HTML');
      container.innerHTML = await response.text();
    } catch (error) {
      console.warn('Usando fallback para documentos-module');
      container.innerHTML = getDocumentsModuleFallback();
    }

    // Inicializar componentes
    await loadTypes();
    await loadCounters();
    await loadHistory();

    // Configurar event listeners
    setupDocumentEvents();
    
    console.log('Módulo de documentos carregado com sucesso!');

  } catch (error) {
    console.error('Erro ao carregar módulo de documentos:', error);
    showToast('Erro ao carregar documentos: ' + error.message, 'danger');
  }
}

function getDocumentsModuleFallback() {
  return `
    <div class="row g-4">
      <div class="col-lg-5">
        <div class="card mb-4 border-0 shadow-sm">
          <div class="card-header bg-primary text-white rounded-top-3">
            <strong><i class="bi bi-plus-circle"></i> Criar novo tipo de documento</strong>
          </div>
          <div class="card-body">
            <form id="formAddType" class="row g-3">
              <div class="col-12">
                <label class="form-label fw-semibold">Nome do tipo</label>
                <input id="typeName" class="form-control form-control-lg" placeholder="Ex: Nota Técnica" required>
              </div>
              <div class="col-6">
                <label class="form-label fw-semibold">Prefixo</label>
                <input id="typePrefix" class="form-control" placeholder="Ex: NT" required>
              </div>
              <div class="col-6">
                <label class="form-label fw-semibold">Número inicial</label>
                <input id="typeInitial" type="number" class="form-control" value="1" min="1">
              </div>
              <div class="col-12 pt-2">
                <button class="btn btn-success btn-lg w-100 py-2" type="submit">
                  <i class="bi bi-check-circle"></i> Adicionar Tipo
                </button>
              </div>
            </form>
          </div>
        </div>

        <div class="card border-0 shadow-sm">
          <div class="card-header bg-success text-white rounded-top-3">
            <strong><i class="bi bi-file-earmark-plus"></i> Gerar novo documento</strong>
          </div>
          <div class="card-body">
            <form id="formGenerate" class="row g-3">
              <div class="col-12">
                <label class="form-label fw-semibold">Tipo de documento</label>
                <select id="selectType" class="form-select" required>
                  <option value="">Carregando tipos...</option>
                </select>
              </div>
              <div class="col-12">
                <label class="form-label fw-semibold">Responsável</label>
                <input id="inputResponsible" class="form-control" placeholder="Seu nome" required>
              </div>
              <div class="col-12">
                <label class="form-label fw-semibold">Descrição (opcional)</label>
                <textarea id="inputDescription" class="form-control" placeholder="Assunto ou observação" rows="2"></textarea>
              </div>
              <div class="col-12 pt-2">
                <button class="btn btn-primary btn-lg w-100 py-2" type="submit">
                  <i class="bi bi-file-text"></i> Gerar Documento
                </button>
              </div>
            </form>

            <div id="lastGenerated" class="alert alert-info mt-4 d-none alert-dismissible fade show" role="alert">
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
              <div id="lastGeneratedContent"></div>
            </div>
          </div>
        </div>
      </div>

      <div class="col-lg-7">
        <div class="card mb-4 border-0 shadow-sm">
          <div class="card-header bg-light border-0">
            <strong><i class="bi bi-card-checklist"></i> Tipos cadastrados</strong>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-hover mb-0">
                <thead class="table-light">
                  <tr>
                    <th>Nome</th>
                    <th>Prefixo</th>
                    <th>Próx. Nº</th>
                    <th>Total</th>
                    <th>Ação</th>
                  </tr>
                </thead>
                <tbody id="typesTableBody">
                  <tr><td colspan="5" class="text-center py-4">Carregando...</td></tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <div class="card mb-4 border-0 shadow-sm">
          <div class="card-header bg-light border-0">
            <strong><i class="bi bi-speedometer2"></i> Contadores (visão)</strong>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-hover mb-0">
                <thead class="table-light">
                  <tr>
                    <th>Tipo</th>
                    <th>Próximo</th>
                    <th>Total</th>
                    <th>Última geração</th>
                    <th>Responsável</th>
                  </tr>
                </thead>
                <tbody id="countersBody">
                  <tr><td colspan="5" class="text-center py-4">Carregando...</td></tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <div class="card border-0 shadow-sm">
          <div class="card-header bg-light border-0">
            <strong><i class="bi bi-clock-history"></i> Histórico (últimos 50)</strong>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive" style="max-height: 360px; overflow:auto;">
              <table class="table table-hover mb-0">
                <thead class="table-light" style="position: sticky; top: 0; z-index: 1;">
                  <tr>
                    <th>Data</th>
                    <th>Tipo</th>
                    <th>Número</th>
                    <th>Responsável</th>
                    <th>Descrição</th>
                  </tr>
                </thead>
                <tbody id="historyBody">
                  <tr><td colspan="5" class="text-center py-4">Carregando...</td></tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  `;
}

async function loadTypes() {
  try {
    console.log('Carregando tipos de documentos...');
    
    const { data, error } = await supabase
      .from('document_types')
      .select('id, name, prefix, next_number, total_generated')
      .order('name', { ascending: true });

    if (error) {
      console.error('Erro ao carregar tipos:', error);
      throw error;
    }

    typesData = data || [];
    console.log(`Tipos carregados: ${typesData.length}`);
    
    // Popular select
    const selectType = document.getElementById('selectType');
    if (selectType) {
      selectType.innerHTML = '<option value="">Selecione um tipo</option>';
      typesData.forEach(t => {
        const opt = document.createElement('option');
        opt.value = t.id;
        opt.textContent = `${t.name} (${t.prefix})`;
        selectType.appendChild(opt);
      });
    }

    // Atualizar tabela de tipos
    const typesTableBody = document.getElementById('typesTableBody');
    if (typesTableBody) {
      typesTableBody.innerHTML = '';
      
      if (typesData.length === 0) {
        typesTableBody.innerHTML = `
          <tr><td colspan="5" class="text-center text-muted py-4">Nenhum tipo cadastrado</td></tr>
        `;
        return;
      }

      typesData.forEach(t => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
          <td class="fw-semibold">${escapeHtml(t.name)}</td>
          <td><span class="badge bg-secondary">${escapeHtml(t.prefix)}</span></td>
          <td><span class="badge bg-primary">${t.next_number}</span></td>
          <td><span class="badge bg-success">${t.total_generated}</span></td>
          <td>
            <button class="btn btn-sm btn-outline-primary" data-id="${t.id}" title="Gerar este tipo">
              <i class="bi bi-file-plus"></i> Gerar
            </button>
          </td>
        `;
        
        // Botão gerar direto por tipo
        tr.querySelector('button')?.addEventListener('click', () => {
          if (selectType) selectType.value = t.id;
          document.getElementById('inputResponsible')?.focus();
        });

        typesTableBody.appendChild(tr);
      });
    }

  } catch (error) {
    console.error('Erro ao carregar tipos:', error);
    showToast('Erro ao carregar tipos de documentos', 'danger');
  }
}

async function loadCounters() {
  try {
    console.log('Carregando contadores...');
    
    // Usar a view document_stats se existir, senão fazer manualmente
    let countersData;
    
    try {
      const { data, error } = await supabase
        .from('document_stats')
        .select('*')
        .order('name', { ascending: true });

      if (error) throw error;
      countersData = data || [];
    } catch (viewError) {
      console.warn('View document_stats não encontrada, usando query manual');
      
      const { data: types, error } = await supabase
        .from('document_types')
        .select('id, name, prefix, next_number, total_generated')
        .order('name', { ascending: true });

      if (error) throw error;
      
      countersData = await Promise.all(
        (types || []).map(async (type) => {
          const { data: lastDoc } = await supabase
            .from('documents')
            .select('responsible, created_at')
            .eq('type_id', type.id)
            .order('created_at', { ascending: false })
            .limit(1)
            .single();
          
          return {
            ...type,
            last_generated: lastDoc?.created_at || null,
            last_responsible: lastDoc?.responsible || '-'
          };
        })
      );
    }

    const countersBody = document.getElementById('countersBody');
    if (!countersBody) return;

    countersBody.innerHTML = '';

    if (!countersData || countersData.length === 0) {
      countersBody.innerHTML = `
        <tr><td colspan="5" class="text-center text-muted py-4">Nenhum contador disponível</td></tr>
      `;
      return;
    }

    // Renderizar tabela
    countersData.forEach(item => {
      const tr = document.createElement('tr');
      const lastGenerated = item.last_generated || item.created_at;
      
      tr.innerHTML = `
        <td>
          <div class="fw-semibold">${escapeHtml(item.name)}</div>
          <small class="text-muted">Prefixo: ${escapeHtml(item.prefix)}</small>
        </td>
        <td>
          <span class="badge bg-primary fs-6">${escapeHtml(item.prefix)}${item.next_number}</span>
        </td>
        <td>
          <span class="badge bg-success fs-6">${item.total_generated}</span>
        </td>
        <td><small>${lastGenerated ? new Date(lastGenerated).toLocaleString('pt-BR') : '-'}</small></td>
        <td><small>${escapeHtml(item.last_responsible || '-')}</small></td>
      `;
      countersBody.appendChild(tr);
    });

  } catch (error) {
    console.error('Erro em loadCounters:', error);
    showToast('Erro ao carregar contadores', 'danger');
  }
}

async function loadHistory() {
  try {
    console.log('Carregando histórico...');
    
    let historyData;
    
    // Tentar usar a view documents_with_type primeiro
    try {
      const { data, error } = await supabase
        .from('documents_with_type')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(50);

      if (error) throw error;
      historyData = data || [];
    } catch (viewError) {
      console.warn('View documents_with_type não encontrada, usando join manual');
      
      const { data, error } = await supabase
        .from('documents')
        .select(`
          *,
          document_types (
            name,
            prefix
          )
        `)
        .order('created_at', { ascending: false })
        .limit(50);

      if (error) throw error;
      
      historyData = (data || []).map(doc => ({
        ...doc,
        type_name: doc.document_types?.name || 'Desconhecido',
        type_prefix: doc.document_types?.prefix || '',
        full_number: (doc.document_types?.prefix || '') + doc.number
      }));
    }

    const historyBody = document.getElementById('historyBody');
    if (!historyBody) return;

    historyBody.innerHTML = '';

    if (!historyData || historyData.length === 0) {
      historyBody.innerHTML = `
        <tr><td colspan="5" class="text-center text-muted py-4">Nenhum documento gerado ainda</td></tr>
      `;
      return;
    }

    historyData.forEach(d => {
      const tr = document.createElement('tr');
      tr.innerHTML = `
        <td><small>${new Date(d.created_at).toLocaleString('pt-BR')}</small></td>
        <td>
          <div><strong>${escapeHtml(d.type_name || 'Desconhecido')}</strong></div>
          <small class="text-muted">${escapeHtml(d.type_prefix || '')}</small>
        </td>
        <td><span class="badge bg-dark">${escapeHtml(d.full_number || (d.type_prefix || '') + d.number)}</span></td>
        <td>${escapeHtml(d.responsible)}</td>
        <td><small class="text-muted">${escapeHtml(d.description || '-')}</small></td>
      `;
      historyBody.appendChild(tr);
    });

  } catch (error) {
    console.error('Erro ao carregar histórico:', error);
    showToast('Erro ao carregar histórico', 'danger');
  }
}

async function handleAddType(e) {
  e.preventDefault();
  console.log('Processando adição de tipo...');

  const name = document.getElementById('typeName').value.trim();
  const prefix = document.getElementById('typePrefix').value.trim().toUpperCase();
  const initial = Number(document.getElementById('typeInitial').value) || 1;

  if (!name || !prefix) {
    showToast('Preencha nome e prefixo.', 'warning');
    return;
  }

  const submitBtn = e.target.querySelector('button[type="submit"]');
  const originalText = submitBtn.innerHTML;
  submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Processando...';
  submitBtn.disabled = true;

  try {
    console.log(`Adicionando tipo: ${name} (${prefix})`);
    
    const { data, error } = await supabase
      .from('document_types')
      .insert([
        {
          name: name,
          prefix: prefix,
          next_number: initial,
          total_generated: 0
        }
      ])
      .select()
      .single();

    if (error) {
      console.error('Erro ao inserir tipo:', error);
      throw error;
    }

    // Limpar e recarregar
    e.target.reset();
    await Promise.all([loadTypes(), loadCounters()]);
    showToast(`Tipo "${name}" adicionado com sucesso!`, 'success');
    
  } catch (error) {
    console.error('Erro add type', error);
    showToast('Erro ao adicionar tipo: ' + error.message, 'danger');
  } finally {
    submitBtn.innerHTML = originalText;
    submitBtn.disabled = false;
  }
}

async function handleGenerateDocument(e) {
  e.preventDefault();
  console.log('Processando geração de documento...');

  const typeId = document.getElementById('selectType').value;
  const responsible = document.getElementById('inputResponsible').value.trim();
  const description = document.getElementById('inputDescription').value.trim();

  if (!typeId) {
    showToast('Selecione um tipo de documento.', 'warning');
    return;
  }
  if (!responsible) {
    showToast('Informe o responsável.', 'warning');
    document.getElementById('inputResponsible')?.focus();
    return;
  }

  const submitBtn = e.target.querySelector('button[type="submit"]');
  const originalText = submitBtn.innerHTML;
  submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Gerando...';
  submitBtn.disabled = true;

  try {
    // 1. Obter o próximo número
    const { data: typeData, error: typeError } = await supabase
      .from('document_types')
      .select('next_number, prefix, name, total_generated')
      .eq('id', typeId)
      .single();

    if (typeError) throw typeError;

    const nextNumber = typeData.next_number;
    const prefix = typeData.prefix;
    const typeName = typeData.name;

    // 2. Incrementar o próximo número
    const { error: updateError } = await supabase
      .from('document_types')
      .update({
        next_number: nextNumber + 1,
        total_generated: (typeData.total_generated || 0) + 1
      })
      .eq('id', typeId);

    if (updateError) throw updateError;

    // 3. Inserir o documento
    const { data: docData, error: docError } = await supabase
      .from('documents')
      .insert([
        {
          type_id: typeId,
          number: nextNumber,
          responsible: responsible,
          description: description || null
        }
      ])
      .select()
      .single();

    if (docError) throw docError;

    // 4. Mostrar o resultado
    const generatedDoc = {
      ...docData,
      type_name: typeName,
      type_prefix: prefix,
      full_number: `${prefix}${nextNumber}`
    };

    showLastGenerated(generatedDoc);
    await Promise.all([loadTypes(), loadCounters(), loadHistory()]);

    // Limpar campos
    document.getElementById('inputResponsible').value = '';
    document.getElementById('inputDescription').value = '';
    
    showToast(`Documento gerado: ${prefix}${nextNumber}`, 'success');
    
  } catch (error) {
    console.error('Erro ao gerar documento', error);
    showToast('Erro ao gerar documento: ' + error.message, 'danger');
  } finally {
    submitBtn.innerHTML = originalText;
    submitBtn.disabled = false;
  }
}

function showLastGenerated(row) {
  const lastGeneratedContent = document.getElementById('lastGeneratedContent');
  const lastGeneratedDiv = document.getElementById('lastGenerated');
  
  if (!lastGeneratedContent || !lastGeneratedDiv) return;
  
  lastGeneratedContent.innerHTML = `
    <div class="mb-2">
      <span class="badge bg-success fs-6">${escapeHtml(row.full_number)}</span>
    </div>
    <div><strong>Tipo:</strong> ${escapeHtml(row.type_name || '')} (${escapeHtml(row.type_prefix || '')})</div>
    <div><strong>Responsável:</strong> ${escapeHtml(row.responsible)}</div>
    <div><strong>Data:</strong> ${new Date(row.created_at).toLocaleString('pt-BR')}</div>
    ${row.description ? `<div class="mt-2"><strong>Descrição:</strong> ${escapeHtml(row.description)}</div>` : ''}
  `;
  lastGeneratedDiv.classList.remove('d-none');
}

function setupDocumentEvents() {
  console.log('Configurando eventos de documentos...');
  
  // Formulário de adicionar tipo
  const formAddType = document.getElementById('formAddType');
  if (formAddType) {
    formAddType.addEventListener('submit', handleAddType);
  }

  // Formulário de gerar documento
  const formGenerate = document.getElementById('formGenerate');
  if (formGenerate) {
    formGenerate.addEventListener('submit', handleGenerateDocument);
  }

  // Botão para fechar alerta do último documento gerado
  const lastGeneratedAlert = document.getElementById('lastGenerated');
  if (lastGeneratedAlert) {
    lastGeneratedAlert.addEventListener('closed.bs.alert', () => {
      lastGeneratedAlert.classList.add('d-none');
    });
  }
}