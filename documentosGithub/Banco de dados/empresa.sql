-- Criação do Banco de Dados

CREATE DATABASE empresa;
USE empresa;

-- Tabela de empregados
CREATE TABLE empresa_empregados (
    MATR CHAR(6) NOT NULL,
    NOME VARCHAR(12) NOT NULL,
    SOBRENOME VARCHAR(15) NOT NULL,
    DEPT CHAR(3),
    FONE CHAR(14),
    DATAADM DATE,
    CARGO CHAR(10),
    NIVELEDUC DECIMAL(4,1),
    SEXO CHAR(1),
    DATANASC DATE,
    SALARIO DECIMAL(9,2),
    BONUS DECIMAL(9,2),
    COMIS DECIMAL(9,2),
    PRIMARY KEY (MATR)
);

-- Tabela de departamentos
CREATE TABLE empresa_departamentos (
    DCODIGO CHAR(3) NOT NULL,
    DNOME VARCHAR(36) NOT NULL,
    GERENTE CHAR(6),
    PRIMARY KEY (DCODIGO),
    FOREIGN KEY (GERENTE) REFERENCES empresa_empregados(MATR)
);

-- Tabela de projetos
CREATE TABLE empresa_projetos (
    PCODIGO CHAR(6) NOT NULL,
    PNOME VARCHAR(24) NOT NULL,
    DCODIGO CHAR(3) NOT NULL,
    RESP CHAR(6) NOT NULL,
    EQUIPE DECIMAL(5,0),
    DATAINI DATE,
    DATAFIM DATE,
    PRIMARY KEY (PCODIGO),
    FOREIGN KEY (DCODIGO) REFERENCES empresa_departamentos(DCODIGO),
    FOREIGN KEY (RESP) REFERENCES empresa_empregados(MATR)
);


-- INSERÇÃO DE DADOS

-- Departamentos
INSERT INTO empresa_departamentos VALUES
('A00','Administração Geral',NULL),
('A01','Administração Regional Norte',NULL),
('A02','Administração Regional Sul',NULL),

('B01','Serviços Gerais',NULL),

('C01','Planejamento Estratégico',NULL),

('D01','Desenvolvimento',NULL),
('D02','Desenvolvimento Web',NULL),
('D03','Desenvolvimento Mobile',NULL),

('E01','Serviço de Atendimento',NULL),
('E02','Serviço de Atendimento Especial',NULL),
('E03','Serviço de Atendimento VIP',NULL);


-- Empregados
INSERT INTO empresa_empregados VALUES
('E00001','John','Adamson','A00','(86)99999-0001','2010-01-10','GERENTE',18,'M','1980-05-22',55000,4000,3000),
('E00002','Maria','Santos','A01','(86)99999-0002','2011-02-15','ANALISTA',14,'F','1985-07-10',28000,1000,0),
('E00003','Carlos','Almeida','A02','(86)99999-0003','2012-03-12','GERENTE',17,'M','1988-01-20',48000,2000,1500),
('E00018','Paulo','Gomes','A02','(86)99999-0033','2013-04-17','GERENTE',15,'M','1986-02-28',41000,1500,1000),

('E00004','Julia','Teixeira','B01','(86)99999-0004','2011-09-21','GERENTE',17,'F','1982-12-03',52000,3500,2000),
('E00005','Pedro','Lima','B02','(86)99999-0005','2014-05-17','REPVENDA',14,'M','1988-03-30',26000,1000,4000),
('E00006','Ana','Melo','B02','(86)99999-0006','2017-09-11','ANALISTA',15,'F','1993-09-28',24000,500,0),

('E00007','Hugo','Costa','C01','(86)99999-0007','2013-02-02','GERENTE',19,'M','1981-02-15',60000,4500,3000),
('E00008','Rita','Pires','C02','(86)99999-0008','2019-03-10','PLAN',14,'F','1994-10-15',27000,1000,500),
('E00009','Vera','Leal','C02','(86)99999-0009','2020-01-05','ANALISTA',13,'F','1997-06-22',22000,500,0),

('E00010','Diego','Barros','D01','(86)99999-0010','2009-04-14','GERENTE',18,'M','1979-01-20',58000,5000,3500),
('E00011','Marcos','Silva','D11','(86)99999-0011','2016-06-08','DEV',14,'M','1991-11-12',32000,1500,2000),
('E00012','Elaine','Nobre','D21','(86)99999-0012','2019-08-20','DEV',13,'F','1996-04-19',31000,1200,1500),

('E00015','Paula','Frota','E01','(86)99999-0013','2012-03-02','GERENTE',17,'F','1987-01-30',50000,3000,2000),
('E00016','Heitor','Cruz','E02','(86)99999-0014','2019-11-22','ATENDENTE',12,'M','1999-05-21',17000,300,0),
('E00017','Sofia','Reis','E02','(86)99999-0015','2020-02-26','ATENDENTE',12,'F','2000-07-08',16500,200,0);


