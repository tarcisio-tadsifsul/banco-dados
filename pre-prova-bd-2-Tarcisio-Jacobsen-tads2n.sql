
create table cliente(
pk_cliente integer primary key,
nome varchar(50)
);

insert into cliente (pk_cliente,nome) values
(1,'Cliente1'),
(2,'Cliente2'),
(3,'Cliente3'),
(4,'Cliente4'),
(5,'Cliente5');

create table produto(
pk_produto integer primary key,
produto varchar(50),
quantidade numeric(8,2),
valor numeric(8,2)
);

insert into produto (pk_produto,produto, quantidade,valor) values
(1,'Produto1',100,10),
(2,'Produto2',200,20),
(3,'Produto3',300,30),
(4,'Produto4',400,40),
(5,'Produto5',500,50);
(6,'Produto6',100,10),
(7,'Produto7',200,20),
(8,'Produto8',300,30),
(9,'Produto9',400,40),
(10,'Produto10',500,50);

create table venda(
cod_venda serial primary key,
fk_cod_cliente integer references cliente(pk_cliente),
fk_cod_produto integer references produto(pk_produto),
quantidade_venda numeric(8,2),
valor_venda numeric(8,2)
);

--Compras do Cliente 1
insert into venda (fk_cod_cliente,fk_cod_produto,quantidade_venda,valor_venda) values
 (1,2,2,20), (1,3,3,30), (1,4,4,40), (1,5,5,50);

--Compras do Cliente 2
insert into venda (fk_cod_cliente,fk_cod_produto,quantidade_venda,valor_venda) values
(2,1,1,10), (2,3,2,30), (2,4,2,40), (2,5,2,50);

--Compras do Cliente 3
insert into venda (fk_cod_cliente,fk_cod_produto,quantidade_venda,valor_venda) values
(3,1,5,10), (3,2,4,20), (3,4,2,40), (3,5,1,50);

--Compras do Cliente 1
insert into venda (fk_cod_cliente,fk_cod_produto,quantidade_venda,valor_venda) values
(4,1,1,10), (4,2,1,20), (4,3,1,30),  (4,5,1,50);

--Compras do Cliente 1
insert into venda (fk_cod_cliente,fk_cod_produto,quantidade_venda,valor_venda) values
(5,1,3,10), (5,2,2,20), (5,3,4,30), (5,4,4,40);

--1) Implemente uma função chamada venda_1 para adicionar dados a tabela venda.
--   A função recebe por paramentro:
--   - Codigo do cliente, 
--   - Código do produto, 
--   - Quantidade vendida, 
--   - Preco do produto
--   Então faz o cadastro da venda na tabela venda.

CREATE OR REPLACE FUNCTION venda_1(
	id_cliente INTEGER,
	id_produto INTEGER,
	qtd_vendida NUMERIC,
	preco_produto NUMERIC
) RETURNS VOID AS
$$
DECLARE

BEGIN
	INSERT INTO venda (fk_cod_cliente, fk_cod_produto, quantidade_venda, valor_venda)
	VALUES (id_cliente, id_produto, qtd_vendida, preco_produto);
	RETURN;
END;
$$
LANGUAGE PLPGSQL;

SELECT venda_1(1,1,10,10);

-- [#1 - CORREÇÃO]




--==========================================================================

--2) Implemente uma função chamada venda_2 para adicionar dados a tabela venda.
--
--   A função recebe por paramentro:
--    # Codigo do cliente, 
-- 	  # Código do produto, 
-- 	  # Quantidade vendida. 
--
-- 	  O preço do produto deve ser buscado na tabela produto,
--    com base no código do produto passado por parametro. 
--    Então faz o cadastro da venda na tabela venda.

CREATE OR REPLACE FUNCTION venda_2(
	id_cliente INTEGER,
	id_produto INTEGER,
	qtd_vendida NUMERIC
) RETURNS VOID AS
$$

DECLARE
	preco_produto NUMERIC;

BEGIN
	SELECT valor INTO preco_produto
	FROM produto
	WHERE pk_produto = id_produto;

	IF FOUND THEN
		INSERT INTO venda (
			fk_cod_cliente,
			fk_cod_produto,
			quantidade_venda,
			valor_venda
		) VALUES (
			id_cliente,
			id_produto,
			qtd_vendida,
			preco_produto
		);
		
		RAISE NOTICE 'Venda Registrada com Sucesso!';
		RETURN;
		
	ELSE
	
		RAISE NOTICE '[ERRO] Venda NÃO Registrada!';
		RETURN;
		
	END IF;
	
