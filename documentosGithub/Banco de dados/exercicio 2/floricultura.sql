CREATE DATABASE floricultura;
USE floricultura;

CREATE TABLE cliente (
    cpf VARCHAR(14) PRIMARY KEY,
    rg VARCHAR(20),
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(200)
);

CREATE TABLE produto (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50),
    preco DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT DEFAULT 0
);

CREATE TABLE venda (
    numero_nf INT PRIMARY KEY AUTO_INCREMENT,
    data DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    cliente_cpf VARCHAR(14),
    FOREIGN KEY (cliente_cpf) REFERENCES cliente(cpf)
);

CREATE TABLE item_venda (
    venda_numero_nf INT,
    produto_codigo INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (venda_numero_nf, produto_codigo),
    FOREIGN KEY (venda_numero_nf) REFERENCES venda(numero_nf),
    FOREIGN KEY (produto_codigo) REFERENCES produto(codigo)
);