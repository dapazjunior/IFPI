CREATE SCHEMA bercario;
USE bercario;

CREATE TABLE mae (
    CPF CHAR(11) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    endereco VARCHAR(100),
    telefone CHAR(11),
    nascimento DATE,
    CONSTRAINT pk_mae PRIMARY KEY (CPF)
);

CREATE TABLE especialidade (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(45) NOT NULL,
    CONSTRAINT pk_especialidade PRIMARY KEY (id)
);

CREATE TABLE medico (
    CRM CHAR(10) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    telefone CHAR(11),
    especialidade_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_medico PRIMARY KEY (CRM),
    CONSTRAINT fk_medico_especialidade FOREIGN KEY (especialidade_id) REFERENCES especialidade(id)
);

CREATE TABLE bebe (
    registro INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    nascimento DATE,
    peso DECIMAL(5,2),
    altura DECIMAL(4,2),
    mae_CPF CHAR(11) NOT NULL,
    medico_CRM CHAR(10) NOT NULL,
    CONSTRAINT pk_bebe PRIMARY KEY (registro),
    CONSTRAINT fk_bebe_mae FOREIGN KEY (mae_CPF) REFERENCES mae(CPF),
    CONSTRAINT fk_bebe_medico FOREIGN KEY (medico_CRM) REFERENCES medico(CRM)
);


CREATE SCHEMA biblioteca;
USE biblioteca;

CREATE TABLE editora (
    CNPJ CHAR(14) NOT NULL,
    razao_social VARCHAR(100) NOT NULL,
    CONSTRAINT pk_editora PRIMARY KEY (CNPJ)
);

CREATE TABLE nacionalidade (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(45) NOT NULL,
    CONSTRAINT pk_nacionalidade PRIMARY KEY (id)
);

CREATE TABLE autor (
    passaporte CHAR(9) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    nacionalidade_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_autor PRIMARY KEY (passaporte),
    CONSTRAINT fk_autor_nacionalidade FOREIGN KEY (nacionalidade_id) REFERENCES nacionalidade(id)
);

CREATE TABLE categoria (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(45) NOT NULL,
    CONSTRAINT pk_categoria PRIMARY KEY (id)
);

CREATE TABLE livro (
    ISBN CHAR(13) NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    ano YEAR,
    editora_CNPJ CHAR(14) NOT NULL,
    categoria_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_livro PRIMARY KEY (ISBN),
    CONSTRAINT fk_livro_editora FOREIGN KEY (editora_CNPJ) REFERENCES editora(CNPJ),
    CONSTRAINT fk_livro_categoria FOREIGN KEY (categoria_id) REFERENCES categoria(id)
);

CREATE TABLE livro_has_autor (
    livro_ISBN CHAR(13) NOT NULL,
    autor_passaporte CHAR(9) NOT NULL,
    CONSTRAINT pk_livro_autor PRIMARY KEY (livro_ISBN, autor_passaporte),
    CONSTRAINT fk_livro_autor FOREIGN KEY (livro_ISBN) REFERENCES livro(ISBN),
    CONSTRAINT fk_autor_livro FOREIGN KEY (autor_passaporte) REFERENCES autor(passaporte)
);

CREATE SCHEMA desenvolvedores;
USE desenvolvedores;

CREATE TABLE cliente (
    numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CPF CHAR(11) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (numero)
);

CREATE TABLE projeto (
    codigo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    inicio DATE,
    termino DATE,
    cliente_numero INT UNSIGNED NOT NULL,
    CONSTRAINT pk_projeto PRIMARY KEY (codigo),
    CONSTRAINT fk_projeto_cliente FOREIGN KEY (cliente_numero) REFERENCES cliente(numero)
);

CREATE TABLE desenvolvedor (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    custo_hora DECIMAL(10,2),
    CONSTRAINT pk_desenvolvedor PRIMARY KEY (id)
);

CREATE TABLE alocacao (
    projeto_codigo INT UNSIGNED NOT NULL,
    desenvolvedor_id INT UNSIGNED NOT NULL,
    inicio DATETIME NOT NULL,
    termino DATETIME,
    CONSTRAINT pk_alocacao PRIMARY KEY (projeto_codigo, desenvolvedor_id, inicio),
    CONSTRAINT fk_alocacao_projeto FOREIGN KEY (projeto_codigo) REFERENCES projeto(codigo),
    CONSTRAINT fk_alocacao_desenvolvedor FOREIGN KEY (desenvolvedor_id) REFERENCES desenvolvedor(id)
);