END;
$$
LANGUAGE PLPGSQL;

SELECT venda_2(3,3,5);

-- [#2 - CORREÇÃO]




--==========================================================================

--3) Implemente uma função chamada cliente_1
--  
--   que recebe por parametro código do cliente
--   e retorne o nome dele.
--
--   Caso o código do cliente não seja encotrado,
--   a função retorna o valor 'CLIENTE NAO ENCONTRADO'.

DROP FUNCTION cliente_1;

CREATE OR REPLACE FUNCTION cliente_1(id_cliente INTEGER)
RETURNS VARCHAR AS
$$
DECLARE
	nome_cliente VARCHAR;
BEGIN

	SELECT nome INTO nome_cliente
	FROM cliente
	WHERE pk_cliente = id_cliente;

--  IF (nome_cliente IS NULL) THEN
	IF NOT FOUND THEN
	 	RETURN 'CLIENTE NAO ENCONTRADO';
		 
	ELSE
		RAISE NOTICE 'CLIENTE: %', nome_cliente;
		RETURN nome_cliente;
	END IF;
	
END;
$$
LANGUAGE PLPGSQL;

SELECT cliente_1(1) AS nome_cliente;


--4) Implemente uma funçao chamada produto_1
--
--   que recebe por paramentro o código de um produto
--   e retorne o valor dele.
--
--   Caso o código do produto não seja encontrado,
--   a função deve retornar o valor -1.

CREATE OR REPLACE FUNCTION produto_1(id_produto INTEGER) RETURNS NUMERIC AS
$$
DECLARE
	valor_produto NUMERIC;
	
BEGIN
	SELECT valor INTO valor_produto
	FROM produto
	WHERE pk_produto = id_produto;

	IF NOT FOUND THEN
		RAISE NOTICE 'PRODUTO NAO ENCONTRADO | id: %', id_produto;
	 	RETURN -1;
	ELSE
		RAISE NOTICE 'PRODUTO ENCONTRADO!';
		RETURN valor_produto;
	END IF;

END;
$$
LANGUAGE PLPGSQL;

SELECT produto_1(1) AS valor_produto;


--5) Implemente uma funçao chamada produto_2 que recebe por parametro
--   # Código de produto 
--   # Quantidade a ser subtraida do estoque
--   Retornando true em caso de sucesso.

--   Caso o código do produto nao exista ou a quantidade passada por parametro
--   for maior que atual quantidade de estoque,
--   a função nao deve realizar a operação e deve retornar false. 

--   Só realize a subtração da quantidade se o valor (quantidade) passado por parametro
--   for menor que quantidade atual do estoque.
--   Em caso de sucesso, a função retorna true.

CREATE OR REPLACE FUNCTION produto_2(id_produto INTEGER, qtd_sub NUMERIC)
RETURNS BOOLEAN AS
$$
DECLARE
	produto_existe INTEGER;
	qtd_produto NUMERIC;

BEGIN

	SELECT 1 INTO produto_existe FROM produto WHERE pk_produto = id_produto;
	IF NOT FOUND THEN
		RAISE NOTICE 'OPERACAO INVALIDA!';
		RETURN false;
	END IF;
		
	SELECT quantidade INTO qtd_produto FROM produto WHERE pk_produto = id_produto;
	IF (qtd_produto < qtd_sub) THEN
		RAISE NOTICE 'OPERACAO INVALIDA!';
		RETURN false;
	END IF;
	
	UPDATE produto SET quantidade = quantidade - qtd_sub
	WHERE pk_produto = id_produto;
	RAISE NOTICE 'Quantidade atualizada com Sucesso!';
	RETURN true;
	
END;
$$
LANGUAGE PLPGSQL;

SELECT produto_2(3,10);

