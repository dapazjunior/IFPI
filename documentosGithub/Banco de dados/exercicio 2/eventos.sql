CREATE DATABASE eventos;
USE eventos;

CREATE TABLE local_evento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100),
    estado CHAR(2),
    capacidade INT
);

CREATE TABLE evento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(200) NOT NULL,
    data_inicio DATE,
    data_termino DATE,
    local_id INT,
    FOREIGN KEY (local_id) REFERENCES local_evento(id)
);

CREATE TABLE acomodacao (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    local_id INT,
    quantidade INT,
    FOREIGN KEY (local_id) REFERENCES local_evento(id)
);

CREATE TABLE ingresso (
    id INT PRIMARY KEY AUTO_INCREMENT,
    evento_id INT,
    acomodacao_id INT,
    data_compra DATETIME,
    preco_pago DECIMAL(10,2),
    FOREIGN KEY (evento_id) REFERENCES evento(id),
    FOREIGN KEY (acomodacao_id) REFERENCES acomodacao(id)
);