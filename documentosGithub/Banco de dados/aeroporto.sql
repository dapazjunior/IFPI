CREATE DATABASE aeroporto;
USE aeroporto;

CREATE TABLE modelo_aviao (
    codigo VARCHAR(10) PRIMARY KEY,
    capacidade INT,
    peso DECIMAL(10,2)
);

CREATE TABLE aviao (
    numero_registro VARCHAR(20) PRIMARY KEY,
    modelo_codigo VARCHAR(10),
    FOREIGN KEY (modelo_codigo) REFERENCES modelo_aviao(codigo)
);

CREATE TABLE tecnico (
    cpf VARCHAR(14) PRIMARY KEY,
    endereco VARCHAR(200),
    telefone VARCHAR(20),
    salario DECIMAL(10,2)
);

CREATE TABLE tecnico_modelo (
    tecnico_cpf VARCHAR(14),
    modelo_codigo VARCHAR(10),
    PRIMARY KEY (tecnico_cpf, modelo_codigo),
    FOREIGN KEY (tecnico_cpf) REFERENCES tecnico(cpf),
    FOREIGN KEY (modelo_codigo) REFERENCES modelo_aviao(codigo)
);

CREATE TABLE teste (
    numero_ana INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    pontuacao_maxima INT
);

CREATE TABLE teste_realizado (
    id INT PRIMARY KEY AUTO_INCREMENT,
    aviao_registro VARCHAR(20),
    tecnico_cpf VARCHAR(14),
    teste_numero_ana INT,
    data_realizacao DATE,
    horas_gastas DECIMAL(5,2),
    pontuacao_obtida INT,
    FOREIGN KEY (aviao_registro) REFERENCES aviao(numero_registro),
    FOREIGN KEY (tecnico_cpf) REFERENCES tecnico(cpf),
    FOREIGN KEY (teste_numero_ana) REFERENCES teste(numero_ana)
);