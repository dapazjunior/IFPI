CREATE DATABASE agenciamento;
USE agenciamento;

CREATE TABLE empresa (
    cnpj VARCHAR(18) PRIMARY KEY,
    razao_social VARCHAR(100) NOT NULL,
    endereco VARCHAR(200)
);

CREATE TABLE profissional (
    cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    data_nascimento DATE,
    profissao VARCHAR(100)
);

CREATE TABLE contrato (
    numero INT PRIMARY KEY AUTO_INCREMENT,
    empresa_cnpj VARCHAR(18),
    profissional_cpf VARCHAR(14),
    data_inicio DATE,
    data_termino DATE,
    valor_hora DECIMAL(10,2),
    FOREIGN KEY (empresa_cnpj) REFERENCES empresa(cnpj),
    FOREIGN KEY (profissional_cpf) REFERENCES profissional(cpf)
);