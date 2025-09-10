CREATE DATABASE academia;
USE academia;

CREATE TABLE instrutor (
    rg VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    titulacao VARCHAR(100),
    telefone VARCHAR(20)
);

CREATE TABLE tipo_atividade (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(100) NOT NULL
);

CREATE TABLE turma (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    horario TIME,
    duracao INT,
    data_inicio DATE,
    data_termino DATE,
    tipo_atividade_codigo INT,
    instrutor_rg VARCHAR(20),
    FOREIGN KEY (tipo_atividade_codigo) REFERENCES tipo_atividade(codigo),
    FOREIGN KEY (instrutor_rg) REFERENCES instrutor(rg)
);

CREATE TABLE aluno (
    matricula INT PRIMARY KEY AUTO_INCREMENT,
    data_matricula DATE,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    telefone VARCHAR(20),
    data_nascimento DATE,
    altura DECIMAL(3,2),
    peso DECIMAL(5,2)
);

CREATE TABLE matricula_turma (
    aluno_matricula INT,
    turma_codigo INT,
    data_matricula DATE,
    PRIMARY KEY (aluno_matricula, turma_codigo),
    FOREIGN KEY (aluno_matricula) REFERENCES aluno(matricula),
    FOREIGN KEY (turma_codigo) REFERENCES turma(codigo)
);

CREATE TABLE ausencia (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data DATE NOT NULL,
    aluno_matricula INT,
    turma_codigo INT,
    FOREIGN KEY (aluno_matricula, turma_codigo) REFERENCES matricula_turma(aluno_matricula, turma_codigo)
);