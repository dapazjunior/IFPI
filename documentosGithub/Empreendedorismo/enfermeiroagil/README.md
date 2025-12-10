# Enfermeiro Ágil

Ferramenta digital para profissionais de enfermagem organizarem seus plantões com segurança e eficiência.

## 🚀 Começando

### Pré-requisitos

- Node.js 18+
- Conta no [Supabase](https://supabase.com)
- Conta no [Netlify](https://netlify.com)

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/enfermeiro-agil.git
cd enfermeiro-agil
Instale as dependências:

bash
npm install
Configure as variáveis de ambiente:

bash
cp .env.example .env
# Edite o .env com suas credenciais do Supabase
Configure o banco de dados:

Acesse seu projeto no Supabase

Vá para o SQL Editor

Execute o script SQL em supabase/schema.sql

Inicie o servidor de desenvolvimento:

bash
npm run dev
📁 Estrutura do Projeto
text
enfermeiro-agil/
├── src/                    # Código fonte
│   ├── css/               # Estilos
│   ├── js/                # JavaScript
│   └── pages/             # Páginas HTML
├── public/                # Arquivos estáticos
├── netlify/              # Configuração Netlify
└── supabase/             # Schema do banco
🔧 Configuração
Supabase
Crie um novo projeto no Supabase

Configure as tabelas usando o script SQL fornecido

Obtenha as credenciais (URL e anon key)

Atualize no arquivo .env

Netlify
Conecte seu repositório ao Netlify

Configure as variáveis de ambiente:

SUPABASE_URL

SUPABASE_ANON_KEY

Defina o diretório de build como .

O comando de build é npm run build

🚀 Deploy
Para fazer deploy na Netlify:

bash
npm run deploy
Ou conecte diretamente pelo painel da Netlify.

📄 Licença
Este projeto está sob a licença MIT. Veja o arquivo LICENSE para detalhes.

👥 Contribuição
Faça um Fork do projeto

Crie uma Branch para sua Feature (git checkout -b feature/AmazingFeature)

Faça o Commit das suas mudanças (git commit -m 'Add some AmazingFeature')

Faça o Push para a Branch (git push origin feature/AmazingFeature)

Abra um Pull Request

📞 Suporte
Para suporte, entre em contato:

Email: contato@enfermeiroagil.com

WhatsApp: (11) 99999-9999

🙏 Agradecimentos
Todos os profissionais de enfermagem que testaram e contribuíram

Equipe do Supabase pela incrível plataforma

Comunidade open source