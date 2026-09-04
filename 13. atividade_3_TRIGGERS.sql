-- Criação da tabela leitor
CREATE TABLE leitor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20)
);

-- Criação da tabela livro
CREATE TABLE livro (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(100),
    ano_publicacao INT,
    disponivel BOOLEAN DEFAULT TRUE
);

-- Criação da tabela locacao (relacionamento muitos-para-muitos)
CREATE TABLE locacao (
    id SERIAL PRIMARY KEY,
    leitor_id INT NOT NULL,
    livro_id INT NOT NULL,
    data_locacao DATE NOT NULL DEFAULT CURRENT_DATE,
    data_devolucao DATE,
    CONSTRAINT fk_leitor FOREIGN KEY (leitor_id) REFERENCES leitor(id) ON DELETE CASCADE,
    CONSTRAINT fk_livro FOREIGN KEY (livro_id) REFERENCES livro(id) ON DELETE CASCADE,
    CONSTRAINT unq_leitor_livro UNIQUE (leitor_id, livro_id, data_locacao)
);


INSERT INTO leitor (nome, email, telefone) VALUES
('Leitor1', 'Sobrenome1', '11111'),
('Leitor2', 'Sobrenome2', '22222'),
('Leitor3', 'Sobrenome3', '33333'),
('Leitor4', 'Sobrenome4', '44444'),
('Leitor5', 'Sobrenome5', '55555');

INSERT INTO livro (titulo, autor, ano_publicacao, disponivel) VALUES
('Dom Casmurro', 'Machado de Assis', 1899, TRUE),
('1984', 'George Orwell', 1949, TRUE),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 1943, TRUE),
('Capitães da Areia', 'Jorge Amado', 1937, TRUE),
('Harry Potter e a Pedra Filosofal', 'J.K. Rowling', 1997, TRUE),
('A Revolução dos Bichos', 'George Orwell', 1945, TRUE);

INSERT INTO locacao (leitor_id, livro_id, data_locacao, data_devolucao) VALUES
(1, 2, '2025-07-01', '2025-07-10'),
(1, 3, '2025-07-05', NULL);

INSERT INTO locacao (leitor_id, livro_id, data_locacao, data_devolucao) VALUES
(2, 1, '2025-07-03', '2025-07-12');

INSERT INTO locacao (leitor_id, livro_id, data_locacao, data_devolucao) VALUES
(3, 5, '2025-07-07', NULL);

INSERT INTO locacao (leitor_id, livro_id, data_locacao, data_devolucao) VALUES
(4, 4, '2025-07-02', '2025-07-09');

INSERT INTO locacao (leitor_id, livro_id, data_locacao, data_devolucao) VALUES
(5, 6, '2025-07-06', NULL);



-----------------------------------------------------------------------------
-- 1. Crie um gatilho que registre a data e hora da última atualização de um registro na tabela leitor.

-- Cria a coluna que recebera a atualizacao
ALTER TABLE leitor ADD COLUMN atualizacao TIMESTAMP;

-- Cria a função do gatilho
CREATE OR REPLACE FUNCTION registra_update_leitor() RETURNS TRIGGER AS
$$
BEGIN

	-- Dentro do NEW já tem os dados do UPDATE leitor,
	-- por isso a função de gatilho registra_update_leitor pode usar os dados do NEW para já atualizar a tabela leitor
	NEW.atualizacao := NOW();
	RETURN NEW;

END;
$$
LANGUAGE PLPGSQL;

-- Cria gatilho
CREATE OR REPLACE TRIGGER tg_atulizacao_leitor
BEFORE UPDATE ON leitor
FOR EACH ROW EXECUTE FUNCTION registra_update_leitor();

-- Teste
UPDATE leitor SET nome = 'Bruno Costa' WHERE id = 2;
SELECT * FROM leitor;

-----------------------------------------------------------------------------
-- 2. Crie um gatilho que impeça a inserção de um leitor com e-mail duplicado, 
--   mesmo ignorando diferenças entre letras maiúsculas e minúsculas.

-- Cria a função do gatilho
CREATE OR REPLACE FUNCTION verifica_email() RETURNS TRIGGER AS
$$
BEGIN

	IF EXISTS (
		SELECT email FROM leitor WHERE LOWER(email) = LOWER(NEW.email)
	) THEN
		RAISE NOTICE '[ERRO] Email já utilizado!';
		RETURN NULL;
	END IF;
	RETURN NEW;

END;
$$
LANGUAGE PLPGSQL;

-- Cria o gatilho
CREATE OR REPLACE TRIGGER tg_verifica_email
BEFORE INSERT ON leitor
FOR EACH ROW
EXECUTE FUNCTION verifica_email();

-- Teste 1 Não deve passar!
INSERT INTO leitor (nome, email, telefone)
VALUES ('Ana Silva', 'ana.silva@email.com', '11999990001');

-- Teste 2 Passa!
INSERT INTO leitor (nome, email, telefone)
VALUES ('Carla Vaz', 'carla.vaz@email.com', '22939750621');

SELECT * FROM LEITOR

-----------------------------------------------------------------------------
-- 3. Crie um gatilho que defina automaticamente o campo disponivel = FALSE
--    quando um livro for locado.

-- DROP FUNCTION atualiza_disponibilidade;
-- DROP TRIGGER IF EXISTS tg_atualiza_disponibilidade ON LOCACAO;

-- Função do gatilho
CREATE OR REPLACE FUNCTION atualiza_disponibilidade_livro_locado() RETURNS TRIGGER AS
$$
BEGIN

	UPDATE livro SET disponivel = false WHERE livro.id = NEW.livro_id;
	RETURN NEW;