CREATE SCHEMA banco;
USE banco;

CREATE TABLE cliente (
    CPF CHAR(11) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    RG CHAR(10),
    cidade VARCHAR(45),
    estado CHAR(2),
    CONSTRAINT pk_cliente PRIMARY KEY (CPF)
);

CREATE TABLE agencia (
    numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
    cidade VARCHAR(45),
    estado CHAR(2),
    CONSTRAINT pk_agencia PRIMARY KEY (numero)
);

CREATE TABLE conta (
    numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
    saldo DECIMAL(10,2),
    agencia_numero INT UNSIGNED NOT NULL,
    cliente_CPF CHAR(11) NOT NULL,
    CONSTRAINT pk_conta PRIMARY KEY (numero),
    CONSTRAINT fk_conta_agencia FOREIGN KEY (agencia_numero) REFERENCES agencia(numero),
    CONSTRAINT fk_conta_cliente FOREIGN KEY (cliente_CPF) REFERENCES cliente(CPF)
);

CREATE TABLE transacao (
    numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
    tipo VARCHAR(20),
    data DATE,
    valor DECIMAL(10,2),
    conta_numero INT UNSIGNED NOT NULL,
    CONSTRAINT pk_transacao PRIMARY KEY (numero),
    CONSTRAINT fk_transacao_conta FOREIGN KEY (conta_numero) REFERENCES conta(numero)
);


CREATE SCHEMA floricultura;
USE floricultura;

CREATE TABLE cliente (
    CPF CHAR(11) NOT NULL,
    RG CHAR(10),
    nome VARCHAR(45) NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(100),
    CONSTRAINT pk_cliente PRIMARY KEY (CPF)
);

CREATE TABLE produto (
    codigo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    tipo VARCHAR(20),
    preco DECIMAL(10,2),
    estoque INT UNSIGNED,
    CONSTRAINT pk_produto PRIMARY KEY (codigo)
);

CREATE TABLE compra (
    nota INT UNSIGNED NOT NULL AUTO_INCREMENT,
    data DATE,
    valor_total DECIMAL(10,2),
    cliente_CPF CHAR(11) NOT NULL,
    CONSTRAINT pk_compra PRIMARY KEY (nota),
    CONSTRAINT fk_compra_cliente FOREIGN KEY (cliente_CPF) REFERENCES cliente(CPF)
);

CREATE TABLE item_compra (
    compra_nota INT UNSIGNED NOT NULL,
    produto_codigo INT UNSIGNED NOT NULL,
    quantidade INT UNSIGNED NOT NULL,
    CONSTRAINT pk_item_compra PRIMARY KEY (compra_nota, produto_codigo),
    CONSTRAINT fk_item_compra_compra FOREIGN KEY (compra_nota) REFERENCES compra(nota),
    CONSTRAINT fk_item_compra_produto FOREIGN KEY (produto_codigo) REFERENCES produto(codigo)
);


CREATE SCHEMA limpeza;
USE limpeza;

CREATE TABLE cliente (
    codigo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    endereco VARCHAR(100),
    telefone VARCHAR(20),
    status_cliente ENUM('bom','medio','ruim'),
    limite_credito DECIMAL(10,2),
    CONSTRAINT pk_cliente PRIMARY KEY (codigo)
);

CREATE TABLE produto (
    codigo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    categoria VARCHAR(45),
    preco DECIMAL(10,2),
    CONSTRAINT pk_produto PRIMARY KEY (codigo)
);

CREATE TABLE pedido (
    numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
    data DATE,
    cliente_codigo INT UNSIGNED NOT NULL,
    CONSTRAINT pk_pedido PRIMARY KEY (numero),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_codigo) REFERENCES cliente(codigo)
);

CREATE TABLE item_pedido (
    pedido_numero INT UNSIGNED NOT NULL,
    produto_codigo INT UNSIGNED NOT NULL,
    quantidade INT UNSIGNED NOT NULL,
    CONSTRAINT pk_item_pedido PRIMARY KEY (pedido_numero, produto_codigo),
    CONSTRAINT fk_item_pedido_pedido FOREIGN KEY (pedido_numero) REFERENCES pedido(numero),
    CONSTRAINT fk_item_pedido_produto FOREIGN KEY (produto_codigo) REFERENCES produto(codigo)
);


