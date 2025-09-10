CREATE DATABASE maternidade;
USE maternidade;

CREATE TABLE especialidade (
    codigo INT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE medico (
    crm VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    especialidade_codigo INT,
    FOREIGN KEY (especialidade_codigo) REFERENCES especialidade(codigo)
);

CREATE TABLE mae (
    cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    telefone VARCHAR(20),
    data_nascimento DATE
);

CREATE TABLE bebe (
    registro INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    peso DECIMAL(5,2),
    altura DECIMAL(4,2),
    mae_cpf VARCHAR(14),
    medico_crm VARCHAR(20),
    FOREIGN KEY (mae_cpf) REFERENCES mae(cpf),
    FOREIGN KEY (medico_crm) REFERENCES medico(crm)
);