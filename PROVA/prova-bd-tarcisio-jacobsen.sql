CREATE TABLE livros (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    autor VARCHAR(50) NOT NULL,
    ano INT,
    paginas INT,
    disponivel BOOLEAN DEFAULT TRUE
);

INSERT INTO livros (titulo, autor, ano, paginas, disponivel) VALUES
 ('Livro 1', 'Autor A', 1990, 100, TRUE),
 ('Livro 2', 'Autor A', 1991, 110, FALSE),
 ('Livro 3', 'Autor B', 1992, 120, TRUE),
 ('Livro 4', 'Autor C', 1993, 130, TRUE),
 ('Livro 5', 'Autor C', 1994, 140, TRUE),
 ('Livro 6', 'Autor D', 1995, 150, TRUE),
 ('Livro 7', 'Autor D', 1996, 160, FALSE),
 ('Livro 8', 'Autor D', 1997, 170, TRUE),
 ('Livro 9', 'Autor E', 1998, 180, TRUE),
 ('Livro 10', 'Autor E', 1999, 190, FALSE);


--1. Crie uma função que receba o id de um livro e retorne o título correspondente. 
--Caso o livro não exista, retorne o valor 'Nao Encontrado'.

CREATE OR REPLACE FUNCTION busca_livro(id_livro INT) RETURNS VARCHAR AS
$$
DECLARE
	titulo_livro VARCHAR;

BEGIN

	SELECT titulo INTO titulo_livro FROM livros WHERE id = $1;
	
	IF (NOT FOUND) THEN
		RETURN 'Nao Encontrado';
	END IF;

	RETURN titulo_livro;

END;
$$
LANGUAGE PLPGSQL;

SELECT busca_livro(1) AS titulo_livro;
SELECT busca_livro(100) AS titulo_livro;



--2. Implemente uma função que receba o id de um livro e retorne se ele está disponível 
--(TRUE) ou não (FALSE), com base no campo disponivel.

CREATE OR REPLACE FUNCTION status_livro(id_livro INT) RETURNS BOOLEAN AS
$$
DECLARE
	status BOOLEAN;

BEGIN

	-- SELECT disponivel INTO status FROM livros WHERE id = $1;	
	RETURN (SELECT disponivel FROM livros WHERE id = $1);

END;
$$
LANGUAGE PLPGSQL;

SELECT status_livro(1);
SELECT status_livro(100);


--3. Desenvolva uma função que receba o nome de um autor e retorne todos os livros desse
--autor cadastrados na tabela com os campos título e ano.

DROP FUNCTION busca_livros_autor;
CREATE OR REPLACE FUNCTION busca_livros_autor(nome_autor VARCHAR) RETURNS SETOF livros AS
$$
DECLARE
	
BEGIN
	RETURN QUERY
	SELECT * FROM livros WHERE autor = $1;

END;
$$
LANGUAGE PLPGSQL;

SELECT titulo, ano FROM busca_livros_autor('Autor A');




--4. Implemente uma função que calcule e retorne a média do número de páginas de todos os
--livros cadastrados na tabela com o campo disponível TRUE.

CREATE OR REPLACE FUNCTION media_paginas() RETURNS NUMERIC AS
$$
DECLARE
	media NUMERIC;

BEGIN
	SELECT AVG(paginas) INTO media FROM livros;
	RETURN media;

END;
$$
LANGUAGE PLPGSQL;

SELECT media_paginas() AS media;


--5. Crie uma função que atualize o status de disponibilidade de um livro com base em 
--seu id e em um novo valor booleano (TRUE ou FALSE) passado por parametro.

CREATE OR REPLACE FUNCTION atualiza_disp(id_livro INT, disp BOOLEAN) RETURNS VOID AS
$$
DECLARE

BEGIN
	UPDATE livros SET disponivel = disp WHERE id = id_livro;

END;
$$
LANGUAGE PLPGSQL;

SELECT atualiza_disp(2, FALSE);


--6. Construa uma função que receba um ano como parâmetro e retorne todos os livros 
--publicados antes desse ano, mostrando título, autor e ano.

CREATE OR REPLACE FUNCTION livro_ano(ano_livro INT) RETURNS SETOF livros AS
$$
DECLARE

BEGIN
	RETURN QUERY
	SELECT * FROM livros WHERE ano < $1 ORDER BY ANO DESC;

END;
$$
LANGUAGE PLPGSQL;

SELECT titulo, autor, ano FROM livro_ano(1996);


--7. Elabore uma função que retorne o livro com o maior número de páginas entre todos
--os registros da tabela, incluindo o título e o número de páginas.

CREATE OR REPLACE FUNCTION livro_pag() RETURNS SETOF livros AS
$$
DECLARE

BEGIN	
	RETURN QUERY	
	SELECT * FROM livros WHERE paginas >= (
		SELECT MAX(paginas) FROM livros
	);

END;
$$
LANGUAGE PLPGSQL;

SELECT titulo, paginas FROM livro_pag();



--8. Crie uma função que receba os dados de um novo livro (título, autor, ano, páginas
--e disponibilidade) e insira esse novo registro na tabela livros.

CREATE OR REPLACE FUNCTION cadastra_livros(
	VARCHAR(50),
	VARCHAR(50),
	INTEGER,
	INTEGER,
	BOOLEAN
) RETURNS VOID AS
$$
DECLARE

BEGIN
	INSERT INTO livros (titulo, autor, ano, paginas, disponivel)
	VALUES ($1, $2, $3, $4, $5);

END;
$$
LANGUAGE PLPGSQL;

SELECT cadastra_livros('Livro 12', 'Autor T', 2000, 185, TRUE);