CREATE SCHEMA gravadora;
USE gravadora;

CREATE TABLE musico (
    CPF CHAR(11) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    endereco VARCHAR(100),
    telefone CHAR(11),
    CONSTRAINT pk_musico PRIMARY KEY (CPF)
);

CREATE TABLE instrumento (
    codigo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    CONSTRAINT pk_instrumento PRIMARY KEY (codigo)
);

CREATE TABLE instrumento_has_musico (
    instrumento_codigo INT UNSIGNED NOT NULL,
    musico_CPF CHAR(11) NOT NULL,
    CONSTRAINT pk_instrumento_musico PRIMARY KEY (instrumento_codigo, musico_CPF),
    CONSTRAINT fk_instrumento FOREIGN KEY (instrumento_codigo) REFERENCES instrumento(codigo),
    CONSTRAINT fk_musico_instrumento FOREIGN KEY (musico_CPF) REFERENCES musico(CPF)
);

CREATE TABLE produtor (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    CONSTRAINT pk_produtor PRIMARY KEY (id)
);

CREATE TABLE disco (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(45) NOT NULL,
    data DATE,
    produtor_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_disco PRIMARY KEY (id),
    CONSTRAINT fk_disco_produtor FOREIGN KEY (produtor_id) REFERENCES produtor(id)
);

CREATE TABLE musica (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(45) NOT NULL,
    disco_id INT UNSIGNED NOT NULL,
    autor_CPF CHAR(11),
    CONSTRAINT pk_musica PRIMARY KEY (id),
    CONSTRAINT fk_musica_disco FOREIGN KEY (disco_id) REFERENCES disco(id),
    CONSTRAINT fk_musica_autor FOREIGN KEY (autor_CPF) REFERENCES musico(CPF)
);

CREATE TABLE musico_has_musica (
    musico_CPF CHAR(11) NOT NULL,
    musica_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_musico_musica PRIMARY KEY (musico_CPF, musica_id),
    CONSTRAINT fk_musico_musica FOREIGN KEY (musico_CPF) REFERENCES musico(CPF),
    CONSTRAINT fk_musica_musico FOREIGN KEY (musica_id) REFERENCES musica(id)
);



CREATE SCHEMA aeroporto;
USE aeroporto;

CREATE TABLE modelo (
    codigo VARCHAR(10) NOT NULL,
    capacidade INT UNSIGNED,
    peso DECIMAL(10,2),
    CONSTRAINT pk_modelo PRIMARY KEY (codigo)
);

CREATE TABLE aviao (
    registro VARCHAR(10) NOT NULL,
    modelo_codigo VARCHAR(10) NOT NULL,
    CONSTRAINT pk_aviao PRIMARY KEY (registro),
    CONSTRAINT fk_aviao_modelo FOREIGN KEY (modelo_codigo) REFERENCES modelo(codigo)
);

CREATE TABLE tecnico (
    CPF CHAR(11) NOT NULL,
    endereco VARCHAR(100),
    telefone CHAR(11),
    salario DECIMAL(10,2),
    CONSTRAINT pk_tecnico PRIMARY KEY (CPF)
);

CREATE TABLE tecnico_has_modelo (
    tecnico_CPF CHAR(11) NOT NULL,
    modelo_codigo VARCHAR(10) NOT NULL,
    CONSTRAINT pk_tecnico_modelo PRIMARY KEY (tecnico_CPF, modelo_codigo),
    CONSTRAINT fk_tecnico_modelo_tecnico FOREIGN KEY (tecnico_CPF) REFERENCES tecnico(CPF),
    CONSTRAINT fk_tecnico_modelo_modelo FOREIGN KEY (modelo_codigo) REFERENCES modelo(codigo)
);

CREATE TABLE teste (
    numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    pontuacao_max INT UNSIGNED,
    CONSTRAINT pk_teste PRIMARY KEY (numero)
);

