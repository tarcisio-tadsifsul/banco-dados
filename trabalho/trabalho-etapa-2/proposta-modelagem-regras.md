# PROPOSTA DE MODELAGEM DE DADOS

## DESCRIÇÃO

Este projeto propoe a modelagem de dados para sistema de gerenciamento de cliente e oportunidade auxiliando no atendimento comercial

---

## REGRAS DE NEGÓCIO

### ESTRUTURA _O que o sistema gerencia. (ex: "Temos clientes, produtos e pedidos")_

> Leads: são contatos da empresa capturados (nome, email, telefone) pelo marketing com interesse em nos serviços da empresa;
> Oportunidades: são os leads qualificados com potencial para virar vendas;
> Vendas: quando a oportunidade aceita a proposta comercial, efetua o pagamento ou assina o contrato;
> Produtos: são os ativos que a empresa vende;
> Vendedor: time comercial que atende os leads e realiza a venda.

### CARDINALIDADE _Como eles se relacionam. (ex: "Um cliente pode ter vários cartões, mas o cartão é de um único cliente")._

> Um lead pode ter nenhuma ou várias oportunidade, mas uma oportunidade deve conter um lead;
> Uma oportunidade pode ter zero ou uma venda;
> Um produto pode estar em várias oportunidades_produtos, mas cada oportunidade_produtos contém um único produto.
> Uma venda pode conter zero ou uma oportunidade;
> Uma oportunidade pode se relacionar com várias oportunidades_produtos, mas cada oportunidades_produtos contem uma oportunidade;
> Uma oportunidade_produtos se relaciona com um produto, mas um produto pode se relacionar com várias oportunidades_produtos;
> Um vendedor está ligado a zero ou várias oportunidade, mas cada oportunidade possui um único vendedor;

### VALIDAÇÕES _O que é proibido. (ex: "Um produto não pode ter estoque negativo")_

> Um lead não pode ser duplicado e deve conter email ou telefone únicos;
> Um lead deve conter pelo menos um email ou um telefone;
> Uma oportunidade não pode existir sem um lead;
> Uma venda não pode existir sem uma oportunidade;
> Uma venda realizada não deve ter data de realizada anterior a data de criação;
> Um produto não pode ter valor negativo;

---

## TABELAS

### ENTIDADES

> LEADS

```Bash
+----+-------------------+--------------+---------------+------------+
| id | nome              | email        | telefone      | criado_em  |
+----+-------------------+--------------+---------------+------------+
| 1  | "Ana Silva"       | a@email.com  | 5511988887777 | 2026-06-15 |
| 2  | "Bruno Costa"     | b@email.com  | 5511988887778 | 2026-09-22 |
| 3  | "Carlos Souza"    | c@email.com  | 5511988887779 | 2026-10-15 |
+----+-------------------+--------------+---------------+------------+
```

> OPORTUNIDADES

```Bash
+----+---------+------------+---------------+----------+-------------+-------------+
| id | lead_id | criado_em  | atualizado_em | status   | etapa_funil | vendedor_id |
+----+---------+------------+---------------+----------+-------------+-------------+
| 1  | 1       | 2026-06-15 | 2026-06-15    | ativo    | venda       | 12345       |
| 2  | 2       | 2026-09-15 | 2026-09-16    | ativo    | orcamento   | 67890       |
| 3  | 2       | 2026-10-15 | 2026-10-20    | inativo  | perdido     | 12345       |
+----+---------+------------+---------------+----------+-------------+-------------+
```

> PRODUTOS

```Bash
+----+-------------+--------+------------+---------------+
| id | nome        | preco  | criado_em  | atualizado_em |
+----+-------------+--------+------------+---------------+
| 1  | "Produto1"  | 100.00 | 2026-01-15 | 2026-06-15    |
| 2  | "Produto2"  | 200.00 | 2026-02-16 | 2026-06-15    |
| 3  | "Produto3"  | 300.00 | 2026-13-20 | 2026-06-15    |
+----+-------------+--------+------------+---------------+
```

> VENDAS

```Bash
+----+-----------------+-------------+--------------+
| id | oportunidade_id | forma_pagto | realizada_em |
+----+-----------------+-------------+--------------+
| 1  | 1               | PIX         | 2026-06-15   |
| 2  | 2               | Cartão      | 2026-06-16   |
| 3  | 3               | Boleto      | 2026-06-20   |
+----+-----------------+-------------+--------------+
```

> VENDEDOR

```Bash
+----+-------------+--------------+---------------+------------+------------+---------------+
| id | nome        | email        | telefone      | %_comissao | criado_em  | atualizado_em |
+----+-------------+------------------------+-----+------------+------------+---------------+
| 1  | "Vendedor1" | "a@email.com"  | 5511988887777 | 3.0        | 2026-01-01 | 2026-01-01  |
| 2  | "Vendedor2" | "b@email.com"  | 5511988887778 | 1.8        | 2026-01-01 | 2026-01-01  |
| 3  | "Vendedor3" | "c@email.com"  | 5511988887779 | 2.5        | 2026-01-01 | 2026-01-01  |
+----+-------------+--------------+---------------+------------+------------+---------------+
```

### RELACIONAMENTOS

> OPORTUNIDADE_PRODUTOS

```Bash
+----+-----------------+------------+------------+----------------+------------+
| id | oportunidade_id | produto_id | quantidade | preco_unitario | criado_em  |
+----+-----------------+------------+------------+----------------+------------+
| 1  | 1               | 1111       | 1          | 100.00         | 2026-01-15 |
| 2  | 2               | 2222       | 2          | 200.00         | 2026-01-15 |
| 3  | 3               | 3333       | 3          | 300.00         | 2026-01-15 |
+----+-----------------+------------+------------+----------------+------------+
```

---

## FUNÇÕES

### FUNÇÕES BÁSICAS

### GATILHOS