-- Projetos
INSERT INTO empresa_projetos VALUES
('P001','Sistema Web','D01','E00010',12,'2021-01-01','2022-12-01'),
('P002','Plano Estratégico','C01','E00007',8,'2020-03-01','2021-09-01'),
('P003','Atendimento 360','E01','E00015',15,'2019-02-01','2020-08-01');


-- CONSULTAS
-- 1
SELECT SOBRENOME, NOME, DEPT, DATANASC, DATAADM, SALARIO
FROM empresa_empregados
WHERE SALARIO > 30000;

-- 2
SELECT * FROM empresa_departamentos
WHERE GERENTE IS NULL;

-- 3
SELECT SOBRENOME, NOME, DEPT, DATANASC, DATAADM, SALARIO
FROM empresa_empregados
WHERE SALARIO < 20000
ORDER BY SOBRENOME, NOME;

-- 4
SELECT * FROM empresa_departamentos
WHERE DCODIGO LIKE 'A%';

-- 5
SELECT DCODIGO, DNOME
FROM empresa_departamentos
WHERE DNOME LIKE '%SERVIÇO%';

-- 6
SELECT MATR, SOBRENOME, DEPT, FONE
FROM empresa_empregados
WHERE DEPT BETWEEN 'D11' AND 'D21';

-- 7
SELECT SOBRENOME, DEPT, (SALARIO + COMIS) AS rendimento
FROM empresa_empregados
WHERE DEPT IN ('B01','C01','D01')
ORDER BY DEPT, rendimento DESC;

-- 8
SELECT SOBRENOME, (SALARIO/12) AS salario_mensal, DEPT
FROM empresa_empregados
WHERE (SALARIO/12) > 3000
ORDER BY SOBRENOME;

-- 9
SELECT MATR, NOME, SOBRENOME
FROM empresa_empregados
WHERE DEPT LIKE 'E%'
ORDER BY SOBRENOME;

-- 10
SELECT MATR, SOBRENOME, (SALARIO/12) AS salario_mensal
FROM empresa_empregados
WHERE SEXO = 'M'
  AND (SALARIO/12) < 1600
ORDER BY salario_mensal DESC;

-- 11
SELECT NOME,
       (COMIS / (SALARIO + BONUS + COMIS)) * 100 AS porcentagem
FROM empresa_empregados
WHERE CARGO = 'REPVENDA';

-- 12
SELECT *
FROM empresa_departamentos
WHERE DCODIGO LIKE 'E01%';

-- 13
SELECT SOBRENOME, SALARIO, CARGO, NIVELEDUC
FROM empresa_empregados
WHERE SALARIO > 40000
  AND CARGO = 'GERENTE'
  AND NIVELEDUC < 16;

-- 14
SELECT SUM(SALARIO), AVG(SALARIO), MIN(SALARIO), MAX(SALARIO)
FROM empresa_empregados;

-- 15
SELECT SOBRENOME
FROM empresa_empregados
ORDER BY SOBRENOME
LIMIT 1;

-- 16
SELECT COUNT(DISTINCT DEPT)
FROM empresa_empregados;

-- 17
SELECT CARGO, AVG(SALARIO)
FROM empresa_empregados
GROUP BY CARGO;

-- 18
SELECT CARGO, AVG(SALARIO)
FROM empresa_empregados
GROUP BY CARGO
HAVING AVG(SALARIO) > 35000;

-- 19
SELECT e.SOBRENOME, e.CARGO
FROM empresa_empregados e
JOIN empresa_departamentos d ON e.DEPT = d.DCODIGO
WHERE d.DNOME LIKE '%PLAN%';

-- 20
SELECT e.SOBRENOME, e.NOME
FROM empresa_empregados e
WHERE e.DEPT = (
    SELECT DEPT
    FROM empresa_empregados
    WHERE SOBRENOME = 'Adamson'
);

-- 21
SELECT DEPT,
       AVG(SALARIO) AS media_salarial,
       COUNT(*) AS qtd
FROM empresa_empregados
WHERE CARGO <> 'ATENDENTE'
GROUP BY DEPT
HAVING COUNT(*) >= 4
ORDER BY qtd DESC;

-- 22
SELECT d.DCODIGO, e.SOBRENOME
FROM empresa_departamentos d
JOIN empresa_empregados e ON d.GERENTE = e.MATR
WHERE d.DCODIGO LIKE 'D01%';

-- 23
SELECT d.DCODIGO, d.DNOME, e.SEXO, AVG(e.SALARIO) AS media
FROM empresa_empregados e
JOIN empresa_departamentos d ON e.DEPT = d.DCODIGO
GROUP BY d.DCODIGO, d.DNOME, e.SEXO
ORDER BY d.DCODIGO, media DESC;
