-- QUESTIONARIO 1

-- 1. Quais são as linhas de código SQL para implementar as tabelas abaixo
--    e suas respectivas ligações de chaves primarias e estrangeiras?

CREATE TABLE cliente (
	cod_cliente SERIAL PRIMARY KEY,
	nome VARCHAR(50),
	credito NUMERIC(8,2)
);

CREATE TABLE produto (
	cod_produto SERIAL PRIMARY KEY,
	nome VARCHAR(50),
	quantidade NUMERIC(8,2),
	valor NUMERIC(8,2)
);

CREATE TABLE venda (
	cod_venda SERIAL PRIMARY KEY,
	fk_cod_cliente INT REFERENCES cliente(cod_cliente),
	fk_cod_produto INT REFERENCES produto(cod_produto),
	quantidade NUMERIC(8,2)
);

INSERT INTO cliente (nome, credito) VALUES
('Ana Silva', 1500.00),
('Bruno Souza', 2500.50),
('Carlos Oliveira', 500.00),
('Diana Costa', 1200.75),
('Eduardo Santos', 3000.00),
('Fernanda Lima', 0.00),
('Gabriel Almeida', 450.20),
('Helena Ribeiro', 8000.00),
('Igor Carvalho', 150.00),
('Juliana Pereira', 3500.00);

INSERT INTO produto (nome, quantidade, valor) VALUES
('Notebook Gamer', 15.00, 4500.00),
('Mouse Sem Fio', 120.00, 89.90),
('Teclado Mecânico', 45.00, 250.00),
('Monitor 24 Polegadas', 20.00, 899.90),
('Headset Bluetooth', 60.00, 180.50),
('Cadeira Ergonômica', 10.00, 1200.00),
('Webcam Full HD', 35.00, 320.00),
('Suporte para Monitor', 80.00, 75.00),
('Cabo HDMI 2m', 200.00, 29.90),
('SSD 1TB NVMe', 50.00, 420.00);


-- 2) Crie uma função “credito” que recebe por parâmetro
--	  a quantidade de credito que o cliente deseja adicionar e o código do cliente.
--	  Posteriormente atualize os dados na tabela.

CREATE OR REPLACE FUNCTION credito(id_cliente INTEGER, qtd_credito NUMERIC)
RETURNS VOID AS
$$
BEGIN

	UPDATE cliente
	SET credito = qtd_credito
	WHERE cod_cliente = id_cliente;

	IF (NOT FOUND) THEN
		RAISE NOTICE 'Cliente não encontrado!';
	END IF;

	RAISE NOTICE 'Credito do cliente atualizado!';

END;
$$
LANGUAGE PLPGSQL;

-- 3) Crie uma função chamada “busca_cliente” que receba por parâmetro
--	  o nome de uma cliente e retorne o código deste,
--	  caso não encontre o cliente a função deve retornar -1.

CREATE OR REPLACE FUNCTION busca_cliente(nome_cliente VARCHAR)
RETURNS INTEGER AS
$$
DECLARE id_cliente INTEGER;

BEGIN
	SELECT cod_cliente INTO id_cliente FROM cliente
	WHERE nome ILIKE '%nome_cliente%';

	IF (NOT FOUND) THEN
		RETURN -1;
	END IF;

	RETURN id_cliente AS cod_cliente;

END;
$$
LANGUAGE PLPGSQL;

-- 4) Crie uma função chamada “venda” que receba por parâmetro
--	  o código do cliente, o código do produto e a quantidade.
--	  Adicione a venda na tabela venda.

CREATE OR REPLACE FUNCTION venda(id_cliente INTEGER, id_produto INTEGER, qtd_produto NUMERIC)
RETURNS VOID AS
$$
BEGIN
	INSERT INTO venda (fk_cod_cliente, fk_cod_produto, quantidade)
	VALUES(id_cliente, id_produto, qtd_produto);
END;
$$
LANGUAGE PLPGSQL;


-- 5) Crie um gatilho para Insert na tabela venda, onde cada novo valor,
-- 	  desconte a quantidade de produto do estoque

-- Cria a função do tipo gatilha
CREATE OR REPLACE FUNCTION atualiza_estoque() RETURNS TRIGGER AS
$$
BEGIN

	UPDATE produto SET quantidade = quantidade - NEW.quantidade WHERE cod_produto = NEW.fk_cod_produto;
	RETURN NEW;

END;
$$
LANGUAGE PLPGSQL;

-- Cria o gatilho que dispara após INSERT em venda pela função atualiza_estoque()
CREATE TRIGGER tg_atualiza_estoque AFTER INSERT ON venda FOR EACH ROW EXECUTE FUNCTION atualiza_estoque();

-- teste
SELECT venda(7,9,1);
SELECT * FROM venda;
SELECT * FROM produto;
SELECT * FROM cliente;
