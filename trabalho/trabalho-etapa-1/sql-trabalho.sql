--------------------------------------------
-- CRIAÇÃO E INSERÇÃO DE TABELAS
--------------------------------------------

CREATE TABLE clientes (
	pk_cliente_id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	cpf VARCHAR(11) NOT NULL UNIQUE,
	telefone VARCHAR(14)
	data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE
);

INSERT INTO clientes (nome, cpf, telefone)
VALUES
	('Ana Silva', '12345678901', '11987654321'),
	('Bruno Santos', '23456789012', '21976543210'),
	('Carlos Oliveira', '34567890123', '31965432109'),
	('Daniela Souzalat', '45678901234', '4195432-1098'),
	('Eduardo Pereira', '56789012345', '5194321-0987'),
	('Fernanda Costa', '67890123456', '6193210-9876'),
	('Gabriel Rodrigues', '78901234567', '7192109-8765'),
	('Helena Martins', '89012345678', '8191098-7654'),
	('Igor Carvalho', '90123456789', '8590987-6543'),
	('Julia Almeida', '01234567890', '9899876-5432'),
	('Lucas Ferreira', '11223344556', '1998876-1122'),
	('Mariana Ribeiro', '22334455667', '1697765-2233'),
	('Nicolas Gomes', '33445566778', '4796654-3344'),
	('Olivia Pinto', '44556677889', '8495543-4455'),
	('Pedro Rocha', '55667788990', '6294432-5566');

--------------------------------------------

CREATE TABLE planos (
	pk_plano_id SERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	valor NUMERIC(8,2) NOT NULL,
	horas_ensaio INTEGER NOT NULL,
	qtd_fotos INTEGER NOT NULL
);

INSERT INTO planos(nome, valor, horas_ensaio, qtd_fotos)
VALUES
	('Plano Couvert', 200.00, 1, 10),
 ('Plano À La Carte', 350.00, 2, 20),
 ('Plano Menu Degustação', 550.00, 3, 40),
 ('Plano Prato Principal', 800.00, 4, 60),
 ('Plano Chef’s Table', 1500.00, 6, 120);

--------------------------------------------

CREATE TABLE formas_pagto (
	pk_forma_pagto_id SERIAL PRIMARY KEY,
	nome_forma_pagto VARCHAR(30) NOT NULL
);

INSERT INTO formas_pagto(nome_forma_pagto)
VALUES
('PIX'),
('Cartão de Crédito'),
('Cartão de Débito');

--------------------------------------------

CREATE TABLE projetos (
	pk_projeto_id SERIAL PRIMARY KEY,
	fk_cliente_id INTEGER REFERENCES clientes(pk_cliente_id),
	fk_plano_id INTEGER REFERENCES planos(pk_plano_id),
	fk_forma_pagto_id INTEGER REFERENCES formas_pagto(pk_forma_pagto_id),
	data_pagto DATE,
	data_producao DATE,
	data_entrega DATE
);

INSERT INTO projetos (fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega)
VALUES
	(1,  3, 1, '2026-01-10', '2026-01-15', '2026-01-25'),
	(2,  1, 2, '2026-01-22', '2026-01-24', '2026-02-02'),
	(3,  4, 1, '2026-02-05', '2026-02-12', '2026-02-28'),
	(4,  2, 3, '2026-02-18', '2026-02-20', '2026-03-01'),
	(5,  5, 2, '2026-03-03', '2026-03-10', '2026-03-25'),
	(6,  1, 1, '2026-03-15', '2026-03-17', '2026-03-24'),
	(7,  3, 2, '2026-04-01', '2026-04-06', '2026-04-18'),
	(8,  2, 1, '2026-04-12', '2026-04-15', '2026-04-22'),
	(9,  4, 3, '2026-05-02', '2026-05-09', '2026-05-26'),
	(10, 5, 2, '2026-05-20', '2026-05-28', '2026-06-15'),
	(11, 1, 1, '2026-06-01', '2026-06-03', '2026-06-10'),
	(12, 3, 3, '2026-06-14', '2026-06-20', '2026-07-02'),
	(13, 2, 2, '2026-06-25', '2026-06-28', NULL),
	(14, 4, 1, '2026-07-01', '2026-07-07', NULL),
	(15, 5, 2, '2026-07-05', NULL,         NULL);

