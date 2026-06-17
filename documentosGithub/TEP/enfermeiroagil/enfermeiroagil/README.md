# Enfermeiro Ágil

**Enfermeiro Ágil** é um aplicativo móvel desenvolvido em **Flutter** para apoiar a rotina de profissionais de saúde na **gestão de pacientes, atendimentos, equipes e contas**.  
O sistema foi pensado especialmente para contextos de **homecare, clínicas e equipes de enfermagem**, centralizando informações e organizando o fluxo de trabalho de forma simples, prática e escalável.

---

## Sumário

- [Visão geral](#visão-geral)
- [Problema que o projeto resolve](#problema-que-o-projeto-resolve)
- [Público-alvo](#público-alvo)
- [Funcionalidades](#funcionalidades)
- [Telas do sistema](#telas-do-sistema)
- [Modelos de dados](#modelos-de-dados)
- [Tecnologias utilizadas](#tecnologias-utilizadas)
- [Como executar o projeto](#como-executar-o-projeto)
- [Protótipos e documentação](#protótipos-e-documentação)
- [Status do projeto](#status-do-projeto)
- [Possibilidades de evolução](#possibilidades-de-evolução)
- [Autores](#autores)

---

## Visão geral

O projeto busca resolver problemas comuns da rotina assistencial, como:

- registros espalhados em planilhas, papel ou mensagens;
- dificuldade para acompanhar pacientes e atendimentos;
- falta de organização entre membros da equipe;
- ausência de controle de acesso por perfil;
- dificuldade para visualizar prioridades e pendências;
- pouca centralização das informações do cuidado.

A proposta é oferecer uma solução mobile que una:

- **organização**
- **rastreabilidade**
- **controle**
- **colaboração**
- **segurança no acesso**

---

## Problema que o projeto resolve

Na rotina de enfermagem e de equipes de homecare, é comum existir:

- excesso de anotações manuais;
- dificuldade para compartilhar informações;
- perdas de histórico de atendimentos;
- falhas no acompanhamento de pacientes;
- pouca visão gerencial sobre a equipe;
- ausência de um painel de administração central.

O **Enfermeiro Ágil** foi criado para enfrentar esses problemas com uma plataforma única, digital e mobile.

---

## Público-alvo

O sistema foi idealizado para atender principalmente:

- **enfermeiros e profissionais de saúde**
- **gestores de equipes de homecare**
- **clínicas e serviços assistenciais**
- **administradores do sistema**

---

## Funcionalidades

### Autenticação e perfis
- login e cadastro de usuários;
- roteamento automático por perfil;
- separação entre:
  - profissional
  - gestor
  - admin do sistema;
- tela de conta suspensa para acessos bloqueados.

### Gestão de pacientes
- cadastro de pacientes;
- edição de pacientes;
- exclusão de pacientes;
- filtro por prioridade;
- filtro por hospital;
- compartilhamento de paciente com profissionais ou equipe.

### Gestão de atendimentos
- cadastro de atendimentos;
- edição de atendimentos;
- marcação de status:
  - pendente
  - concluído;
- atendimentos recorrentes;
- visualização de histórico;
- agrupamento por data.

### Gestão da equipe
- cadastro de novos profissionais pelo gestor;
- visualização dos profissionais da conta;
- ativação e desativação de profissionais;
- controle de status “em serviço”.

### Administração do sistema
- visualização de todas as contas;
- visualização de todos os usuários;
- bloqueio e desbloqueio de usuários;
- ativação e suspensão de planos;
- painel geral do sistema.

---

## Telas do sistema

O projeto possui as seguintes telas principais:

- `login_screen.dart`
- `signup_screen.dart`
- `router_screen.dart`
- `enfermeiro_dashboard_screen.dart`
- `paciente_list_screen.dart`
- `paciente_form_screen.dart`
- `paciente_detalhes_screen.dart`
- `gestor_dashboard_screen.dart`
- `gestor_novo_profissional_screen.dart`
- `admin_sistema_screen.dart`
- `admin_dashboard_screen.dart`
- `conta_suspensa_screen.dart`

### Exemplo de fluxo principal

```text
Login -> Router -> Dashboard conforme perfil -> Pacientes / Equipe / Administração
```

---

## Modelos de dados

Os modelos centrais do projeto são:

- **Usuario**
- **Conta**
- **Paciente**
- **Hospital**
- **TipoAtendimento**
- **Atendimento**

### Resumo dos principais modelos

#### Usuario
Representa os usuários do sistema.

Campos principais:
- id
- email
- nome
- telefone
- documento
- tipoUsuario
- contaId
- ativo
- emServico
- bloqueado
- criadoEm

#### Conta
Representa a conta principal do cliente.

Campos principais:
- id
- tipoConta
- plano
- limiteProfissionais
- nomeEquipe
- planoAtivo
- statusPagamento
- criadoEm

#### Paciente
Representa o paciente cadastrado.

Campos principais:
- id
- nome
- leito
- prioridade
- hospitalId
- observacoes
- criadoPor
- contaId
- criadoEm
- hospitalNome

#### Hospital
Representa o local de atendimento.

Campos principais:
- id
- nome
- cidade
- estado

#### TipoAtendimento
Representa o tipo de cuidado ou procedimento.

Campos principais:
- id
- nome
- padrao

#### Atendimento
Representa o atendimento agendado ou realizado.

Campos principais:
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

- **Flutter**
- **Dart**
- **Supabase**
- **PostgreSQL**
- **Material Design**
- **HTML/CSS/JavaScript** para protótipo de alta fidelidade

---

## Como executar o projeto

### Pré-requisitos
- Flutter instalado
- Dart instalado
- Conta no Supabase configurada
- Banco de dados com as tabelas do projeto

### Instalação

```bash
flutter pub get
```

### Execução

```bash
flutter run
```

---

## Protótipos e documentação

O projeto já conta com materiais importantes de apoio, como:

- brainstorming da ideia;
- pitch do projeto;
- diagramas de caso de uso;
- diagrama de classes;
- protótipo de baixa fidelidade;
- protótipo de alta fidelidade;
- documentação final.

### Protótipo de alta fidelidade
O protótipo pode ser representado em **HTML** com navegação simulada entre telas, servindo como demonstração visual do fluxo do aplicativo.


---

## Status do projeto

O **Enfermeiro Ágil** está em evolução e já possui uma base funcional para:

- autenticação;
- gestão de pacientes;
- gestão de atendimentos;
- gestão de equipe;
- administração de contas e usuários;
- roteamento por perfil;
- protótipos e documentação do trabalho final.

Ainda pode receber melhorias em:

- experiência visual;
- relatórios;
- notificações;
- filtros avançados;
- exportação de dados;
- dashboards analíticos;
- integração com calendário;
- anexos e arquivos clínicos.

---

## Possibilidades de evolução

O projeto pode evoluir com:

- notificações em tempo real;
- relatórios por período;
- exportação em PDF;
- assinatura digital;
- integração com agenda;
- monitoramento de produtividade da equipe;
- visualização de indicadores assistenciais;
- anexos de imagens e documentos;
- melhorias no fluxo de compartilhamento de pacientes.

---

## Conclusão

O **Enfermeiro Ágil** é uma proposta de solução para a organização da rotina assistencial, oferecendo uma plataforma digital para:

- acompanhar pacientes;
- organizar atendimentos;
- coordenar equipes;
- centralizar informações;
- melhorar a gestão do cuidado.

É um projeto com aplicação prática, boa organização estrutural e potencial de evolução para diferentes contextos da área da saúde.

---

## Autores

Projeto desenvolvido por **José** e equipe, com foco em gestão assistencial e organização de rotinas de enfermagem.
