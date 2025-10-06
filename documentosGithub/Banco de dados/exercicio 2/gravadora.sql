CREATE DATABASE discografica;
USE discografica;

CREATE TABLE musico (
    cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    telefone VARCHAR(20)
);

CREATE TABLE instrumento (
    codigo INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

CREATE TABLE musico_instrumento (
    musico_cpf VARCHAR(14),
    instrumento_codigo INT,
    PRIMARY KEY (musico_cpf, instrumento_codigo),
    FOREIGN KEY (musico_cpf) REFERENCES musico(cpf),
    FOREIGN KEY (instrumento_codigo) REFERENCES instrumento(codigo)
);

CREATE TABLE produtor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE disco (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    data_lancamento DATE,
    produtor_id INT,
    FOREIGN KEY (produtor_id) REFERENCES produtor(id)
);

CREATE TABLE musica (
    id INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(100)
);

CREATE TABLE disco_musica (
    disco_id INT,
    musica_id INT,
    PRIMARY KEY (disco_id, musica_id),
    FOREIGN KEY (disco_id) REFERENCES disco(id),
    FOREIGN KEY (musica_id) REFERENCES musica(id)
);

CREATE TABLE musica_musico (
    musica_id INT,
    musico_cpf VARCHAR(14),
    PRIMARY KEY (musica_id, musico_cpf),
    FOREIGN KEY (musica_id) REFERENCES musica(id),
    FOREIGN KEY (musico_cpf) REFERENCES musico(cpf)
);