CREATE TABLE teste_realizado (
    aviao_registro VARCHAR(10) NOT NULL,
    tecnico_CPF CHAR(11) NOT NULL,
    teste_numero INT UNSIGNED NOT NULL,
    data DATE NOT NULL,
    horas_trabalhadas DECIMAL(5,2),
    pontuacao_obtida INT UNSIGNED,
    CONSTRAINT pk_teste_realizado PRIMARY KEY (aviao_registro, tecnico_CPF, teste_numero, data),
    CONSTRAINT fk_tr_aviao FOREIGN KEY (aviao_registro) REFERENCES aviao(registro),
    CONSTRAINT fk_tr_tecnico FOREIGN KEY (tecnico_CPF) REFERENCES tecnico(CPF),
    CONSTRAINT fk_tr_teste FOREIGN KEY (teste_numero) REFERENCES teste(numero)
);


CREATE SCHEMA emprego;
USE emprego;

CREATE TABLE empresa (
    CNPJ CHAR(14) NOT NULL,
    razao_social VARCHAR(100) NOT NULL,
    endereco VARCHAR(100),
    CONSTRAINT pk_empresa PRIMARY KEY (CNPJ)
);

CREATE TABLE profissional (
    CPF CHAR(11) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    endereco VARCHAR(100),
    nascimento DATE,
    profissao VARCHAR(45),
    CONSTRAINT pk_profissional PRIMARY KEY (CPF)
);

CREATE TABLE contrato (
    numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
    empresa_CNPJ CHAR(14) NOT NULL,
    profissional_CPF CHAR(11) NOT NULL,
    inicio DATE,
    termino DATE,
    valor_hora DECIMAL(10,2),
    CONSTRAINT pk_contrato PRIMARY KEY (numero),
    CONSTRAINT fk_contrato_empresa FOREIGN KEY (empresa_CNPJ) REFERENCES empresa(CNPJ),
    CONSTRAINT fk_contrato_profissional FOREIGN KEY (profissional_CPF) REFERENCES profissional(CPF)
);


CREATE SCHEMA loja;
USE loja;

CREATE TABLE vendedor (
    matricula INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    endereco VARCHAR(100),
    telefone VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    salario_base DECIMAL(10,2),
    CONSTRAINT pk_vendedor PRIMARY KEY (matricula)
);

CREATE TABLE cliente (
    CPF CHAR(11) NOT NULL,
    identidade CHAR(10),
    nome VARCHAR(45) NOT NULL,
    endereco VARCHAR(100),
    telefone VARCHAR(20),
    CONSTRAINT pk_cliente PRIMARY KEY (CPF)
);

CREATE TABLE produto (
    codigo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(100),
    preco DECIMAL(10,2),
    estoque INT UNSIGNED,
    CONSTRAINT pk_produto PRIMARY KEY (codigo)
);

CREATE TABLE venda (
    numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
    data DATETIME NOT NULL,
    cliente_CPF CHAR(11) NOT NULL,
    vendedor_matricula INT UNSIGNED NOT NULL,
    valor_total DECIMAL(10,2),
    CONSTRAINT pk_venda PRIMARY KEY (numero),
    CONSTRAINT fk_venda_cliente FOREIGN KEY (cliente_CPF) REFERENCES cliente(CPF),
    CONSTRAINT fk_venda_vendedor FOREIGN KEY (vendedor_matricula) REFERENCES vendedor(matricula)
);

CREATE TABLE item_venda (
    venda_numero INT UNSIGNED NOT NULL,
    produto_codigo INT UNSIGNED NOT NULL,
    quantidade INT UNSIGNED NOT NULL,
    CONSTRAINT pk_item_venda PRIMARY KEY (venda_numero, produto_codigo),
    CONSTRAINT fk_item_venda_venda FOREIGN KEY (venda_numero) REFERENCES venda(numero),
    CONSTRAINT fk_item_venda_produto FOREIGN KEY (produto_codigo) REFERENCES produto(codigo)
);



CREATE SCHEMA videolocadora;
USE videolocadora;

CREATE TABLE cliente (
    CPF CHAR(11) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    endereco VARCHAR(100),
    nascimento DATE,
    telefone VARCHAR(20),
    CONSTRAINT pk_cliente PRIMARY KEY (CPF)
);

CREATE TABLE dvd (
    codigo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(100),
    genero VARCHAR(45),
    CONSTRAINT pk_dvd PRIMARY KEY (codigo)
);

CREATE TABLE aluguel (
    numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
    data_aluguel DATE NOT NULL,
    data_devolucao DATE,
    cliente_CPF CHAR(11) NOT NULL,
    CONSTRAINT pk_aluguel PRIMARY KEY (numero),
    CONSTRAINT fk_aluguel_cliente FOREIGN KEY (cliente_CPF) REFERENCES cliente(CPF)
);

