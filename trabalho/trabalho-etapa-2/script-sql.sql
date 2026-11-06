--=========================--
-- CRIAÇÃO DE TABELAS BASE --
--=========================--

CREATE TABLE leads (
  lead_id SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(40) UNIQUE,
  telefone VARCHAR(15) UNIQUE,
  criado_em DATE DEFAULT CURRENT_DATE,
  atualizado_em DATE NULL
);

CREATE TABLE vendedores(
  vendedor_id SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(40) UNIQUE,
  comissao NUMERIC(8,2),
  criado_em DATE DEFAULT CURRENT_DATE,
  atualizado_em DATE NULL
);

CREATE TABLE oportunidades(
  oportunidade_id SERIAL PRIMARY KEY,
  fk_lead INT REFERENCES leads(lead_id) NOT NULL,
  fk_vendedor INT REFERENCES vendedores(vendedor_id) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'ativo',
  etapa_funil VARCHAR(30) NOT NULL DEFAULT 'novo',
  criado_em DATE DEFAULT CURRENT_DATE,
  atualizado_em DATE NULL
);

CREATE TABLE produtos(
  produto_id SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  preco NUMERIC(8,2),
  criado_em DATE DEFAULT CURRENT_DATE,
  atualizado_em DATE NULL
);

CREATE TABLE oportunidade_produtos(
  op_produto_id SERIAL PRIMARY KEY,
  fk_oportunidade INT REFERENCES oportunidades(oportunidade_id) NOT NULL,
  fk_produto INT REFERENCES produtos(produto_id) NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario NUMERIC(8,2) NOT NULL,
  criado_em DATE DEFAULT CURRENT_DATE
);

CREATE TABLE VENDAS(
  venda_id SERIAL PRIMARY KEY,
  fk_oportunidade INT REFERENCES oportunidades(oportunidade_id) NOT NULL,
  forma_pagto VARCHAR(30),
  realizada_em DATE DEFAULT CURRENT_DATE
);

--====================--
-- INSERÇÕES DE DADOS --
--====================--

-- 1. Inserindo Leads
INSERT INTO leads (nome, email, telefone) VALUES
('Ana Silva', 'ana.silva@email.com', '11999990001'),
('Bruno Costa', 'bruno.costa@email.com', '11999990002'),
('Carlos Dias', 'carlos.dias@email.com', '11999990003'),
('Daniela Rocha', 'daniela.rocha@email.com', '11999990004'),
('Eduardo Lima', 'eduardo.lima@email.com', '11999990005'),
('Fernanda Gomes', 'fernanda.gomes@email.com', '11999990006'),
('Gabriel Souza', 'gabriel.souza@email.com', '11999990007'),
('Helena Martins', 'helena.martins@email.com', '11999990008'),
('Igor Pereira', 'igor.pereira@email.com', '11999990009'),
('Julia Mendes', 'julia.mendes@email.com', '11999990010');

-- 2. Inserindo Vendedores
INSERT INTO vendedores (nome, email, comissao) VALUES
('Marcos Vendas', 'marcos@empresa.com', 5.00),
('Luciana Vendas', 'luciana@empresa.com', 6.50),
('Roberto Vendas', 'roberto@empresa.com', 5.00),
('Carla Vendas', 'carla@empresa.com', 7.00);

-- 3. Inserindo Produtos
INSERT INTO produtos (nome, preco) VALUES
('Sistema CRM PRO', 1500.00),
('Consultoria Financeira', 3200.00),
('Treinamento de Vendas', 850.00),
('Licença Anual ERP', 4500.00),
('Suporte Premium - 1 Mês', 300.00),
('Auditoria de Processos', 5000.00),
('Software de RH', 2100.00),
('Implantação de Sistema', 1200.00),
('Pacote de Marketing Digital', 2800.00),
('Atualização de Servidores', 6000.00);

-- 4. Inserindo Oportunidades
INSERT INTO oportunidades (fk_lead, fk_vendedor, status, etapa_funil) VALUES
(1, 2, 'ganho', 'fechamento'),
(2, 1, 'ativo', 'proposta'),
(3, 3, 'perdido', 'qualificacao'),
(4, 4, 'ativo', 'novo'),
(5, 1, 'ganho', 'fechamento'),
(6, 2, 'ativo', 'proposta'),
(7, 3, 'ativo', 'qualificacao'),
(8, 4, 'ganho', 'fechamento'),
(9, 3, 'perdido', 'proposta'),
(10, 4, 'ganho', 'fechamento');

-- 5. Inserindo Oportunidade_Produtos
INSERT INTO oportunidade_produtos (fk_oportunidade, fk_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 1500.00),
(2, 4, 1, 4500.00),
(3, 3, 5, 850.00),
(4, 7, 1, 2100.00),
(5, 2, 1, 3200.00),
(6, 9, 2, 2800.00),
(7, 5, 3, 300.00),
(8, 6, 1, 5000.00),
(9, 8, 1, 1200.00),
(10, 10, 1, 6000.00);

-- 6. Inserindo Vendas (Apenas para oportunidades ganhas ou ativas avançadas)
INSERT INTO VENDAS (fk_oportunidade, forma_pagto) VALUES
(1, 'Pix'),
(2, 'Boleto 30/60'),
(4, 'Cartão de Crédito'),
(5, 'Transferência Bancária'),
(6, 'Pix'),
(7, 'Boleto 30 dias'),
(8, 'Transferência Bancária'),
(10, 'Pix'),
(1, 'Cartão de Crédito'),
(5, 'Boleto 30 dias');