-- [#5 - CORREÇÃO]

-- CREATE OR REPLACE FUNCTION produto_2(id_produto INTEGER, qtd_sub NUMERIC)
-- RETURNS BOOLEAN AS
-- $$
-- DECLARE
-- 	qtd_produto NUMERIC;

-- BEGIN
-- 	-- Recupera quantidade
-- 	SELECT quantidade INTO qtd_produto
-- 	FROM produto
-- 	WHERE pk_produto = id_produto;
	
-- 	-- Testa se produto existe
-- 	IF (NOT FOUND) THEN
-- 		RETURN false;
-- 	END IF;

-- 	-- Testa estoque
-- 	IF (qtd_produto < qtd_sub) THEN
-- 		RETURN false;
-- 	END IF;

-- 	-- Atualiza estoque
-- 	UPDATE produto SET quantidade = quantidade - qtd_sub
-- 	WHERE pk_produto = id_produto;
-- 	RETURN true;

	
-- END;
-- $$
-- LANGUAGE PLPGSQL;

--==========================================================================


--6) Implemente um função chamada apagar_1
--   que recebe um código de produto 
--   e apague este produto e todas as suas vendas.

CREATE OR REPLACE FUNCTION apagar_1(id_produto INTEGER)
RETURNS VOID AS
$$
DECLARE
	nome_produto TEXT;
	
BEGIN

	SELECT p.produto INTO nome_produto
	FROM produto AS p
	WHERE pk_produto = id_produto;
	
	IF FOUND THEN
		DELETE FROM venda
		WHERE fk_cod_produto = id_produto;

		DELETE FROM produto
		WHERE pk_produto = id_produto;
		
		RAISE NOTICE 'PRODUTO DELETADO ID: % | %', id_produto, nome_produto;
		
	END IF;

END;
$$
LANGUAGE PLPGSQL;

SELECT apagar_1(5);

-- [#6 - CORREÇÃO]

-- CREATE OR REPLACE FUNCTION apagar_1(id_produto INTEGER)
-- RETURNS VOID AS
-- $$
-- DECLARE
	
-- BEGIN
-- 	DELETE FROM venda
-- 	WHERE fk_cod_produto = id_produto;

-- 	DELETE FROM produto
-- 	WHERE pk_produto = id_produto;	

-- END;
-- $$
-- LANGUAGE PLPGSQL;

--==========================================================================



--7) Implemente um função total_compras_1 que recebe por parametro:
--	 # código de cliente 
-- 	 
-- 	 E retorne o somatorio de todas as compras já feitas por este cliente. 

CREATE OR REPLACE FUNCTION total_compras_1(id_cliente INTEGER)
RETURNS NUMERIC AS
$$
DECLARE
	soma_compras NUMERIC;

BEGIN
	SELECT SUM(quantidade_venda * valor_venda) INTO soma_compras
	FROM venda
	WHERE fk_cod_cliente = $1;

	RETURN soma_compras;

END
$$
LANGUAGE PLPGSQL;

SELECT total_compras_1(2) AS total_compras;
SELECT * FROM venda

--8) Implemente uma função estoque_1 que recebe por paramentro uma quantidade e 
-- retorne uma tabela com todos os produtos com a quantidade
-- menor que a passada por paramentro.

CREATE OR REPLACE FUNCTION estoque_1(NUMERIC)
-- SETOF retorna um conjunto de dados e...
RETURNS SETOF produto AS
$$
DECLARE	

BEGIN
-- return query vai retornar o conjunto de dados
	RETURN QUERY SELECT * FROM produto WHERE quantidade < $1;

END;
$$
LANGUAGE PLPGSQL;

-- ...select * from funcao() tabula os dados retornados
SELECT * FROM estoque_1(301);


--9) Implemente uma função chamada desconto_1 que recebe um vetor com código dos produtos 
--  e um valor de desconto. A função deve aplicar o desconto passado por parametro a todos os 
-- produtos que contém código no vetor passado por parametro. Se algum código do vetor 
-- não for encotrado na tabela produto, a função deve mostra a mensagem (raise notice) avisando
-- que determinado código de produto não foi encontrado.




--10) Implemente um função chamada produto_1 que recebe por parametro todos os campos da tabela
-- produto e adicine estes valores a tabela.





--
CREATE OR REPLACE FUNCTION nome_funcao(args TIPO)
RETURNS TIPO_RETORNO AS
$$
DECLARE
	

BEGIN

END;
$$
LANGUAGE PLPGSQL;

SELECT nome_funcao(param);