--------------------------------------------

CREATE TABLE fotos (
	pk_foto_id SERIAL PRIMARY KEY,
	fk_projeto_id INTEGER REFERENCES projetos(pk_projeto_id),
	foto_caminho VARCHAR NOT NULL
);

INSERT INTO fotos (fk_projeto_id, foto_caminho)
VALUES
	(1, '/imagens/proj_1/foto_01.jpg'),
	(1, '/imagens/proj_1/foto_02.jpg'),
	(1, '/imagens/proj_1/foto_03.jpg'),
	(2, '/imagens/proj_2/foto_01.jpg'),
	(2, '/imagens/proj_2/foto_02.jpg'),
	(2, '/imagens/proj_2/foto_03.jpg'),
	(2, '/imagens/proj_2/foto_04.jpg'),
	(2, '/imagens/proj_2/foto_05.jpg'),
	(2, '/imagens/proj_2/foto_06.jpg'),
	(2, '/imagens/proj_2/foto_07.jpg'),
	(2, '/imagens/proj_2/foto_08.jpg'),
	(2, '/imagens/proj_2/foto_09.jpg'),
	(2, '/imagens/proj_2/foto_10.jpg'),
	(3, '/imagens/proj_3/foto_01.jpg'),
	(3, '/imagens/proj_3/foto_02.jpg'),
	(3, '/imagens/proj_3/foto_03.jpg'),
	(3, '/imagens/proj_3/foto_04.jpg'),
	(4, '/imagens/proj_4/foto_01.jpg'),
	(4, '/imagens/proj_4/foto_02.jpg'),
	(4, '/imagens/proj_4/foto_03.jpg'),
	(5, '/imagens/proj_5/foto_01.jpg'),
	(5, '/imagens/proj_5/foto_02.jpg'),
	(5, '/imagens/proj_5/foto_03.jpg'),
	(5, '/imagens/proj_5/foto_04.jpg'),
	(5, '/imagens/proj_5/foto_05.jpg'),
	(6, '/imagens/proj_6/foto_01.jpg'),
	(6, '/imagens/proj_6/foto_02.jpg'),
	(6, '/imagens/proj_6/foto_03.jpg'),
	(6, '/imagens/proj_6/foto_04.jpg'),
	(6, '/imagens/proj_6/foto_05.jpg'),
	(6, '/imagens/proj_6/foto_06.jpg'),
	(6, '/imagens/proj_6/foto_07.jpg'),
	(6, '/imagens/proj_6/foto_08.jpg'),
	(6, '/imagens/proj_6/foto_09.jpg'),
	(6, '/imagens/proj_6/foto_10.jpg'),
	(7, '/imagens/proj_7/foto_01.jpg'),
	(7, '/imagens/proj_7/foto_02.jpg'),
	(7, '/imagens/proj_7/foto_03.jpg'),
	(8, '/imagens/proj_8/foto_01.jpg'),
	(8, '/imagens/proj_8/foto_02.jpg'),
	(8, '/imagens/proj_8/foto_03.jpg'),
	(8, '/imagens/proj_8/foto_04.jpg'),
	(9, '/imagens/proj_9/foto_01.jpg'),
	(9, '/imagens/proj_9/foto_02.jpg'),
	(9, '/imagens/proj_9/foto_03.jpg'),
	(10, '/imagens/proj_10/foto_01.jpg'),
	(10, '/imagens/proj_10/foto_02.jpg'),
	(10, '/imagens/proj_10/foto_03.jpg'),
	(10, '/imagens/proj_10/foto_04.jpg'),
	(11, '/imagens/proj_11/foto_01.jpg'),
	(11, '/imagens/proj_11/foto_02.jpg'),
	(11, '/imagens/proj_11/foto_03.jpg'),
	(11, '/imagens/proj_11/foto_04.jpg'),
	(11, '/imagens/proj_11/foto_05.jpg'),
	(11, '/imagens/proj_11/foto_06.jpg'),
	(11, '/imagens/proj_11/foto_07.jpg'),
	(11, '/imagens/proj_11/foto_08.jpg'),
	(11, '/imagens/proj_11/foto_09.jpg'),
	(11, '/imagens/proj_11/foto_10.jpg'),
	(12, '/imagens/proj_12/foto_01.jpg'),
	(12, '/imagens/proj_12/foto_02.jpg'),
	(12, '/imagens/proj_12/foto_03.jpg'),
	(12, '/imagens/proj_12/foto_04.jpg'),
	(13, '/imagens/proj_13/foto_01.jpg'),
	(13, '/imagens/proj_13/foto_02.jpg'),
	(13, '/imagens/proj_13/foto_03.jpg'),
	(14, '/imagens/proj_14/foto_01.jpg'),
	(14, '/imagens/proj_14/foto_02.jpg'),
	(14, '/imagens/proj_14/foto_03.jpg'),
	(14, '/imagens/proj_14/foto_04.jpg'),
	(15, '/imagens/proj_15/foto_01.jpg'),
	(15, '/imagens/proj_15/foto_02.jpg'),
	(15, '/imagens/proj_15/foto_03.jpg');


