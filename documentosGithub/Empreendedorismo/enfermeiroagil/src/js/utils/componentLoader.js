// Utilitário para carregar componentes dinamicamente
class ComponentLoader {
    constructor() {
        this.componentsLoaded = new Set();
    }

    async loadComponents() {
        const includes = document.querySelectorAll('[data-include]');
        
        for (const element of includes) {
            const filePath = element.getAttribute('data-include');
            
            if (this.componentsLoaded.has(filePath)) {
                continue;
            }
            
            try {
                const response = await fetch(filePath);
                
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                
                const html = await response.text();
                element.outerHTML = html;
                this.componentsLoaded.add(filePath);
                
                // Executar scripts dentro do componente
                this.executeScripts(element);
                
            } catch (error) {
                console.error(`Erro ao carregar componente ${filePath}:`, error);
                element.outerHTML = `<div class="alert alert-danger">Erro ao carregar componente: ${filePath}</div>`;
            }
        }
    }

    executeScripts(componentElement) {
        // Criar um elemento temporário para analisar o HTML
        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = componentElement.outerHTML;
        
        // Executar scripts dentro do componente
        const scripts = tempDiv.querySelectorAll('script');
        scripts.forEach(oldScript => {
            const newScript = document.createElement('script');
            
            // Copiar atributos
            Array.from(oldScript.attributes).forEach(attr => {
                newScript.setAttribute(attr.name, attr.value);
            });
            
            // Copiar conteúdo
            newScript.textContent = oldScript.textContent;
            
            // Substituir o script antigo
            oldScript.parentNode.replaceChild(newScript, oldScript);
        });
    }

    loadComponent(filePath, targetElement) {
        return new Promise(async (resolve, reject) => {
            try {
                const response = await fetch(filePath);
                
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                
                const html = await response.text();
                targetElement.innerHTML = html;
                
                // Executar scripts
                this.executeScripts(targetElement);
                
                resolve(true);
                
            } catch (error) {
                console.error(`Erro ao carregar componente ${filePath}:`, error);
                reject(error);
            }
        });
    }
}

// Exportar instância singleton
const componentLoader = new ComponentLoader();
export default componentLoader;