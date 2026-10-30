# PROPOSTA DE MODELAGEM DE DADOS

## DESCRIÇÃO
Este projeto propoe a modelagem de dados para sistema de gerenciamento de cliente e oportunidade auxiliando no atendimento comercial

---
## REGRAS DE NEGÓCIO

### ESTRUTURA _(O que o sistema gerencia. (ex: "Temos clientes, produtos e pedidos"))_

> Leads: são contatos da empresa capturados (nome, email, telefone) pelo marketing com interesse em nos serviços da empresa;
> Oportunidades: são os leads qualificados com potencial para virar vendas;
> Vendas: quando a oportunidade aceita a proposta comercial, efetua o pagamento ou assina o contrato;
> Produtos: são os ativos que a empresa vende;

### CARDINALIDADE _Como eles se relacionam. (ex: "Um cliente pode ter vários cartões, mas o cartão é de um único cliente")._

> Um lead pode ter várias oportunidade, mas uma oportunidade contem um único lead;
> Um lead pode fazer várias vendas, mas uma venda é realizada para um único lead;
> Uma oportunidade se relaciona com uma venda e uma venda está em uma oportunidade;
> Uma venda contem um produto e um produto está relacionado a uma venda;


### VALIDAÇÕES _O que é proibido. (ex: "Um produto não pode ter estoque negativo").

> Um lead não pode ser duplicado e deve conter email ou telefone únicos;
> Um lead deve conter pelo menos um email ou um telefone;
> Uma oportunidade não pode existir sem um lead;
> Uma venda não pode existir sem uma oportunidade;
> Uma venda deve conter um produto;
> Um produto não pode ter valor negativo;

---
## TABELAS

### ENTIDADES

**LEADS**
+----+-------------------+--------------+---------------+------------+
| id | nome              | email        | telefone      | criado_em  |
+----+-------------------+------------------------+-----+------------+
| 1  | Ana Silva         | a@email.com  | 5511988887777 | 2026-06-15 |
| 2  | Bruno Costa       | b@email.com  | 5511988887778 | 2026-09-22 |
| 3  | Carlos Souza      | c@email.com  | 5511988887779 | 2026-10-15 |
+----+-------------------+--------------+----------+-----------------+

**OPORTUNIDADES**
+----+---------+------------+-----------------------+----------+-------------+------------+
| id | lead_id | criado_em  | data_primeiro_contato | status   | etapa_funil | produto_id |
+----+---------+------------+-----------------------+----------+-------------+------------+
| 1  | 1       | 2026-06-15 | 2026-06-15            | ativo    | venda       | 1111       |
| 2  | 2       | 2026-09-15 | 2026-09-16            | ativo    | orcamento   | 2222       |
| 3  | 2       | 2026-10-15 | 2026-10-20            | inativo  | perdido     | 3333       |
+----+---------+------------+-----------------------+--------+----------------------------+


### RELACIONAMENTOS




---
## FUNÇÕES

### FUNÇÕES BÁSICAS

### GATILHOS