--------------------------------------------
-- FUNÇÕES PL/PGSQL
--------------------------------------------

--------------------------------------------
-- Função para inserir novos planos
CREATE OR REPLACE FUNCTION insert_novo_plano(
	p_nome VARCHAR,
	p_valor NUMERIC,
	p_hr_ensaio INTEGER,
	p_qtd_fotos INTEGER
) RETURNS BOOLEAN AS
$$
BEGIN

	IF (p_valor >= 0 AND p_hr_ensaio >= 0 AND p_qtd_fotos >= 0) THEN
		INSERT INTO planos (nome, valor, horas_ensaio, qtd_fotos)
		VALUES (p_nome, p_valor, p_hr_ensaio, p_qtd_fotos);
		RETURN true;
	END IF;

	RAISE NOTICE '[ERRO] Valor Plano | Horas Ensaio | Qtd Fotos deve ser maior que zero';
	RETURN false;

END;
$$
LANGUAGE PLPGSQL;


--------------------------------------------
-- Função para inserir clientes
CREATE OR REPLACE FUNCTION insert_cliente(
	p_nome VARCHAR,
	p_cpf VARCHAR,
	p_telefone VARCHAR
) RETURNS BOOLEAN AS
$$
BEGIN

	IF (p_nome IS NULL OR TRIM(p_nome) = '') THEN
		RAISE NOTICE '[ERRO] Nome do Cliente invalido ou vazio!';
		RETURN false;
	END IF;

	IF (p_cpf IS NULL OR TRIM(p_cpf) = '') THEN
		RAISE NOTICE '[ERRO] CPF invalido ou vazio!';
		RETURN false;
	END IF;
	
	INSERT INTO clientes (nome, cpf, telefone)
	VALUES (p_nome, p_cpf, p_telefone);
	RETURN true;

END;
$$
LANGUAGE PLPGSQL;


--------------------------------------------
-- Função para inserir formas_pagto
CREATE OR REPLACE FUNCTION insert_forma_pagto(p_nome VARCHAR) RETURNS BOOLEAN AS
$$
BEGIN

	IF (p_nome IS NULL OR TRIM(p_nome) = '') THEN
		RAISE NOTICE '[ERRO] Nome da Forma Pagto invalido ou vazio!';
		RETURN false;
	END IF; 

	INSERT INTO formas_pagto (nome_forma_pagto) VALUES (p_nome);
	RETURN true;

END;
$$
LANGUAGE PLPGSQL;


--------------------------------------------
-- Função para inserir projeto

