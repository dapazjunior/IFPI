CREATE TABLE colecaocd_cd (
    codigo INT UNSIGNED NOT NULL,
    nome VARCHAR(45) NOT NULL,
    datacompra DATE NOT NULL,
    valorpago DECIMAL(5,2) UNSIGNED NOT NULL,
    localcompra VARCHAR(45) NOT NULL,
    album ENUM('S','N') NOT NULL,
    artista VARCHAR(50) NOT NULL,
    CONSTRAINT PK_codigo PRIMARY KEY(codigo)
)


CREATE TABLE colecaocd_musica (
    cd_codigo INT UNSIGNED NOT NULL,
    numero INT UNSIGNED NOT NULL,
    nome VARCHAR(45) NOT NULL,
    duracao INT UNSIGNED NOT NULL
    CONSTRAINT PK_cd_codigo_numero PRIMARY KEY(cd_codigo, numero),
    CONSTRAINT FK_cd_codigo FOREIGN KEY (cd_codigo) REFERENCES colecaocd_cd(codigo)
)


INSERT INTO colecaocd_cd VALUES 
(1, 'Transpiração Contínua Prolongada', '1997-06-16', 29.90, 'Submarino', 'S', 'Charlie Brown Jr.');

INSERT INTO colecaocd_musica VALUES
(1, 1, 'Proibida Pra Mim (Grazon)', 208),
(1, 2, 'O Coro Vai Comê!', 191),
(1, 3, 'Tudo Que Ela Gosta de Escutar', 207),
(1, 4, 'Quinta-Feira', 180),
(1, 5, 'Gimme o Anel', 175),
(1, 6, 'Confisco', 190),
(1, 7, 'Zoio de Lula', 205),
(1, 8, 'Rubão, o Dono do Mundo', 200);


INSERT INTO colecaocd_cd VALUES 
(2, 'Preço Curto... Prazo Longo', '1999-03-06', 32.50, 'Saraiva', 'S', 'Charlie Brown Jr.');

INSERT INTO colecaocd_musica VALUES
(2, 1, 'Te Levar', 210),
(2, 2, 'Zóio de Lula', 228),
(2, 3, 'Rubão, o Dono do Mundo II', 195),
(2, 4, 'Lugar ao Sol', 230),
(2, 5, 'Não Deixe o Mar te Engolir', 198),
(2, 6, 'O Preço', 223),
(2, 7, 'Hoje Eu Acordei Feliz', 208),
(2, 8, 'Dois Cigarros', 194);


INSERT INTO colecaocd_cd VALUES 
(3, 'Nadando com os Tubarões', '2000-08-15', 34.90, 'Lojas Americanas', 'S', 'Charlie Brown Jr.');

INSERT INTO colecaocd_musica VALUES
(3, 1, 'Rubão II - O Retorno do Rei', 205),
(3, 2, 'Não é Sério', 230),
(3, 3, 'Como Tudo Deve Ser', 240),
(3, 4, 'Vícios e Virtudes', 225),
(3, 5, 'O Que é da Casa é da Casa', 215),
(3, 6, 'Tudo Mudar', 200),
(3, 7, 'Hoje', 210),
(3, 8, 'Pra Não Dizer que Não Falei das Flores', 195);


INSERT INTO colecaocd_cd VALUES 
(4, '100% Charlie Brown Jr. – Abalando a Sua Fábrica', '2001-04-16', 33.00, 'Amazon', 'S', 'Charlie Brown Jr.');

INSERT INTO colecaocd_musica VALUES
(4, 1, 'Papo Reto (Prazer é Sexo o Resto é Negócio)', 210),
(4, 2, 'Sino Dourado', 190),
(4, 3, 'Zóio de Lula (Ao Vivo)', 230),
(4, 4, 'Lugar ao Sol (Ao Vivo)', 225),
(4, 5, 'Hoje Eu Acordei Feliz (Ao Vivo)', 215),
(4, 6, 'Tamo Aí na Atividade', 235),
(4, 7, 'Gimme o Anel (Versão 2001)', 200),
(4, 8, 'Confisco (Ao Vivo)', 220);


INSERT INTO colecaocd_cd VALUES 
(5, 'Tamo Aí na Atividade', '2004-04-30', 35.00, 'FNAC', 'S', 'Charlie Brown Jr.');

INSERT INTO colecaocd_musica VALUES
(5, 1, 'Tamo Aí na Atividade', 225),
(5, 2, 'Champanhe e Água Benta', 210),
(5, 3, 'Cada Cabeça um Mundo', 205),
(5, 4, 'Lutar pelo que é Meu', 220),
(5, 5, 'Não Uso Sapato', 200),
(5, 6, 'Todos Iguais', 215),
(5, 7, 'A Estrada é Longa', 230),
(5, 8, 'Hoje Acordei Feliz pra Cacete', 210);


/*a) Mostrar todos os CDs*/
SELECT * 
FROM colecaocd_cd

/*b) Mostrar os campos nome e data da compra dos CDs ordenados por nome*/
SELECT nome, datacompra
FROM colecaocd_cd
ORDER BY nome;

/*c) Mostrar os campos nome e data da compra dos CDs classificados por data de compra em ordem decrescente*/
SELECT nome, datacompra 
FROM colecaocd_cd
ORDER BY datacompra DESC;

