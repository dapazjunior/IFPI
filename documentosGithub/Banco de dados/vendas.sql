CREATE DATABASE loja;
USE loja;

CREATE TABLE vendedor (
    matricula INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    telefone VARCHAR(20),
    cpf VARCHAR(14) UNIQUE NOT NULL,
    salario_base DECIMAL(10,2)
);

CREATE TABLE cliente (
    cpf VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    identidade VARCHAR(20),
    endereco VARCHAR(200),
    telefone VARCHAR(20)
);

CREATE TABLE produto (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(200) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT DEFAULT 0
);

CREATE TABLE venda (
    numero INT PRIMARY KEY AUTO_INCREMENT,
    data_hora DATETIME NOT NULL,
    valor_total DECIMAL(10,2),
    vendedor_matricula INT,
    cliente_cpf VARCHAR(14),
    FOREIGN KEY (vendedor_matricula) REFERENCES vendedor(matricula),
    FOREIGN KEY (cliente_cpf) REFERENCES cliente(cpf)
);

CREATE TABLE item_venda (
    venda_numero INT,
    produto_codigo INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (venda_numero, produto_codigo),
    FOREIGN KEY (venda_numero) REFERENCES venda(numero),
    FOREIGN KEY (produto_codigo) REFERENCES produto(codigo)
);