CREATE OR REPLACE FUNCTION insert_projeto(
	p_fk_plano_id INTEGER,
	p_fk_cliente_id INTEGER,
	p_fk_forma_pagto_id INTEGER,
	p_data_pagto DATE,
	p_data_producao DATE,
	p_data_entrega DATE
) RETURNS BOOLEAN AS
$$
BEGIN

	IF (p_data_producao >= p_data_entrega) THEN
		RAISE NOTICE '[ERRO] Data de produção deve ser anterior à data de entrega!';
		RETURN false;	
	END IF;

	IF NOT EXISTS (SELECT 1 FROM planos WHERE pk_plano_id = p_fk_plano_id) THEN
		RAISE NOTICE '[ERRO] Plano Não Encontrado!';
		RETURN false;
	END IF;

	IF NOT EXISTS (SELECT 1 FROM clientes WHERE pk_cliente_id = p_fk_cliente_id) THEN
		RAISE NOTICE '[ERRO] Cliente Não Encontrado!';
		RETURN false;
	END IF;

	IF NOT EXISTS (SELECT 1 FROM formas_pagto WHERE pk_forma_pagto_id = p_fk_forma_pagto_id) THEN
		RAISE NOTICE '[ERRO] Forma Pagto Não Encontrada!';
		RETURN false;
	END IF;

	INSERT INTO projetos (
		fk_plano_id, fk_cliente_id, fk_forma_pagto_id,
		data_pagto, data_producao, data_entrega
	) VALUES (
		p_fk_plano_id, p_fk_cliente_id, p_fk_forma_pagto_id,
		p_data_pagto, p_data_producao, p_data_entrega
	);
	RETURN true;

END;
$$
LANGUAGE PLPGSQL;


--------------------------------------------
-- Função para agendamento sem conflito

CREATE OR REPLACE FUNCTION agendamento(
	p_fk_plano_id INTEGER,
	p_fk_cliente_id INTEGER,
	p_fk_forma_pagto_id INTEGER,
	p_data_pagto DATE,
	p_data_producao DATE,
	p_data_entrega DATE
) RETURNS BOOLEAN AS
$$
DECLARE
	producoes INTEGER;

BEGIN

	SELECT COUNT(data_producao) INTO producoes
	FROM projetos
	WHERE data_producao = p_data_producao;

	IF (producoes >= 2) THEN
		RAISE NOTICE '[ERRO] Data indisponivel!';
		RETURN false;
	END IF;

	RETURN insert_projeto(
		p_fk_plano_id,
		p_fk_cliente_id,
		p_fk_forma_pagto_id,
		p_data_pagto,
		p_data_producao,
		p_data_entrega
	);
	-- insert_projeto retorna true

END;
$$
LANGUAGE PLPGSQL;


--------------------------------------------
-- Função para cancelar projeto

CREATE OR REPLACE FUNCTION cancelar_projeto(p_projeto_id INTEGER) RETURNS BOOLEAN AS
$$
BEGIN

	SELECT 1 FROM projetos
	WHERE pk_projeto_id = p_projeto_id;

	IF NOT EXISTS( SELECT 1 FROM projetos WHERE pk_projeto_id = p_projeto_id) THEN
		RAISE NOTICE '[ERRO] Projeto Não Encontrado';
		RETURN false;
	END IF;

	UPDATE projetos
	SET data_producao = NULL, data_entrega = NULL
	WHERE pk_projeto_id = p_projeto_id;
	
	RETURN true;

END;
$$
LANGUAGE PLPGSQL;


--------------------------------------------
-- Função para inserir fotos

CREATE OR REPLACE FUNCTION insert_fotos(
	p_fk_projeto_id INTEGER,
	p_foto VARCHAR
) RETURNS BOOLEAN AS
$$
BEGIN 
	
	IF NOT EXISTS(SELECT 1 FROM projetos WHERE pk_projeto_id = p_fk_projeto_id) THEN
		RAISE NOTICE '[ERRO] Projeto Não Encontrado!';
		RETURN false;
	END IF;
	
	IF (p_foto IS NULL OR TRIM(p_foto) = '') THEN
		RAISE NOTICE '[ERRO] Endereco da imagem invalido ou vazio!';
		RETURN false;
	END IF;

	INSERT INTO fotos (fk_projeto_id, foto_caminho)
	VALUES (p_fk_projeto_id, p_foto);
	RETURN true;

