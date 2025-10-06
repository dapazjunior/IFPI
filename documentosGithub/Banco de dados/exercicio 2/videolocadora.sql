CREATE DATABASE videolocadora;
USE videolocadora;

CREATE TABLE cliente (
    cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    data_nascimento DATE,
    telefone VARCHAR(20)
);

CREATE TABLE dvd (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    diretor VARCHAR(100),
    ano_lancamento INT
);

CREATE TABLE aluguel (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_aluguel DATE NOT NULL,
    data_devolucao DATE,
    cliente_cpf VARCHAR(14),
    dvd_codigo INT,
    FOREIGN KEY (cliente_cpf) REFERENCES cliente(cpf),
    FOREIGN KEY (dvd_codigo) REFERENCES dvd(codigo)
);