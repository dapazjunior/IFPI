CREATE DATABASE desenvolvimento;
USE desenvolvimento;

CREATE TABLE cliente (
    numero INT PRIMARY KEY AUTO_INCREMENT,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE projeto (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    data_inicio DATE,
    data_termino DATE,
    cliente_numero INT,
    FOREIGN KEY (cliente_numero) REFERENCES cliente(numero)
);

CREATE TABLE desenvolvedor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    custo_hora DECIMAL(10,2) NOT NULL
);

CREATE TABLE projeto_desenvolvedor (
    projeto_codigo INT,
    desenvolvedor_id INT,
    data_hora_inicio DATETIME,
    data_hora_termino DATETIME,
    PRIMARY KEY (projeto_codigo, desenvolvedor_id, data_hora_inicio),
    FOREIGN KEY (projeto_codigo) REFERENCES projeto(codigo),
    FOREIGN KEY (desenvolvedor_id) REFERENCES desenvolvedor(id)
);