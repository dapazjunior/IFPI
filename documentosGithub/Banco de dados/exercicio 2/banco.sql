CREATE DATABASE banco;
USE banco;

CREATE TABLE cliente (
    cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    rg VARCHAR(20),
    cidade VARCHAR(100),
    estado CHAR(2)
);

CREATE TABLE agencia (
    numero INT PRIMARY KEY,
    cidade VARCHAR(100),
    estado CHAR(2)
);

CREATE TABLE conta (
    agencia_numero INT,
    numero INT,
    saldo DECIMAL(15,2) DEFAULT 0,
    cliente_cpf VARCHAR(14),
    PRIMARY KEY (agencia_numero, numero),
    FOREIGN KEY (agencia_numero) REFERENCES agencia(numero),
    FOREIGN KEY (cliente_cpf) REFERENCES cliente(cpf)
);

CREATE TABLE transacao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo ENUM('credito', 'debito') NOT NULL,
    data DATE NOT NULL,
    valor DECIMAL(15,2) NOT NULL,
    conta_agencia INT,
    conta_numero INT,
    FOREIGN KEY (conta_agencia, conta_numero) REFERENCES conta(agencia_numero, numero)
);