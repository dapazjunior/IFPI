-- Criar banco de dados com codificação UTF-8
CREATE DATABASE IF NOT EXISTS sistema_vendas 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE sistema_vendas;

-- Tabela de vendedores
CREATE TABLE vendedores (
    matricula INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    telefone VARCHAR(20),
    cpf VARCHAR(14) UNIQUE NOT NULL,
    salario_base DECIMAL(10,2) NOT NULL,
    comissao DECIMAL(5,2) DEFAULT 10.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de clientes
CREATE TABLE clientes (
    cpf VARCHAR(14) NOT NULL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    identidade VARCHAR(20),
    endereco VARCHAR(200),
    telefone VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de produtos
CREATE TABLE produtos (
    codigo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de vendas
CREATE TABLE vendas (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data_hora DATETIME NOT NULL,
    vendedor_matricula INT NOT NULL,
    cliente_cpf VARCHAR(14) NOT NULL,
    produto_codigo INT NOT NULL,
    quantidade INT NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (vendedor_matricula) REFERENCES vendedores(matricula),
    FOREIGN KEY (cliente_cpf) REFERENCES clientes(cpf),
    FOREIGN KEY (produto_codigo) REFERENCES produtos(codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Inserir alguns dados de exemplo
INSERT INTO vendedores (nome, endereco, telefone, cpf, salario_base) VALUES
('João Silva', 'Rua A, 123', '(86) 99999-8888', '123.456.789-01', 2000.00),
('Maria Santos', 'Av. B, 456', '(86) 98888-7777', '987.654.321-09', 2200.00),
('Pedro Oliveira', 'Rua C, 789', '(86) 97777-6666', '456.789.123-45', 1800.00);

INSERT INTO clientes (cpf, nome, identidade, endereco, telefone) VALUES
('111.222.333-44', 'Carlos Pereira', '1234567', 'Rua X, 100', '(86) 91111-2222'),
('222.333.444-55', 'Ana Rodrigues', '7654321', 'Av. Y, 200', '(86) 92222-3333'),
('333.444.555-66', 'Luís Fernandes', '9876543', 'Rua Z, 300', '(86) 93333-4444');

INSERT INTO produtos (descricao, preco, quantidade_estoque) VALUES
('Notebook Dell', 3500.00, 10),
('Mouse sem fio', 89.90, 50),
('Teclado mecânico', 199.90, 30),
('Monitor 24"', 899.90, 15),
('Impressora HP', 499.90, 8);