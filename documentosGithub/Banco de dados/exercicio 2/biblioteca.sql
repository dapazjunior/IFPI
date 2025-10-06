CREATE DATABASE biblioteca;
USE biblioteca;

CREATE TABLE nacionalidade (
    codigo INT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE editora (
    cnpj VARCHAR(18) PRIMARY KEY,
    razao_social VARCHAR(100) NOT NULL
);

CREATE TABLE categoria (
    codigo INT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE autor (
    passaporte VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nacionalidade_codigo INT,
    FOREIGN KEY (nacionalidade_codigo) REFERENCES nacionalidade(codigo)
);

CREATE TABLE livro (
    isbn VARCHAR(20) PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    ano INT,
    editora_cnpj VARCHAR(18),
    categoria_codigo INT,
    FOREIGN KEY (editora_cnpj) REFERENCES editora(cnpj),
    FOREIGN KEY (categoria_codigo) REFERENCES categoria(codigo)
);

CREATE TABLE livro_autor (
    livro_isbn VARCHAR(20),
    autor_passaporte VARCHAR(20),
    PRIMARY KEY (livro_isbn, autor_passaporte),
    FOREIGN KEY (livro_isbn) REFERENCES livro(isbn),
    FOREIGN KEY (autor_passaporte) REFERENCES autor(passaporte)
);