END;
$$
LANGUAGE PLPGSQL;


--------------------------------------------
-- Função para controle entrega fotos

CREATE OR REPLACE FUNCTION controle_cota_fotos(
	p_projeto_id INTEGER,
	p_foto VARCHAR
) RETURNS BOOLEAN AS
$$
DECLARE
	id_plano_contratado INTEGER;
	cota_plano_contratado INTEGER;
	qtd_fotos_registradas INTEGER;

BEGIN

	SELECT fk_plano_id INTO id_plano_contratado FROM projetos
	WHERE pk_projeto_id = p_projeto_id;

	SELECT qtd_fotos INTO cota_plano_contratado FROM planos
	WHERE pk_plano_id = id_plano_contratado;

	SELECT COUNT(pk_foto_id) INTO qtd_fotos_registradas FROM fotos
	WHERE fk_projeto_id = p_projeto_id;

	IF (qtd_fotos_registradas < cota_plano_contratado) THEN
		RETURN insert_fotos(p_projeto_id, p_foto);

	ELSE
		RAISE NOTICE '[ERRO] Cota de fotos do Plano atingida!';
		RETURN false;	
	END IF;
	
	
END;
$$
LANGUAGE PLPGSQL;


--------------------------------------------
-- Função para status do projeto

CREATE OR REPLACE FUNCTION status_projeto(p_projeto_id INTEGER) RETURNS BOOLEAN AS
$$
DECLARE
	dias_para_entrega INTEGER;

BEGIN

	IF NOT EXISTS (SELECT 1 FROM projetos WHERE pk_projeto_id = p_projeto_id) THEN
		RAISE NOTICE '[ERRO] Projeto Não Encontrado!';
		RETURN false;		
	END IF;

	IF EXISTS (
		SELECT 1 FROM projetos 
		WHERE pk_projeto_id = p_projeto_id AND data_entrega = IS NULL
	) THEN
		RAISE NOTICE '[ERRO] Projeto Sem Data Entrega Definida!';
		RETURN false;		
	END IF;

	SELECT (data_entrega - CURRENT_DATE) INTO dias_para_entrega
	FROM projetos
	WHERE pk_projeto_id = p_projeto_id;

	CASE
		WHEN dias_para_entrega < 0 THEN
			RAISE NOTICE '[ATENCAO] Entrega atrasada ha % dias!', ABS(dias_para_entrega);
		WHEN dias_para_entrega <= 5 THEN
			RAISE NOTICE '[ATENCAO] Faltam % dias para entrega!', dias_para_entrega;
		ELSE
			RAISE NOTICE '[AVISO] Faltam % dias para entrega!', dias_para_entrega;
	END CASE;

	RETURN true;

END;
$$
LANGUAGE PLPGSQL;


--------------------------------------------
-- FUNÇÕES DE CONSULTAS SQL
--------------------------------------------

--------------------------------------------
-- Relatório Geral de Contratos

CREATE OR REPLACE FUNCTION relatorio_geral_contratos()
RETURNS TABLE (
	cliente VARCHAR,
    plano VARCHAR,
	valor_contrato NUMERIC,
    forma_pagto VARCHAR,
    data_producao DATE,
    data_entrega DATE
) AS
$$
	SELECT
		cl.nome AS cliente,
		pl.nome AS plano,
		pl.valor AS valor_contrato,
		fp.nome_forma_pagto AS forma_pagto,
		pj.data_producao AS data_producao,
		pj.data_entrega AS data_entrega
	FROM
		projetos pj
	
	INNER JOIN
		clientes cl
		ON pj.fk_cliente_id = cl.pk_cliente_id
	
	INNER JOIN
		planos pl
		ON pj.fk_plano_id = pl.pk_plano_id
	
	INNER JOIN
		formas_pagto fp
		ON pj.fk_forma_pagto_id = fp.pk_forma_pagto_id
	
	ORDER BY pj.data_producao ASC
$$
LANGUAGE SQL;

SELECT * FROM relatorio_geral_contratos();


--------------------------------------------
-- Relatório Agenda de Próximos Ensaios