END;
$$
LANGUAGE PLPGSQL;

-- Gatilho
CREATE OR REPLACE TRIGGER tg_atualiza_disponibilidade_livro_locado
AFTER INSERT ON locacao
FOR EACH ROW EXECUTE FUNCTION atualiza_disponibilidade_livro_locado();

-- Teste
INSERT INTO locacao (leitor_id, livro_id, data_locacao, data_devolucao)
VALUES (2, 3, '2025-08-22', '2025-08-29')

-----------------------------------------------------------------------------
-- 4. Crie um gatilho que defina automaticamente o campo disponivel = TRUE
--	  quando a data de devolução de uma locação for preenchida.

-- Função do gatilho
CREATE OR REPLACE FUNCTION atualiza_disponibilidade_livro_devolvido() RETURNS TRIGGER AS
$$
BEGIN

	IF (OLD.data_devolucao IS NULL) AND (NEW.data_devolucao IS NOT NULL) THEN
		UPDATE livro SET disponivel = TRUE WHERE livro.id = NEW.livro_id;
		RETURN NEW;
	END IF;
	
END;
$$
LANGUAGE PLPGSQL;

-- Gatilho
CREATE OR REPLACE TRIGGER tg_atualiza_disponibilidade_livro_devolvido
AFTER UPDATE ON locacao
FOR EACH ROW EXECUTE FUNCTION atualiza_disponibilidade_livro_devolvido();

-- Teste
UPDATE locacao SET data_devolucao = '2025-07-15' WHERE id = 4;


-----------------------------------------------------------------------------
-- 5. Crie um gatilho que insira uma mensagem de log em uma tabela chamada log_locacoes 
--    sempre que uma locação for feita.

-- CRIAR TABELA LOG_LOCACOES
CREATE TABLE log_locacoes (
	id SERIAL PRIMARY KEY,
	data_log DATE NOT NULL DEFAULT CURRENT_DATE,
	mensagem_log VARCHAR(200) NOT NULL
)

-- Função Gatilho
CREATE OR REPLACE FUNCTION insere_log_locacao() RETURNS TRIGGER AS
$$
DECLARE
	msg_log TEXT;

BEGIN
	msg_log :=  'data_locacao: ' || NEW.data_locacao || ' | leitor id: ' || NEW.leitor_id || ' | livro_id: ' || NEW.livro_id;
	INSERT INTO log_locacoes (mensagem_log) VALUES (msg_log);
	-- NÃO TERMINADO!!!!
	
END;
$$
LANGUAGE PLPGSQL;

-- Gatilho
CREATE OR REPLACE TRIGGER tg_insere_log_locacao
AFTER INSERT ON locacao
FOR EACH ROW EXECUTE FUNCTION insere_log_locacao();

-- Teste
INSERT INTO locacao (leitor_id, livro_id, data_locacao, data_devolucao)
VALUES (3, 1, '2025-10-15', NULL);

SELECT * FROM locacao;
SELECT * FROM log_locacoes;


-----------------------------------------------------------------------------
--6-Crie um gatilho que proíba a locação de um livro que já está indisponível (disponivel = FALSE).

-----------------------------------------------------------------------------
--7-Crie um gatilho que envie um aviso (via RAISE NOTICE) ao tentar excluir um leitor 
--que ainda possui livros não devolvidos.

-----------------------------------------------------------------------------
--8-Crie um gatilho que registre a quantidade total de locações feitas por um leitor 
--em uma nova tabela historico_leitor.

-----------------------------------------------------------------------------
--9-Crie um gatilho que atualize a data da última locação de um livro em uma 
--coluna ultima_locacao na tabela livro.

-----------------------------------------------------------------------------
--10-Crie um gatilho que proíba a inserção de locações com data futura.

-----------------------------------------------------------------------------
--11-Crie um gatilho que normalize o nome do leitor para iniciar com letra maiúscula e o 
--restante minúsculo ao ser inserido.

-----------------------------------------------------------------------------
--12-Crie um gatilho que gere automaticamente um número de protocolo na tabela locacao no 
--formato 'LOC-YYYYMMDD-XXXX'.

-----------------------------------------------------------------------------
--13-Crie um gatilho que limite um leitor a no máximo 3 livros locados ao mesmo tempo 
--(sem data de devolução).

-----------------------------------------------------------------------------
--14-Crie um gatilho que mova automaticamente os dados de uma locação devolvida para uma 
--tabela locacoes_finalizadas.

-----------------------------------------------------------------------------
--15-Crie um gatilho que registre qualquer alteração feita no campo email da tabela leitor
--em uma tabela de auditoria auditoria_email.

-----------------------------------------------------------------------------
--16-Crie um gatilho que bloqueie locações de leitores com mais de 5 atrasos registrados
--(pode assumir uma tabela atrasos).

-----------------------------------------------------------------------------
--17-Crie um gatilho que avise (via RAISE EXCEPTION) se um livro for marcado como disponível
--sem que todas as locações anteriores estejam com data de devolução.

-----------------------------------------------------------------------------
--18-Crie um gatilho que calcule automaticamente o número de dias de atraso (se houver)
--após o preenchimento da data de devolução.

-----------------------------------------------------------------------------
--19-Crie um gatilho que proíba a exclusão de livros que já foram locados ao menos uma vez.

-----------------------------------------------------------------------------
--20-Crie um gatilho que atualize um campo qtd_locacoes na tabela livro a cada nova locação feita.