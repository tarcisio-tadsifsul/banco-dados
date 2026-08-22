Comando SQL:

Insert de Dados:
INSERT INTO TABELA (COLUNA1, COLUNA2) VALUES ('Produto A', 100);

Delete de Dados:
DELETE FROM TABELA WHERE COLUNA1 = 'Produto A';

Atualização de Dados:
UPDATE TABELA SET COLUNA2 = 150 WHERE COLUNA1 = 'Produto A';

Consulta SQL:
SELECT * FROM TABELA WHERE COLUNA2 > 120;

Estrutura de Função:
    CREATE OR REPLACE FUNCTION nome_da_funcao(parametro TIPO) RETURNS TIPO AS
    $$
    DECLARE
        -- Declaração de variáveis locais, se necessário
    BEGIN
        -- Corpo da função: lógica para processar o parâmetro e retornar um valor
        RETURN (SELECT COLUNA2 FROM TABELA WHERE COLUNA1 = parametro);
    END;
    $$
    LANGUAGE PLPGSQL;
    -- Chamada da Função:
    SELECT nome_da_funcao(args);

Deletar Função:
DROP FUNCTION nome_da_funcao(TIPO);


--

1. Estruturas de Controle (Lógica)

IF ... THEN ... ELSIF ... ELSE ... END IF;
O clássico condicional para tomar decisões.

CASE ... WHEN ... THEN ... ELSE ... END CASE;
Ótimo para múltiplas condições fixas (evita muitos IFs).

LOOP ... END LOOP;
Cria um laço infinito (precisa de um EXIT para parar).

FOR ... IN ... LOOP ... END LOOP;
Usado para percorrer um intervalo de números ou os resultados de uma consulta.

WHILE ... LOOP ... END LOOP;
Repete o bloco enquanto uma condição for verdadeira.


2. Variáveis Especiais de Status

`FOUND`: Uma variável booleana que o PostgreSQL preenche automaticamente. Ela é TRUE se o último comando (INSERT, UPDATE, DELETE ou SELECT INTO) afetou ou retornou alguma linha.

`NOT FOUND`: O inverso do acima; útil para checar se uma busca falhou.


3. Manipulação de Dados e Atribuição

INTO: Usado após um SELECT ou INSERT ... RETURNING para guardar o resultado dentro de uma variável.

PERFORM: Use no lugar de SELECT quando você quer executar uma função, mas não quer o resultado dela (evita aquele erro de "falta destino").

:= ou =: Operadores de atribuição.
Exemplo: minha_var := 10;

RETURNING: Colocado ao final de um INSERT, UPDATE ou DELETE para recuperar valores gerados pelo banco (como IDs automáticos) sem precisar de um novo SELECT.


4. Checagem de Existência e Erros

EXISTS (...): Verifica se uma subconsulta retorna qualquer linha.
Retorna TRUE ou FALSE. Muito rápido para validações.

RAISE: Usado para emitir mensagens ou erros.
RAISE NOTICE: Apenas exibe uma mensagem no console do PGAdmin.
RAISE EXCEPTION: Interrompe a função e cancela toda a transação (faz um rollback).

NULLIF(var1, var2): Retorna nulo se os dois valores forem iguais.
Útil para evitar divisão por zero.
COALESCE(var1, valor_padrao): Retorna o primeiro valor não nulo.
Ótimo para tratar campos vazios.


5. Retorno de Dados

RETURN: Finaliza a função e retorna um valor simples (Integer, Text, etc).
RETURN NEXT: Usado em funções que retornam um conjunto de dados (SETOF) para adicionar uma linha ao resultado final.
RETURN QUERY: Pega o resultado inteiro de um SELECT e o envia como retorno da função.


6. Blocos de Proteção

EXCEPTION: Um bloco opcional ao final da função para capturar erros e decidir o que fazer (ex: registrar o erro em uma tabela de log em vez de travar o sistema).


Dica de Ouro: Sempre que quiser saber se um registro existe sem carregar dados para uma variável, use:IF EXISTS (SELECT 1 FROM tabela WHERE ...) THEN ...


7. IS NULL / IS NOT NULL (O mais usado)
Em SQL, você nunca deve usar `= NULL`, porque NULL representa um valor desconhecido.
Para checar se um campo ou variável está vazio, usamos IS.
Exemplo:
IF minha_variavel IS NULL THEN
    RAISE NOTICE 'A variável está vazia';
END IF;



2. IS TRUE / IS FALSE / IS UNKNOWN
Usado para testar valores booleanos de forma explícita.
- IS TRUE: Verifica se o valor é verdadeiro.
- IS UNKNOWN: No PostgreSQL, isso é equivalente a IS NULL quando falamos de expressões lógicas.


3. IS DISTINCT FROM / IS NOT DISTINCT FROM
Este é um "super comparador". Ele funciona como o símbolo de diferente (!=), mas trata o NULL como um valor comparável.
- valor1 != valor2: Se um deles for NULL, o resultado é "desconhecido".
- valor1 IS DISTINCT FROM valor2: Se um for 10 e o outro for NULL, ele retorna TRUE (pois são de fato distintos). É muito útil para logs de auditoria.


4. ISNULL / NOTNULL (Atalhos)
Embora o padrão SQL seja IS NULL, o PostgreSQL aceita as palavras grudadas como um atalho (ex: WHERE coluna ISNULL), mas a recomendação é usar a forma separada por ser o padrão universal.


5. No cabeçalho da Função (AS $$ ... $$)Embora você já tenha usado no seu código, vale lembrar que o AS (como em RETURNS INTEGER AS $$) define que o corpo da função virá a seguir.
Em algumas variações de SQL (como Oracle), usa-se IS ou AS de forma intercambiável para iniciar o bloco, mas no PostgreSQL o padrão de criação é AS.

6. OF (Type Checking)

Existe também o IS OF (type_name), usado para verificar se um objeto pertence a um tipo específico (menos comum em funções simples, usado mais em tipos customizados/objetos).
Diferença crucial para você não esquecer:
IF x = NULL -> Sempre vai falhar (não retorna erro, mas nunca entra no IF).
IF x IS NULL -> Funciona corretamente para detectar valores vazios.