/*d) Mostrar o total gasto com a compra dos CDs*/
SELECT SUM(valorpago) AS totalgasto
FROM colecaocd_cd

/*e) Mostrar todas as músicas (todos os campos) do CD com o código 1*/
SELECT *
FROM colecaocd_musica
WHERE cd_codigo = 1;

/*f) Mostrar o nome do CD e o nome das músicas de todos CDs*/
SELECT c.nome AS nome_cd, m.nome AS nome_musica
FROM colecaocd_cd AS c INNER JOIN colecaocd_musica AS m
ON c.codigo = m.cd_codigo;

/*g) Mostrar o nome e o artista de todas as músicas cadastradas*/
SELECT m.nome AS nome_musica, c.artista
FROM colecaocd_musica as m INNER JOIN colecaocd_cd as c
ON m.cd_codigo = c.codigo

/*h) Mostrar o tempo total de músicas cadastradas*/
SELECT SUM(duracao) AS tempototal
FROM colecaocd_musica

/*i) Mostrar o número, nome e tempo das músicas do CD com o código 5 por ordem de número*/
SELECT numero, nome, duracao
FROM colecaocd_musica
WHERE cd_codigo = 5
ORDER BY numero;

/*j) Mostrar o número, nome e tempo das músicas do CD com o nome “Reginaldo Rossi – Perfil” por ordem de nome*/
SELECT m.numero, m.nome, m.duracao
FROM colecaocd_cd AS c INNER JOIN colecaocd_musica AS m
ON m.cd_codigo = c.codigo
WHERE c.nome = "Reginaldo Rossi – Perfil"
ORDER BY m.nome;

/*k) Mostrar o tempo total de músicas por CD*/
SELECT cd_codigo, SUM(duracao) AS tempototal
FROM colecaocd_musica
GROUP BY cd_codigo;

/*l) Mostrar a quantidade de músicas cadastradas*/
SELECT COUNT(*) AS qtdmusicas
FROM colecaocd_musica;

/*m) Mostrar a média de duração das músicas cadastradas*/
SELECT SUM(duracao) / COUNT(*) as mediatempo
FROM colecaocd_musica

/*n) Mostrar a quantidade de CDs*/
SELECT COUNT(*) AS qtdcds
FROM colecaocd_cd;

/*o) Mostrar o nome das músicas do artista Reginaldo Rossi*/
SELECT m.nome
FROM colecaocd_cd AS c INNER JOIN colecaocd_musica AS m
ON m.cd_codigo = c.codigo
WHERE c.artista = "Reginaldo Rossi"

/*p) Mostrar a quantidade de músicas por CDs*/
SELECT cd_codigo, COUNT(*) AS musicasporcd
FROM colecaocd_musica
GROUP BY cd_codigo;

/*q) Mostrar o nome de todos os CDs comprados no “Submarino.com”*/
SELECT nome
FROM colecaocd_cd
WHERE localcompra = "Submarino.com"

/*r) Mostrar o nome do CD e o nome da primeira música de todos os CDs*/
SELECT c.nome, m.nome
FROM colecaocd_cd AS c INNER JOIN colecaocd_musica AS m
ON m.cd_codigo = c.codigo
WHERE m.numero = 1

/*s) Mostrar uma listagem de músicas em ordem alfabética*/
SELECT *
FROM colecaocd_musica
ORDER BY nome;

/*t) Mostrar todos os CDs que são álbuns*/
SELECT *
FROM colecaocd_cd
WHERE album = "S"

/*u) Mostrar o CD que custou mais caro*/
SELECT *
FROM colecaocd_cd
WHERE valorpago = (SELECT MAX(valorpago) FROM colecaocd_cd);

/*v) Mostrar os CDs comprados em julho de 2014*/
SELECT *
FROM colecaocd_cd
WHERE datacompra BETWEEN '2014-07-01' AND '2014-07-31';

/*w) Mostrar os CDs cujo valor pago esteja entre R$ 30,00 e R$ 50,00*/
SELECT *
FROM colecaocd_cd
WHERE valorpago BETWEEN 30 AND 50;

/*x) Mostrar as musicas dos CDs com código 1, 3 e 6*/
SELECT *
FROM colecaocd_musica
WHERE cd_codigo IN (1, 3, 6);

/*y) Mostrar o CD que tem a maior quantidade de músicas cadastradas*/
SELECT cd_codigo, COUNT(*) AS qtd_musicas
FROM colecaocd_musica
GROUP BY cd_codigo
HAVING COUNT(*) = (
    SELECT MAX(qtd_musicas)
    FROM (
        SELECT cd_codigo, COUNT(*) AS qtd_musicas
        FROM colecaocd_musica
        GROUP BY cd_codigo
    ) AS sub
);


/*z) Mostrar o artista que possui a maior quantidade de CDs cadastrados*/
SELECT artista, COUNT(*) AS qtd_cds
FROM colecaocd_cd
GROUP BY artista
HAVING COUNT(*) = (
    SELECT MAX(qtd_cds)
    FROM (
        SELECT artista, COUNT(*) AS qtd_cds
        FROM colecaocd_cd
        GROUP BY artista
    ) AS sub
);