# Enfermeiro Ágil

**Enfermeiro Ágil** é um aplicativo móvel desenvolvido em **Flutter** para apoiar a rotina de profissionais de saúde na gestão de **pacientes, atendimentos, equipes e contas**.  
O sistema foi pensado especialmente para contextos de **homecare, clínicas e equipes de enfermagem**, centralizando informações e organizando o fluxo de trabalho de forma simples, prática e escalável.

---

## Sumário

- [Visão geral](#visão-geral)
- [Problema que o projeto resolve](#problema-que-o-projeto-resolve)
- [Público-alvo](#público-alvo)
- [Funcionalidades principais](#funcionalidades-principais)
- [Artefatos desenvolvidos na disciplina](#artefatos-desenvolvidos-na-disciplina)
- [Telas e implementação](#telas-e-implementação)
- [Modelos de dados](#modelos-de-dados)
- [Tecnologias utilizadas](#tecnologias-utilizadas)
- [Como executar o projeto](#como-executar-o-projeto)
- [Status do projeto](#status-do-projeto)
- [Autores](#autores)

---

## Visão geral

Na rotina de enfermagem e de equipes de homecare, é muito comum:

- registros espalhados em papel, planilhas e mensagens;
- dificuldade para saber quem é responsável por cada paciente;
- falta de visibilidade sobre atendimentos pendentes e concluídos;
- pouca organização para gestores acompanharem a equipe;
- ausência de perfis com permissões diferentes (profissional, gestor, admin).

O **Enfermeiro Ágil** foi criado para centralizar essas informações em um único sistema, com foco em:

- organização da rotina de cuidados;
- gestão de pacientes e atendimentos;
- controle de equipe;
- visão administrativa do sistema.

---

## Problema que o projeto resolve

O projeto busca resolver a **desorganização das informações assistenciais** em equipes de saúde que hoje dependem de:

- cadernos,
- planilhas,
- conversas em aplicativos de mensagem.

Isso gera:

- risco de perda de informações;
- retrabalho;
- falhas de comunicação;
- dificuldade de priorizar pacientes;
- pouca rastreabilidade do cuidado.

---

## Público-alvo

O sistema foi pensado para:

- **profissionais de enfermagem**;
- **gestores de equipes de homecare**;
- **clínicas e serviços assistenciais**;
- **administradores do sistema** (visão global de contas e usuários).

---

## Funcionalidades principais

### Autenticação e perfis

- login de usuário;
- cadastro de conta;
- roteamento por tipo de usuário (profissional, gestor, admin do sistema);
- tela de conta suspensa quando a conta não está ativa.

### Gestão de pacientes

- cadastro e edição de pacientes;
- listagem de pacientes da conta;
- filtros por prioridade (alta, média, baixa);
- filtros por hospital;
- acesso aos detalhes do paciente;
- relação com atendimentos e equipe.

### Gestão de atendimentos

- cadastro de atendimentos para pacientes;
- definição de data e horário;
- atendimentos recorrentes, com dias da semana e data final;
- status pendente / concluído;
- histórico por paciente.

### Gestão da equipe (gestor)

- dashboard do gestor com:
  - total de profissionais;
  - profissionais em serviço;
  - total de pacientes;
  - vagas livres no plano;
- cadastro de novos profissionais;
- ativação e desativação de profissionais;
- visualização de status “em serviço”.

### Administração (admin do sistema)

- visão de contas;
- visão de usuários;
- controle de planos e status (ativo/suspenso).

---

## Artefatos desenvolvidos na disciplina

Esta seção está alinhada com o cronograma de atividades da disciplina (brainstorming, pitch, BMC, UML, mockups, front-end e avaliação final).

### Brainstorming de ideias de projeto

Documento com as perguntas-chave sobre problema, público-alvo, ideias e proposta de valor.

- 📄 **Brainstorming:**  
  [`docs/brainstorming/brainstorming.md`](docs/brainstorming/brainstorming.md)

---

### Pitch da ideia (apresentação)

Apresentação utilizada para defender a ideia do projeto, conforme data de “apresentação da ideia (Pitch)”.

- 📊 **Pitch:**  
  [`docs/pitch/pitch.pptx`](docs/pitch/pitch.pptx)

---

### Business Model Canvas (BMC)

Canvas com a visão de negócio do projeto, desenvolvido e apresentado nas datas de BMC.

- 🧩 **Business Model Canvas:**  
  [`docs/bmc/bmc.pdf`](docs/bmc/bmc.pdf)

---

### Diagramas UML (casos de uso e classes)

Os diagramas UML (diagrama de caso de uso e diagrama de classes) foram construídos e apresentados em aula na data de **18/03/2026** (Apresentação de diagramas UML – caso de uso – Classes).

- 📌 **Diagrama de Caso de Uso — Enfermeiro:**  
  [`docs/diagramas/caso_de_uso_enfermeiro.svg`](docs/diagramas/caso_de_uso_enfermeiro.svg)

- 📌 **Diagrama de Caso de Uso — Gestor:**  
  [`docs/diagramas/caso_de_uso_gestor.svg`](docs/diagramas/caso_de_uso_gestor.svg)

- 📌 **Diagrama de Caso de Uso — Admin do Sistema:**  
  [`docs/diagramas/caso_de_uso_admin_sistema.svg`](docs/diagramas/caso_de_uso_admin_sistema.svg)

- 📌 **Diagrama de Classes:**  
  [`docs/diagramas/classes.svg`](docs/diagramas/classes.svg)

---

### Protótipo de baixa fidelidade

Documento com os esboços iniciais das telas (wireframes simples), atendendo às aulas de “Desenvolvimento do Mockup de baixa fidelidade” e “Apresentação do mockup de baixa fidelidade”.

- ✏️ **Protótipo de baixa fidelidade:**  
  [`docs/prototipo_baixa/prototipo_baixa_fidelidade.docx`](docs/prototipo_baixa/prototipo_baixa_fidelidade.docx)

---

### Protótipo de alta fidelidade

Protótipo navegável em HTML, simulando as telas principais e o fluxo de navegação do aplicativo, conforme as aulas de “Desenvolvimento do Mockup de alta fidelidade” e “Apresentação do mockup de alta fidelidade”.

- 🎨 **Protótipo de alta fidelidade (HTML):**  
  [`docs/prototipo_alta/prototipo_alta_fidelidade.html`](docs/prototipo_alta/prototipo_alta_fidelidade.html)

> Se você ativar o GitHub Pages usando a pasta `docs/`, esse HTML pode funcionar como uma demo online.

---

### Relatório acadêmico final

- 📚 **Relatório Acadêmico:**  
  [`docs/relatorio/relatorio_academico.pdf`](docs/relatorio/relatorio_academico.pdf)

---

## Telas e implementação

As telas foram implementadas em Flutter, dentro da pasta `lib/screens/`. Algumas das principais telas são:

- `lib/screens/login_screen.dart`
- `lib/screens/signup_screen.dart`
- `lib/screens/router_screen.dart`
- `lib/screens/enfermeiro_dashboard_screen.dart`
- `lib/screens/paciente_list_screen.dart`
- `lib/screens/paciente_form_screen.dart`
- `lib/screens/paciente_detalhes_screen.dart`
- `lib/screens/gestor_dashboard_screen.dart`
- `lib/screens/gestor_novo_profissional_screen.dart`
- `lib/screens/admin_sistema_screen.dart`
- `lib/screens/admin_dashboard_screen.dart`
- `lib/screens/conta_suspensa_screen.dart`

### Detalhes da implementação: `gestor_dashboard_screen.dart`

A tela do **Dashboard do Gestor** (`gestor_dashboard_screen.dart`) é uma das implementações centrais para o perfil de gestor, oferecendo uma visão abrangente da equipe e dos pacientes.

#### Componentes e funcionalidades:

-   **Header Personalizado:** Exibe o nome da equipe/gestor e o status do plano (ativo/suspenso), com um avatar do usuário.
-   **Navegação por Abas:** Permite alternar entre "Resumo", "Equipe" e "Pacientes" usando `NavigationBar`.
-   **Floating Action Buttons (FABs):**
    -   Na aba "Equipe": FAB para "Adicionar profissional" (`GestorNovoProfissionalScreen`).
    -   Na aba "Pacientes": FAB para "Novo paciente" (`PacienteFormScreen`).

#### Aba "Resumo":

-   **Cards de Métricas:** Exibe dados importantes como:
    -   Total de profissionais (`usados/limite`).
    -   Profissionais "Em serviço".
    -   Total de pacientes.
    -   "Vagas livres" no plano (com alerta visual se o limite for atingido).
-   **Card do Plano:** Detalha o plano contratado (ex: "Plano Homecare ativo"), progresso de uso de profissionais (`LinearProgressIndicator`) e status de pagamento.
-   **Acesso Rápido:** Atalhos para:
    -   "Novo profissional".
    -   "Novo paciente".
    -   "Sair" (com confirmação de logout).
-   **Alerta de Limite:** Um `Container` de aviso é exibido se o limite de profissionais for atingido.

#### Aba "Equipe":

-   **Listagem de Profissionais:** Exibe todos os profissionais vinculados à conta.
-   **Detalhes do Profissional:** Para cada profissional, mostra:
    -   Nome e e-mail.
    -   Status "Em serviço" (com ícone de círculo verde) ou "Offline".
    -   Status "Ativo" ou "Inativo" (com `Switch` para alternar).
-   **Funcionalidade de Ativação/Desativação:** O gestor pode ativar ou inativar profissionais da equipe.
-   **Empty State:** Mensagem e ícone informando quando não há profissionais cadastrados.

#### Aba "Pacientes":

-   **Filtros:**
    -   Dropdown para filtrar por "Profissional responsável".
    -   Chips de filtro para "Prioridade" (Alta, Média, Baixa) e "Hospital".
-   **Listagem de Pacientes:** Exibe os pacientes da conta, aplicando os filtros selecionados.
-   **Cards de Paciente:** Cada card mostra:
    -   Nome do paciente.
    -   Leito e hospital (se aplicável).
    -   Prioridade (com cor de fundo e borda indicativas).
    -   Avatar com a inicial do nome.
-   **Navegação para Detalhes:** Ao tocar no card, navega para a tela `PacienteDetalhesScreen`.
-   **Empty State:** Mensagem e ícone informando quando não há pacientes ou quando os filtros não retornam resultados.

---

## Modelos de dados

Principais entidades do sistema:

- **Usuario**
- **Conta**
- **Paciente**
- **Hospital**
- **TipoAtendimento**
- **Atendimento**

### Usuario

- id  
- email  
- nome  
- telefone  
- documento  
- tipoUsuario (admin_sistema, gestor, profissional)  
- contaId  
- ativo  
- emServico  
- bloqueado  
- criadoEm  

### Conta

- id  
- tipoConta (individual, homecare, equipe)  
- plano  
- limiteProfissionais  
- nomeEquipe  
- planoAtivo  
- statusPagamento  
- criadoEm  

### Paciente

- id  
- nome  
- leito  
- prioridade (alta, media, baixa)  
- hospitalId  
- hospitalNome  
- observacoes  
- criadoPor  
- contaId  
- criadoEm  
- (no código: `profissionalId` para vínculo com responsável)

### Hospital

- id  
- nome  
- cidade  
- estado  

### TipoAtendimento

- id  
- nome  
- padrao  

### Atendimento

- id  
- pacienteId  
- tipoAtendimentoId  
- descricao  
- horarioPrevisto  
- dataPrevista  
- recorrente  
- recorrenciaDias  
- recorrenciaFim  
- status  
- criadoPor  
- criadoEm  
- pacienteNome  
- hospitalNome  
- tipoAtendimentoNome  
- prioridade  

---

## Tecnologias utilizadas

- **Flutter** — desenvolvimento do app móvel  
- **Dart**  
- **Supabase** — backend/BaaS  
- **PostgreSQL** — banco de dados  
- **Material Design** — base de UI  
- **HTML/CSS/JavaScript** — protótipo de alta fidelidade

---

## Como executar o projeto

### Pré-requisitos

- Flutter instalado
- Dart instalado
- Conta no Supabase e configuração das credenciais no projeto
- Banco de dados com as tabelas configuradas

### Instalação

```bash
flutter pub get
```

### Execução

```bash
flutter run
```

---

## Status do projeto

O **Enfermeiro Ágil** já conta com:

- fluxo de autenticação e roteamento por perfil;
- telas para profissionais, gestores e admin do sistema;
- gestão de pacientes;
- gestão de atendimentos;
- gestão de equipe (gestor);
- protótipos de baixa e alta fidelidade;
- artefatos de documentação (brainstorming, pitch, BMC, UML, protótipos).

Próximas melhorias possíveis:

- relatórios e dashboards analíticos;
- notificações;
- exportação de dados (PDF/Excel);
- anexos (imagens, arquivos) em atendimentos;
- integração com agenda/calendário.

---

## Autores

Projeto desenvolvido pela equipe:

- **José da Paz**
- **Samuel Victor**
- **Manoel de Jesus**