CREATE TABLE dvd_has_aluguel (
    dvd_codigo INT UNSIGNED NOT NULL,
    aluguel_numero INT UNSIGNED NOT NULL,
    CONSTRAINT pk_dvd_aluguel PRIMARY KEY (dvd_codigo, aluguel_numero),
    CONSTRAINT fk_dvd_aluguel_dvd FOREIGN KEY (dvd_codigo) REFERENCES dvd(codigo),
    CONSTRAINT fk_dvd_aluguel_aluguel FOREIGN KEY (aluguel_numero) REFERENCES aluguel(numero)
);


CREATE SCHEMA eventos;
USE eventos;

CREATE TABLE estado (
    sigla CHAR(2) NOT NULL,
    nome VARCHAR(45),
    CONSTRAINT pk_estado PRIMARY KEY (sigla)
);

CREATE TABLE cidade (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    estado_sigla CHAR(2) NOT NULL,
    CONSTRAINT pk_cidade PRIMARY KEY (id),
    CONSTRAINT fk_cidade_estado FOREIGN KEY (estado_sigla) REFERENCES estado(sigla)
);

CREATE TABLE local (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100),
    endereco VARCHAR(100),
    cidade_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_local PRIMARY KEY (id),
    CONSTRAINT fk_local_cidade FOREIGN KEY (cidade_id) REFERENCES cidade(id)
);

CREATE TABLE evento (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100),
    data_inicio DATE,
    data_fim DATE,
    local_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_evento PRIMARY KEY (id),
    CONSTRAINT fk_evento_local FOREIGN KEY (local_id) REFERENCES local(id)
);

CREATE TABLE acomodacao (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(45),
    CONSTRAINT pk_acomodacao PRIMARY KEY (id)
);

CREATE TABLE ingresso (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    preco DECIMAL(10,2),
    evento_id INT UNSIGNED NOT NULL,
    acomodacao_id INT UNSIGNED NOT NULL,
    CONSTRAINT pk_ingresso PRIMARY KEY (id),
    CONSTRAINT fk_ingresso_evento FOREIGN KEY (evento_id) REFERENCES evento(id),
    CONSTRAINT fk_ingresso_acomodacao FOREIGN KEY (acomodacao_id) REFERENCES acomodacao(id)
);


CREATE SCHEMA academia3;
USE academia;

CREATE TABLE instrutor (
    RG CHAR(10) NOT NULL,
    nome VARCHAR(45) NOT NULL,
    nascimento DATE,
    titulacao VARCHAR(45),
    telefone VARCHAR(20),
    CONSTRAINT pk_instrutor PRIMARY KEY (RG)
);

CREATE TABLE atividade (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(45),
    CONSTRAINT pk_atividade PRIMARY KEY (id)
);

CREATE TABLE turma (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    numero_alunos INT UNSIGNED,
    horario TIME,
    duracao TIME,
    data_inicial DATE,
    data_final DATE,
    atividade_id INT UNSIGNED NOT NULL,
    instrutor_RG CHAR(10) NOT NULL,
    CONSTRAINT pk_turma PRIMARY KEY (id),
    CONSTRAINT fk_turma_atividade FOREIGN KEY (atividade_id) REFERENCES atividade(id),
    CONSTRAINT fk_turma_instrutor FOREIGN KEY (instrutor_RG) REFERENCES instrutor(RG)
);

CREATE TABLE aluno (
    matricula INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    endereco VARCHAR(100),
    telefone VARCHAR(20),
    nascimento DATE,
    altura DECIMAL(4,2),
    peso DECIMAL(5,2),
    data_matricula DATE,
    CONSTRAINT pk_aluno PRIMARY KEY (matricula)
);

CREATE TABLE matricula (
    aluno_matricula INT UNSIGNED NOT NULL,
    turma_id INT UNSIGNED NOT NULL,
    ausencias INT UNSIGNED DEFAULT 0,
    CONSTRAINT pk_matricula PRIMARY KEY (aluno_matricula, turma_id),
    CONSTRAINT fk_matricula_aluno FOREIGN KEY (aluno_matricula) REFERENCES aluno(matricula),
    CONSTRAINT fk_matricula_turma FOREIGN KEY (turma_id) REFERENCES turma(id)
);
