import { supabase, currentUserId, showToast } from './app.js';

const BUCKET_NAME = 'complaint-attachments';

export async function uploadFiles(files, complaintId, description = '') {
  const progressBar = document.getElementById('attachmentProgress');
  const progressBarInner = progressBar ? progressBar.querySelector('.progress-bar') : null;
  
  if (progressBar) progressBar.style.display = 'block';
  if (progressBarInner) progressBarInner.style.width = '0%';

  try {
    const uploadPromises = Array.from(files).map(async (file, index) => {
      // Validar tamanho do arquivo (10MB máximo)
      if (file.size > 10 * 1024 * 1024) {
        throw new Error(`Arquivo ${file.name} excede o limite de 10MB`);
      }

      // Validar tipo de arquivo
      const allowedTypes = [
        'image/jpeg', 'image/jpg', 'image/png', 'image/gif',
        'application/pdf',
        'application/msword',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/vnd.ms-excel',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      ];
      
      if (!allowedTypes.includes(file.type)) {
        throw new Error(`Tipo de arquivo não suportado: ${file.name}`);
      }

      // Gerar nome único para o arquivo
      const fileExt = file.name.split('.').pop();
      const fileName = `${complaintId}/${Date.now()}-${Math.random().toString(36).substring(7)}.${fileExt}`;
      
      // Fazer upload para o Supabase Storage
      const { data, error } = await supabase.storage
        .from(BUCKET_NAME)
        .upload(fileName, file, {
          cacheControl: '3600',
          upsert: false
        });

      if (error) throw error;

      // Obter URL pública
      const { data: urlData } = supabase.storage
        .from(BUCKET_NAME)
        .getPublicUrl(fileName);

      // Salvar metadados no banco
      const { error: dbError } = await supabase
        .from('complaint_attachments')
        .insert([
          {
            complaint_id: complaintId,
            file_name: file.name,
            file_url: urlData.publicUrl,
            file_type: file.type,
            file_size: file.size,
            uploaded_by: currentUserId,
            description: description
          }
        ]);

      if (dbError) throw dbError;

      // Atualizar barra de progresso
      if (progressBarInner) {
        const progress = Math.round(((index + 1) / files.length) * 100);
        progressBarInner.style.width = `${progress}%`;
        progressBarInner.textContent = `${progress}%`;
      }
      
      return { success: true, fileName: file.name };
    });

    const results = await Promise.all(uploadPromises);
    
    // Mostrar sucesso
    if (progressBarInner) {
      progressBarInner.style.width = '100%';
      progressBarInner.textContent = '100%';
      
      setTimeout(() => {
        if (progressBar) progressBar.style.display = 'none';
        if (progressBarInner) {
          progressBarInner.style.width = '0%';
          progressBarInner.textContent = '';
        }
      }, 1000);
    }

    return results;

  } catch (error) {
    console.error('Erro no upload:', error);
    if (progressBar) progressBar.style.display = 'none';
    showToast('Erro ao enviar arquivos: ' + error.message, 'danger');
    return [];
  }
}

export async function deleteAttachment(attachmentId, complaintId) {
  if (!confirm('Tem certeza que deseja excluir este anexo?')) return;

  try {
    // Primeiro, buscar a URL do arquivo para excluir do storage
    const { data: attachment, error: fetchError } = await supabase
      .from('complaint_attachments')
      .select('file_url')
      .eq('id', attachmentId)
      .single();

    if (fetchError) throw fetchError;

    // Extrair o caminho do arquivo da URL
    const urlParts = attachment.file_url.split('/');
    const filePath = urlParts.slice(urlParts.indexOf(BUCKET_NAME) + 1).join('/');
    
    // Excluir do storage
    const { error: storageError } = await supabase.storage
      .from(BUCKET_NAME)
      .remove([filePath]);

    if (storageError) {
      console.warn('Erro ao excluir do storage:', storageError);
    }

    // Excluir do banco
    const { error: dbError } = await supabase
      .from('complaint_attachments')
      .delete()
      .eq('id', attachmentId);

    if (dbError) throw dbError;
    
    return { success: true };

  } catch (error) {
    console.error('Erro ao excluir anexo:', error);
    showToast('Erro ao excluir anexo: ' + error.message, 'danger');
    return { success: false, error };
  }
}

export async function setupStorageBucket() {
  try {
    // Verificar se o bucket existe
    const { data: buckets, error } = await supabase.storage.listBuckets();
    
    if (error) {
      // Tentar criar o bucket se não existir
      console.log('Tentando criar bucket...');
      return;
    }
    
    const bucketExists = buckets.some(bucket => bucket.name === BUCKET_NAME);
    
    if (!bucketExists) {
      console.log(`Bucket ${BUCKET_NAME} não existe.`);
      // Nota: Buckets geralmente precisam ser criados manualmente no painel do Supabase
    }
  } catch (error) {
    console.error('Erro ao configurar storage:', error);
  }
}

// Função para obter URL assinada (se necessário privado)
export async function getSignedUrl(filePath, expiresIn = 3600) {
  try {
    const { data, error } = await supabase.storage
      .from(BUCKET_NAME)
      .createSignedUrl(filePath, expiresIn);

    if (error) throw error;
    
    return data.signedUrl;
  } catch (error) {
    console.error('Erro ao gerar URL assinada:', error);
    return null;
  }
}