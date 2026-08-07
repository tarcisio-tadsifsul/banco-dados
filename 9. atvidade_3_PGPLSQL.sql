create table cliente (
	pk_cliente serial primary key,
	nome varchar(100),
	cpf varchar(15)
);


insert into cliente (nome,cpf) values 
	('Maria','111.111.111-11'), ('João','222.222.222-22'), ('cliente','000.000.000-00');


create table produto(
	pk_produto serial primary key,
	nome varchar(50),
	quantidade numeric(8,2),
	valor numeric(8,2)
);

insert into produto (nome,quantidade,valor) values
	('Produto 1',100,10), ('Produto 2',200,20),('Produto 3',300,30);

create table venda(
	pk_venda serial primary key,
	data date default current_date,
	hora time default current_time,
	fk_cliente integer,
	numerio_nota serial
);

alter table venda add constraint fk_venda_cliente
	FOREIGN key (fk_cliente) REFERENCES cliente(pk_cliente);


create table itens (
	pk_itens  serial primary key,
	fk_venda integer,
	fk_produto integer,
	quantidade numeric(8,2),
	valor numeric(8,2),
	subtotal numeric(8,2) generated always as (quantidade*valor) stored
);
	
	
alter table itens add constraint fk_itens_venda
	FOREIGN key (fk_venda) references venda(pk_venda);
	
alter table itens add constraint fk_itens_produto
	FOREIGN key (fk_produto) references produto(pk_produto);


--==========================================================================

--Função:busca_valor_produto
--Linguagem: plpgsql
--Entrada: código do produto INTEGER
--Saída: valor NUMERIC ou -1 se não encontrado

CREATE OR REPLACE FUNCTION busca_valor_produto(INTEGER) RETURNS NUMERIC AS
$$
DECLARE
	valor_produto NUMERIC := -1;
	
BEGIN
	SELECT valor INTO valor_produto
	FROM produto
	WHERE pk_produto = $1;
	
	IF (FOUND) THEN
		RAISE NOTICE 'Produto ID: % | Valor: %', $1, valor_produto;

	ELSE
		RAISE NOTICE 'Produto ID: % [NÃO ENCONTRADO]', $1;
		
	END IF;
	RETURN valor_produto;
END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM produto;
SELECT busca_valor_produto(4);

--Função:busca_quantidade_produto
--Linguagem: plpgsql
--Entrada: código do produto INTEGER
--Saída: quantidade NUMERIC ou -1 se não encontrado

CREATE OR REPLACE FUNCTION busca_quantidade_produto(id_produto INTEGER) RETURNS NUMERIC AS
$$
DECLARE 
	quant_produto NUMERIC := -1;
BEGIN
	SELECT quantidade INTO quant_produto
	FROM produto
	WHERE pk_produto = id_produto;

	IF FOUND THEN
		RAISE NOTICE 'Produto ID: % | Quantidade: %', id_produto, quant_produto;
	ELSE
		RAISE NOTICE 'Produto ID: % [NÃO ENCONTRADO]', id_produto;
	END IF;
	
	RETURN quant_produto;
END;
$$
LANGUAGE PLPGSQL;
--
SELECT * FROM produto;
SELECT busca_quantidade_produto(3) AS quantidade_produto;


--Função: baixa_quantidade_produto
--Linguagem: plpgsql
--Entrada: código do produto INTEGER
--Entrada: quantidade para baixar do estoque NUMERIC
--Saída: true se sucesso ou false se nao

CREATE OR REPLACE FUNCTION baixa_quantidade_produto(id_produto INTEGER, sub_qtd_produto NUMERIC)
RETURNS BOOLEAN AS
$$
DECLARE
	qtd_atual NUMERIC := busca_quantidade_produto(id_produto);

BEGIN
	-- IF (sub_qtd_produto < 0) THEN RETURN false;

	-- SELECT quantidade INTO qtd_atual
	-- FROM PRODUTO
	-- WHERE pk_produto = id_produto;

	UPDATE produto
	SET quantidade = qtd_atual - sub_qtd_produto
	WHERE pk_produto = id_produto;

	IF (FOUND) THEN
		RAISE NOTICE 'Produto ID: % | Baixa Estoque: % | Estoque Atual: %', id_produto, sub_qtd_produto, busca_quantidade_produto(id_produto);
		RETURN true;
	END IF;

	RAISE NOTICE 'Produto ID: % [NÃO ENCONTRADO]', id_produto;
	RETURN false;
END;
$$
LANGUAGE PLPGSQL;
--
SELECT * FROM produto;
SELECT baixa_quantidade_produto(20, 50);


---Função: cria_venda
---Linguagem: plpgsql
---Entrada: código do cliente INTEGER
---Saída: código gerado pela venda ou -1 se cliente não encontrado

CREATE OR REPLACE FUNCTION cria_venda(pk_cliente INTEGER) RETURNS INTEGER AS
$$
DECLARE
	id_venda INTEGER := -1;

BEGIN

-- 1. GERAR VENDA
-- 2. GERAR ITEM COM PK_VENDA, PK_CLIENTE
	

END;
$$
LANGUAGE PLPGSQL;

--
SELECT * FROM venda;
SELECT * FROM itens;
cria_venda(1,)

---Função: cadastra_item
---Linguagem: plpgsql
---Entrada: código da venda INTEGER
---Entrada: código do produto INTEGER
---Entrada: quantidade vendida NUMERIC
---Saída: true se sucesso ou falso caso contrário

---Função: compra
---Linguagem: plpgsql
---Entrada: código cliente INTEGER
---Entrada: vetor com código dos produtos ARRAY INTEGER
---Entrada: vetor com a quantidade de produtos vendidos ARRAY NUMERIC
---Saída: total da compra NUMERIC