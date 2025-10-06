-- ================================================================
-- BANCO DE DADOS - EXERCÍCIO COMPLETO (13 MINIMUNDOS)
-- Padrão: CREATE SCHEMA / USE / PK e FK nomeadas / INT UNSIGNED AUTO_INCREMENT
-- ================================================================

-- ================================================================
-- MINIMUNDO 1 - BERÇÁRIO DA MATERNIDADE
-- ================================================================
CREATE SCHEMA minimundo1;
USE minimundo1;

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

-- ================================================================
-- MINIMUNDO 2 - BIBLIOTECA
-- ================================================================
CREATE SCHEMA minimundo2;
USE minimundo2;

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

-- ================================================================
-- MINIMUNDO 3 - EMPRESA DE SOFTWARE
-- ================================================================
CREATE SCHEMA minimundo3;
USE minimundo3;

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
