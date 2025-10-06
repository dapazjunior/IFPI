CREATE DATABASE produtos_limpeza;
USE produtos_limpeza;

CREATE TABLE cliente (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    telefone VARCHAR(20),
    status ENUM('bom', 'medio', 'ruim') DEFAULT 'medio',
    limite_credito DECIMAL(15,2)
);

CREATE TABLE produto (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    preco DECIMAL(10,2) NOT NULL
);

CREATE TABLE pedido (
    numero INT PRIMARY KEY AUTO_INCREMENT,
    data DATE NOT NULL,
    cliente_codigo INT,
    FOREIGN KEY (cliente_codigo) REFERENCES cliente(codigo)
);

CREATE TABLE item_pedido (
    pedido_numero INT,
    produto_codigo INT,
    quantidade INT NOT NULL,
    PRIMARY KEY (pedido_numero, produto_codigo),
    FOREIGN KEY (pedido_numero) REFERENCES pedido(numero),
    FOREIGN KEY (produto_codigo) REFERENCES produto(codigo)
);