CREATE OR REPLACE FUNCTION relatorio_producoes_agendadas()
RETURNS TABLE (
	data_producao DATE,
	cliente VARCHAR,
	telefone VARCHAR
) AS
$$

	SELECT 
		pj.data_producao,
		cl.nome AS cliente,
		cl.telefone AS telefone
	FROM
		clientes cl
	INNER JOIN
		projetos pj
		ON pj.fk_cliente_id = cl.pk_cliente_id
	WHERE
		pj.data_producao > CURRENT_DATE
	ORDER BY
		pj.data_producao ASC;
		
$$
LANGUAGE SQL;

SELECT * FROM relatorio_producoes_agendadas();


--------------------------------------------
-- Relatório Faturamento por Plano

CREATE OR REPLACE FUNCTION relatorio_faturamento_plano()
RETURNS TABLE (
	nome VARCHAR,
	qtd_projetos INTEGER,
	faturamento NUMERIC,
	percentual_total NUMERIC
) AS
$$

	SELECT 
		pl.nome AS plano,
		COUNT(pj.pk_projeto_id) AS qtd_projetos,
		SUM(pl.valor) AS faturamento,
		ROUND(
        (SUM(pl.valor) / (SELECT SUM(pl.valor) FROM planos pl INNER JOIN projetos pj ON pj.fk_plano_id = pl.pk_plano_id)) * 100, 2
    	) AS perc_faturamento
	FROM
		planos pl
	INNER JOIN
		projetos pj
		ON pj.fk_plano_id = pl.pk_plano_id
	WHERE
		pj.data_pagto IS NOT NULL
	GROUP BY
		pl.nome, pl.valor
	ORDER BY
		pl.valor DESC
		
$$
LANGUAGE SQL;

SELECT * FROM relatorio_faturamento_plano();


--------------------------------------------
-- Relatório Controle de Inadimplência/Atrasos

CREATE OR REPLACE FUNCTION relatorio_inadimplencia()
RETURNS TABLE (
	cliente VARCHAR,
	telefone VARCHAR,
	plano VARCHAR,
	valor_pagar NUMERIC
)
AS
$$
	SELECT
		cl.nome AS cliente,
		cl.telefone AS telefone,
		pl.nome AS plano,
		pl.valor AS valor_pagar
	FROM
		projetos pj
	INNER JOIN
		clientes cl
		ON pj.fk_cliente_id = cl.pk_cliente_id
	INNER JOIN
		planos pl
		ON pj.fk_plano_id = pl.pk_plano_id
	WHERE
		pj.data_pagto IS NULL
$$
LANGUAGE SQL;

SELECT * FROM relatorio_inadinplencia();


--------------------------------------------
-- Relatório Relatório de Progresso das Fotos

CREATE OR REPLACE FUNCTION relatorio_progresso_entregas()
RETURNS TABLE (
	cliente VARCHAR,
	plano VARCHAR,
	fotos_a_entregar INTEGER,
	total_fotos_entregues INTEGER, 
	percentual_entregue NUMERIC
)
AS 
$$
	SELECT
		cl.nome AS cliente,
		pl.nome AS plano,
		pl.qtd_fotos AS fotos_a_entregar,
		COUNT(fo.pk_foto_id) AS total_fotos_entregues,
		ROUND((COUNT(fo.pk_foto_id)::NUMERIC / pl.qtd_fotos::NUMERIC) * 100, 2) AS percentual_entregue
	FROM
		projetos pj
	INNER JOIN
		planos pl ON pj.fk_plano_id = pl.pk_plano_id
	INNER JOIN
		clientes cl ON pj.fk_cliente_id = cl.pk_cliente_id
	LEFT JOIN 
		fotos fo ON pj.pk_projeto_id = fo.fk_projeto_id
	WHERE
		(pj.data_pagto IS NOT NULL) OR (pj.data_producao IS NOT NULL)
	GROUP BY
		cl.nome, pl.nome, pl.qtd_fotos;
$$
LANGUAGE SQL;

SELECT * FROM relatorio_progresso_entregas();
