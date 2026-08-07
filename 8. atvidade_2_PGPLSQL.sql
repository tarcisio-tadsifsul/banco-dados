CREATE TABLE produto (
    id SERIAL PRIMARY KEY, 
    nome VARCHAR(100) NOT NULL,
    preco NUMERIC(10, 2) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    marca VARCHAR(50),
    ativo BOOLEAN DEFAULT TRUE,
    unidade_medida VARCHAR(10)
);

INSERT INTO produto (nome, preco, quantidade_estoque, marca, unidade_medida)
VALUES 
('Caneta Azul', 1.99, 150, 'BIC', 'un');

INSERT INTO produto (nome, preco, quantidade_estoque, marca, unidade_medida)
VALUES 
('Caderno Universitário', 19.90, 80, 'Tilibra', 'un');

INSERT INTO produto (nome, preco, quantidade_estoque, marca, unidade_medida)
VALUES 
('Lápis Preto', 0.89, 500, 'Faber-Castell', 'un');

INSERT INTO produto (nome, preco, quantidade_estoque, marca, unidade_medida)
VALUES 
('Borracha Branca', 1.20, 300, 'Mercur', 'un');

INSERT INTO produto (nome, preco, quantidade_estoque, marca, unidade_medida)
VALUES 
('Mochila Escolar', 149.90, 40, 'Nike', 'un');

INSERT INTO produto (nome, preco, quantidade_estoque, marca, unidade_medida)
VALUES 
('Apontador Duplo', 2.50, 250, 'Tris', 'un');

INSERT INTO produto (nome, preco, quantidade_estoque, marca, unidade_medida)
VALUES 
('Papel Sulfite A4 - 500 folhas', 27.90, 60, 'Chamex', 'pct');

INSERT INTO produto (nome, preco, quantidade_estoque, marca, unidade_medida, ativo)
VALUES 
('Calculadora Científica', 79.90, 10, 'Casio', 'un', FALSE);

INSERT INTO produto (nome, preco, quantidade_estoque, marca, unidade_medida)
VALUES 
('Estojo Escolar', 24.90, 95, 'Tilibra', 'un');

INSERT INTO produto (nome, preco, quantidade_estoque, marca, unidade_medida)
VALUES 
('Cola Branca 90g', 3.80, 180, 'Pritt', 'un');

-----------------------------------------------------------------
-----------------------------------------------------------------

SELECT * FROM produto

--1. Retornar o nome de um produto pelo ID
DROP FUNCTION retorna_produto_id;
CREATE OR REPLACE FUNCTION retorna_produto_id(INTEGER) RETURNS VARCHAR AS
$$
DECLARE
	nome_produto TEXT;
BEGIN
	SELECT nome INTO nome_produto FROM produto WHERE produto.id = $1;
	RETURN nome_produto;
END;
$$
LANGUAGE PLPGSQL;
--
SELECT retorna_produto_id(10) as nome_produto;


--2. Calcular o valor total em estoque de um produto (preço × quantidade)
CREATE OR REPLACE 



--3. Listar todos os produtos ativos (função que retorna conjunto de linhas)

--4. Atualizar o preço de um produto (recebe ID e novo preço)

--5. Ativar ou desativar um produto (passa ID e TRUE/FALSE)

--6. Obter a média de preços de todos os produtos

--7. Retornar o número de produtos com estoque zerado

--8. Adicionar quantidade ao estoque (incremento)

--9. Listar produtos por marca (parâmetro de filtro)

--10. Verificar se um produto está disponível (estoque > 0 e ativo)