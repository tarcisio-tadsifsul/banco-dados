--
-- PostgreSQL database dump
--

\restrict YPLfpP89X18JifXOdfuGLsvuBUgCbDnm4t45nEJrPU6zjxDbdRSeSc4meSpCG51

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.2

-- Started on 2026-07-09 21:57:01

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 228 (class 1255 OID 25101)
-- Name: cancelar_projeto(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cancelar_projeto(p_projeto_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.cancelar_projeto(p_projeto_id integer) OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 25096)
-- Name: controle_cota_fotos(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.controle_cota_fotos(p_projeto_id integer, p_foto character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	id_plano_contratado INTEGER;
	cota_plano_contratado INTEGER;
	qtd_fotos_registradas INTEGER;

BEGIN

	-- RETORNA **ID PLANO** CONTRATADO ATRAVÉS DO ID PROJETO
	SELECT fk_plano_id INTO id_plano_contratado FROM projetos
	WHERE pk_projeto_id = p_projeto_id;

	-- RETORNA **COTA FOTOS PLANO** ATRAVÉS DO ID PLANO
	SELECT qtd_fotos INTO cota_plano_contratado FROM planos
	WHERE fk_plano_id = id_plano_contratado;

	-- RETORNA **CONTAGEM FOTOS** ATRAVÉS DO ID PROJETO
	SELECT COUNT(pk_foto_id) INTO qtd_fotos_registradas FROM fotos
	WHERE fk_projeto_id = p_projeto_id;

	-- VERIFICA COTA
	IF (qtd_fotos_registradas < cota_plano_contratado) THEN
		RETURN insert_fotos(p_projeto_id, p_foto);
		-- insert_fotos retorna true
	ELSE
		RAISE NOTICE '[ERRO] Cota de fotos do Plano atingida!';
		RETURN false;	
	END IF;
	
	
END;
$$;


ALTER FUNCTION public.controle_cota_fotos(p_projeto_id integer, p_foto character varying) OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 25090)
-- Name: insert_cliente(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_cliente(p_nome character varying, p_cpf character varying, p_telefone character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.insert_cliente(p_nome character varying, p_cpf character varying, p_telefone character varying) OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 25089)
-- Name: insert_cliente(character varying, character varying, character varying, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_cliente(p_nome character varying, p_cpf character varying, p_telefone character varying, p_data_cadastro date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN

	IF (p_nome IS NULL OR TRIM(p_nome) = '') THEN
		RAISE NOTICE '[ERRO] Nome do Cliente invalido ou vazio!';
		RETURN false;
	END IF;

	IF (p_cpf IS NULL OR TRIM(p_cpf) = '') THEN
		RAISE NOTICE '[ERRO] CPF invalido ou vazio!';
		RETURN false;
	END IF;
	
	INSERT INTO clientes (nome, cpf, telefone, data_cadastro)
	VALUES (p_nome, p_cpf, p_telefone, p_data_cadastro);
	RETURN true;

END;
$$;


ALTER FUNCTION public.insert_cliente(p_nome character varying, p_cpf character varying, p_telefone character varying, p_data_cadastro date) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 25091)
-- Name: insert_forma_pagto(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_forma_pagto(p_nome character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN

	IF (p_nome IS NULL OR TRIM(p_nome) = '') THEN
		RAISE NOTICE '[ERRO] Nome da Forma Pagto invalido ou vazio!';
		RETURN false;
	END IF; 

	INSERT INTO formas_pagto (nome_forma_pagto) VALUES (p_nome);
	RETURN true;

END;
$$;


ALTER FUNCTION public.insert_forma_pagto(p_nome character varying) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 25092)
-- Name: insert_fotos(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_fotos(p_fk_projeto_id integer, p_foto character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.insert_fotos(p_fk_projeto_id integer, p_foto character varying) OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 25087)
-- Name: insert_novo_plano(character varying, numeric, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_novo_plano(p_nome character varying, p_valor numeric, p_hr_ensaio integer, p_qtd_fotos integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN

	IF (p_valor >= 0 AND p_hr_ensaio >= 0 AND p_qtd_fotos >= 0) THEN
		INSERT INTO planos (nome, valor, horas_ensaio, qtd_fotos)
		VALUES (p_nome, p_valor, p_hr_ensaio, p_qtd_fotos);
		RETURN true;
	END IF;

	RAISE NOTICE '[ERRO] Valor Plano | Horas Ensaio | Qtd Fotos deve ser maior que zero';
	RETURN false;

END;
$$;


ALTER FUNCTION public.insert_novo_plano(p_nome character varying, p_valor numeric, p_hr_ensaio integer, p_qtd_fotos integer) OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 25093)
-- Name: insert_projeto(integer, integer, integer, date, date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_projeto(p_fk_plano_id integer, p_fk_cliente_id integer, p_fk_forma_pagto_id integer, p_data_pagto date, p_data_producao date, p_data_entrega date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.insert_projeto(p_fk_plano_id integer, p_fk_cliente_id integer, p_fk_forma_pagto_id integer, p_data_pagto date, p_data_producao date, p_data_entrega date) OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 25114)
-- Name: relatorio_faturamento_plano(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.relatorio_faturamento_plano() RETURNS TABLE(nome character varying, qtd_projetos integer, faturamento numeric, percentual_total numeric)
    LANGUAGE sql
    AS $$

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
		
$$;


ALTER FUNCTION public.relatorio_faturamento_plano() OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 25100)
-- Name: relatorio_geral_contratos(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.relatorio_geral_contratos() RETURNS TABLE(cliente character varying, plano character varying, valor_contrato numeric, forma_pagto character varying, data_producao date, data_entrega date)
    LANGUAGE sql
    AS $$
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
$$;


ALTER FUNCTION public.relatorio_geral_contratos() OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 25116)
-- Name: relatorio_inadimplencia(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.relatorio_inadimplencia() RETURNS TABLE(cliente character varying, telefone character varying, plano character varying, valor_pagar numeric)
    LANGUAGE sql
    AS $$
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
$$;


ALTER FUNCTION public.relatorio_inadimplencia() OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 25105)
-- Name: relatorio_producoes_agendadas(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.relatorio_producoes_agendadas() RETURNS TABLE(data_producao date, cliente character varying, telefone character varying)
    LANGUAGE sql
    AS $$

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
		
$$;


ALTER FUNCTION public.relatorio_producoes_agendadas() OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 25117)
-- Name: relatorio_progresso_entregas(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.relatorio_progresso_entregas() RETURNS TABLE(cliente character varying, plano character varying, fotos_a_entregar integer, total_fotos_entregues integer, percentual_entregue numeric)
    LANGUAGE sql
    AS $$
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
$$;


ALTER FUNCTION public.relatorio_progresso_entregas() OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 25098)
-- Name: status_projeto(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.status_projeto(p_projeto_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	dias_para_entrega INTEGER;

BEGIN

	-- VERIFICA SE PROJETO EXISTE
	IF NOT EXISTS (SELECT 1 FROM projetos WHERE pk_projeto_id = p_projeto_id) THEN
		RAISE NOTICE '[ERRO] Projeto Não Encontrado!';
		RETURN false;		
	END IF;

	-- VERIFICA SE TEM DATA ENTREGA
	IF EXISTS (
		SELECT 1 FROM projetos 
		WHERE pk_projeto_id = p_projeto_id AND data_entrega = NULL
	) THEN
		RAISE NOTICE '[ERRO] Projeto Sem Data Entrega Definida!';
		RETURN false;		
	END IF;

	SELECT (CURRENT_DATE - data_entrega) INTO dias_para_entrega
	FROM projetos
	WHERE pk_projeto_id = p_projeto_id;

	CASE
		WHEN dias_para_entrega < 0 THEN
			RAISE NOTICE '[ATENCAO] Entrega atrasada a % dias!', ABS(dias_para_entrega);
		WHEN dias_para_entrega <= 5 THEN
			RAISE NOTICE '[ATENCAO] Faltam % dias para entrega!', ABS(dias_para_entrega);
		WHEN dias_para_entrega > 5 THEN
			RAISE NOTICE '[AVISO] Faltam % dias para entrega!', ABS(dias_para_entrega);
	END CASE;

	RETURN true;

END;
$$;


ALTER FUNCTION public.status_projeto(p_projeto_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 25029)
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    pk_cliente_id integer NOT NULL,
    nome character varying(50) NOT NULL,
    cpf character varying(11) NOT NULL,
    telefone character varying(14),
    data_cadastro date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 25028)
-- Name: clientes_pk_cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_pk_cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_pk_cliente_id_seq OWNER TO postgres;

--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 217
-- Name: clientes_pk_cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_pk_cliente_id_seq OWNED BY public.clientes.pk_cliente_id;


--
-- TOC entry 222 (class 1259 OID 25045)
-- Name: formas_pagto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.formas_pagto (
    pk_forma_pagto_id integer NOT NULL,
    nome_forma_pagto character varying(30) NOT NULL
);


ALTER TABLE public.formas_pagto OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 25044)
-- Name: formas_pagto_pk_forma_pagto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.formas_pagto_pk_forma_pagto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.formas_pagto_pk_forma_pagto_id_seq OWNER TO postgres;

--
-- TOC entry 4960 (class 0 OID 0)
-- Dependencies: 221
-- Name: formas_pagto_pk_forma_pagto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.formas_pagto_pk_forma_pagto_id_seq OWNED BY public.formas_pagto.pk_forma_pagto_id;


--
-- TOC entry 226 (class 1259 OID 25074)
-- Name: fotos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fotos (
    pk_foto_id integer NOT NULL,
    fk_projeto_id integer,
    foto_caminho character varying NOT NULL
);


ALTER TABLE public.fotos OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 25073)
-- Name: fotos_pk_foto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fotos_pk_foto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fotos_pk_foto_id_seq OWNER TO postgres;

--
-- TOC entry 4961 (class 0 OID 0)
-- Dependencies: 225
-- Name: fotos_pk_foto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fotos_pk_foto_id_seq OWNED BY public.fotos.pk_foto_id;


--
-- TOC entry 220 (class 1259 OID 25038)
-- Name: planos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.planos (
    pk_plano_id integer NOT NULL,
    nome character varying(50) NOT NULL,
    valor numeric(8,2) NOT NULL,
    horas_ensaio integer NOT NULL,
    qtd_fotos integer NOT NULL
);


ALTER TABLE public.planos OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 25037)
-- Name: planos_pk_plano_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.planos_pk_plano_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.planos_pk_plano_id_seq OWNER TO postgres;

--
-- TOC entry 4962 (class 0 OID 0)
-- Dependencies: 219
-- Name: planos_pk_plano_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.planos_pk_plano_id_seq OWNED BY public.planos.pk_plano_id;


--
-- TOC entry 224 (class 1259 OID 25052)
-- Name: projetos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projetos (
    pk_projeto_id integer NOT NULL,
    fk_cliente_id integer,
    fk_plano_id integer,
    fk_forma_pagto_id integer,
    data_pagto date,
    data_producao date,
    data_entrega date
);


ALTER TABLE public.projetos OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 25051)
-- Name: projetos_pk_projeto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projetos_pk_projeto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projetos_pk_projeto_id_seq OWNER TO postgres;

--
-- TOC entry 4963 (class 0 OID 0)
-- Dependencies: 223
-- Name: projetos_pk_projeto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projetos_pk_projeto_id_seq OWNED BY public.projetos.pk_projeto_id;


--
-- TOC entry 4776 (class 2604 OID 25032)
-- Name: clientes pk_cliente_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN pk_cliente_id SET DEFAULT nextval('public.clientes_pk_cliente_id_seq'::regclass);


--
-- TOC entry 4779 (class 2604 OID 25048)
-- Name: formas_pagto pk_forma_pagto_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formas_pagto ALTER COLUMN pk_forma_pagto_id SET DEFAULT nextval('public.formas_pagto_pk_forma_pagto_id_seq'::regclass);


--
-- TOC entry 4781 (class 2604 OID 25077)
-- Name: fotos pk_foto_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fotos ALTER COLUMN pk_foto_id SET DEFAULT nextval('public.fotos_pk_foto_id_seq'::regclass);


--
-- TOC entry 4778 (class 2604 OID 25041)
-- Name: planos pk_plano_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planos ALTER COLUMN pk_plano_id SET DEFAULT nextval('public.planos_pk_plano_id_seq'::regclass);


--
-- TOC entry 4780 (class 2604 OID 25055)
-- Name: projetos pk_projeto_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projetos ALTER COLUMN pk_projeto_id SET DEFAULT nextval('public.projetos_pk_projeto_id_seq'::regclass);


--
-- TOC entry 4944 (class 0 OID 25029)
-- Dependencies: 218
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (1, 'Cliente Teste', '11122233344', '11988887777', '2026-06-29');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (2, 'Ana Silva', '12345678901', '11987654321', '2026-03-27');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (3, 'Bruno Santos', '23456789012', '21976543210', '2025-08-09');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (4, 'Carlos Oliveira', '34567890123', '31965432109', '2025-08-03');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (5, 'Daniela Souzalat', '45678901234', '4195432-1098', '2026-03-13');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (6, 'Eduardo Pereira', '56789012345', '5194321-0987', '2026-03-30');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (7, 'Fernanda Costa', '67890123456', '6193210-9876', '2025-08-21');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (8, 'Gabriel Rodrigues', '78901234567', '7192109-8765', '2025-09-19');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (9, 'Helena Martins', '89012345678', '8191098-7654', '2025-11-10');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (10, 'Igor Carvalho', '90123456789', '8590987-6543', '2026-06-03');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (11, 'Julia Almeida', '01234567890', '9899876-5432', '2026-03-14');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (12, 'Lucas Ferreira', '11223344556', '1998876-1122', '2026-01-16');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (13, 'Mariana Ribeiro', '22334455667', '1697765-2233', '2025-07-11');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (14, 'Nicolas Gomes', '33445566778', '4796654-3344', '2025-10-24');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (15, 'Olivia Pinto', '44556677889', '8495543-4455', '2025-12-01');
INSERT INTO public.clientes (pk_cliente_id, nome, cpf, telefone, data_cadastro) VALUES (16, 'Pedro Rocha', '55667788990', '6294432-5566', '2026-03-01');


--
-- TOC entry 4948 (class 0 OID 25045)
-- Dependencies: 222
-- Data for Name: formas_pagto; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.formas_pagto (pk_forma_pagto_id, nome_forma_pagto) VALUES (1, 'PIX');
INSERT INTO public.formas_pagto (pk_forma_pagto_id, nome_forma_pagto) VALUES (2, 'Cartão de Crédito');
INSERT INTO public.formas_pagto (pk_forma_pagto_id, nome_forma_pagto) VALUES (3, 'Cartão de Débito');
INSERT INTO public.formas_pagto (pk_forma_pagto_id, nome_forma_pagto) VALUES (4, 'Dinheiro');


--
-- TOC entry 4952 (class 0 OID 25074)
-- Dependencies: 226
-- Data for Name: fotos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (1, 1, '/imagens/proj_1/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (2, 1, '/imagens/proj_1/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (3, 1, '/imagens/proj_1/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (4, 2, '/imagens/proj_2/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (5, 2, '/imagens/proj_2/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (6, 2, '/imagens/proj_2/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (7, 2, '/imagens/proj_2/foto_04.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (8, 2, '/imagens/proj_2/foto_05.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (9, 2, '/imagens/proj_2/foto_06.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (10, 2, '/imagens/proj_2/foto_07.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (11, 2, '/imagens/proj_2/foto_08.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (12, 2, '/imagens/proj_2/foto_09.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (13, 2, '/imagens/proj_2/foto_10.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (14, 3, '/imagens/proj_3/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (15, 3, '/imagens/proj_3/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (16, 3, '/imagens/proj_3/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (17, 3, '/imagens/proj_3/foto_04.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (18, 4, '/imagens/proj_4/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (19, 4, '/imagens/proj_4/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (20, 4, '/imagens/proj_4/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (21, 5, '/imagens/proj_5/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (22, 5, '/imagens/proj_5/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (23, 5, '/imagens/proj_5/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (24, 5, '/imagens/proj_5/foto_04.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (25, 5, '/imagens/proj_5/foto_05.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (26, 6, '/imagens/proj_6/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (27, 6, '/imagens/proj_6/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (28, 6, '/imagens/proj_6/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (29, 6, '/imagens/proj_6/foto_04.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (30, 6, '/imagens/proj_6/foto_05.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (31, 6, '/imagens/proj_6/foto_06.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (32, 6, '/imagens/proj_6/foto_07.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (33, 6, '/imagens/proj_6/foto_08.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (34, 6, '/imagens/proj_6/foto_09.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (35, 6, '/imagens/proj_6/foto_10.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (36, 7, '/imagens/proj_7/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (37, 7, '/imagens/proj_7/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (38, 7, '/imagens/proj_7/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (39, 8, '/imagens/proj_8/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (40, 8, '/imagens/proj_8/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (41, 8, '/imagens/proj_8/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (42, 8, '/imagens/proj_8/foto_04.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (43, 9, '/imagens/proj_9/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (44, 9, '/imagens/proj_9/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (45, 9, '/imagens/proj_9/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (46, 10, '/imagens/proj_10/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (47, 10, '/imagens/proj_10/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (48, 10, '/imagens/proj_10/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (49, 10, '/imagens/proj_10/foto_04.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (50, 11, '/imagens/proj_11/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (51, 11, '/imagens/proj_11/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (52, 11, '/imagens/proj_11/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (53, 11, '/imagens/proj_11/foto_04.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (54, 11, '/imagens/proj_11/foto_05.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (55, 11, '/imagens/proj_11/foto_06.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (56, 11, '/imagens/proj_11/foto_07.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (57, 11, '/imagens/proj_11/foto_08.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (58, 11, '/imagens/proj_11/foto_09.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (59, 11, '/imagens/proj_11/foto_10.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (60, 12, '/imagens/proj_12/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (61, 12, '/imagens/proj_12/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (62, 12, '/imagens/proj_12/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (63, 12, '/imagens/proj_12/foto_04.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (64, 13, '/imagens/proj_13/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (65, 13, '/imagens/proj_13/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (66, 13, '/imagens/proj_13/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (67, 14, '/imagens/proj_14/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (68, 14, '/imagens/proj_14/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (69, 14, '/imagens/proj_14/foto_03.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (70, 14, '/imagens/proj_14/foto_04.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (71, 15, '/imagens/proj_15/foto_01.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (72, 15, '/imagens/proj_15/foto_02.jpg');
INSERT INTO public.fotos (pk_foto_id, fk_projeto_id, foto_caminho) VALUES (73, 15, '/imagens/proj_15/foto_03.jpg');


--
-- TOC entry 4946 (class 0 OID 25038)
-- Dependencies: 220
-- Data for Name: planos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.planos (pk_plano_id, nome, valor, horas_ensaio, qtd_fotos) VALUES (1, 'Plano Couvert', 200.00, 1, 10);
INSERT INTO public.planos (pk_plano_id, nome, valor, horas_ensaio, qtd_fotos) VALUES (2, 'Plano À La Carte', 350.00, 2, 20);
INSERT INTO public.planos (pk_plano_id, nome, valor, horas_ensaio, qtd_fotos) VALUES (3, 'Plano Menu Degustação', 550.00, 3, 40);
INSERT INTO public.planos (pk_plano_id, nome, valor, horas_ensaio, qtd_fotos) VALUES (4, 'Plano Prato Principal', 800.00, 4, 60);
INSERT INTO public.planos (pk_plano_id, nome, valor, horas_ensaio, qtd_fotos) VALUES (5, 'Plano Chef’s Table', 1500.00, 6, 120);


--
-- TOC entry 4950 (class 0 OID 25052)
-- Dependencies: 224
-- Data for Name: projetos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (1, 1, 3, 1, '2026-01-10', '2026-01-15', '2026-01-25');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (2, 2, 1, 2, '2026-01-22', '2026-01-24', '2026-02-02');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (3, 3, 4, 1, '2026-02-05', '2026-02-12', '2026-02-28');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (4, 4, 2, 3, '2026-02-18', '2026-02-20', '2026-03-01');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (5, 5, 5, 2, '2026-03-03', '2026-03-10', '2026-03-25');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (6, 6, 1, 1, '2026-03-15', '2026-03-17', '2026-03-24');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (7, 7, 3, 2, '2026-04-01', '2026-04-06', '2026-04-18');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (8, 8, 2, 1, '2026-04-12', '2026-04-15', '2026-04-22');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (9, 9, 4, 3, '2026-05-02', '2026-05-09', '2026-05-26');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (10, 10, 5, 2, '2026-05-20', '2026-05-28', '2026-06-15');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (11, 11, 1, 1, '2026-06-01', '2026-06-03', '2026-06-10');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (12, 12, 3, 3, '2026-06-14', '2026-06-20', '2026-07-02');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (13, 13, 2, 2, '2026-06-25', '2026-06-28', NULL);
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (14, 14, 4, 1, '2026-07-01', '2026-07-07', NULL);
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (15, 15, 5, 2, '2026-07-05', NULL, NULL);
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (21, 1, 1, 1, '2026-07-09', '2026-07-27', '2026-09-05');
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (22, 2, 2, 2, NULL, NULL, NULL);
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (23, 3, 3, 3, NULL, NULL, NULL);
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (24, 4, 4, 3, NULL, NULL, NULL);
INSERT INTO public.projetos (pk_projeto_id, fk_cliente_id, fk_plano_id, fk_forma_pagto_id, data_pagto, data_producao, data_entrega) VALUES (25, 5, 5, 1, NULL, NULL, NULL);


--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 217
-- Name: clientes_pk_cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_pk_cliente_id_seq', 16, true);


--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 221
-- Name: formas_pagto_pk_forma_pagto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.formas_pagto_pk_forma_pagto_id_seq', 4, true);


--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 225
-- Name: fotos_pk_foto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fotos_pk_foto_id_seq', 73, true);


--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 219
-- Name: planos_pk_plano_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.planos_pk_plano_id_seq', 5, true);


--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 223
-- Name: projetos_pk_projeto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.projetos_pk_projeto_id_seq', 25, true);


--
-- TOC entry 4783 (class 2606 OID 25036)
-- Name: clientes clientes_cpf_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_cpf_key UNIQUE (cpf);


--
-- TOC entry 4785 (class 2606 OID 25034)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (pk_cliente_id);


--
-- TOC entry 4789 (class 2606 OID 25050)
-- Name: formas_pagto formas_pagto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.formas_pagto
    ADD CONSTRAINT formas_pagto_pkey PRIMARY KEY (pk_forma_pagto_id);


--
-- TOC entry 4793 (class 2606 OID 25081)
-- Name: fotos fotos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fotos
    ADD CONSTRAINT fotos_pkey PRIMARY KEY (pk_foto_id);


--
-- TOC entry 4787 (class 2606 OID 25043)
-- Name: planos planos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planos
    ADD CONSTRAINT planos_pkey PRIMARY KEY (pk_plano_id);


--
-- TOC entry 4791 (class 2606 OID 25057)
-- Name: projetos projetos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projetos
    ADD CONSTRAINT projetos_pkey PRIMARY KEY (pk_projeto_id);


--
-- TOC entry 4797 (class 2606 OID 25082)
-- Name: fotos fotos_fk_projeto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fotos
    ADD CONSTRAINT fotos_fk_projeto_id_fkey FOREIGN KEY (fk_projeto_id) REFERENCES public.projetos(pk_projeto_id);


--
-- TOC entry 4794 (class 2606 OID 25058)
-- Name: projetos projetos_fk_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projetos
    ADD CONSTRAINT projetos_fk_cliente_id_fkey FOREIGN KEY (fk_cliente_id) REFERENCES public.clientes(pk_cliente_id);


--
-- TOC entry 4795 (class 2606 OID 25068)
-- Name: projetos projetos_fk_forma_pagto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projetos
    ADD CONSTRAINT projetos_fk_forma_pagto_id_fkey FOREIGN KEY (fk_forma_pagto_id) REFERENCES public.formas_pagto(pk_forma_pagto_id);


--
-- TOC entry 4796 (class 2606 OID 25063)
-- Name: projetos projetos_fk_plano_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projetos
    ADD CONSTRAINT projetos_fk_plano_id_fkey FOREIGN KEY (fk_plano_id) REFERENCES public.planos(pk_plano_id);


-- Completed on 2026-07-09 21:57:01

--
-- PostgreSQL database dump complete
--

\unrestrict YPLfpP89X18JifXOdfuGLsvuBUgCbDnm4t45nEJrPU6zjxDbdRSeSc4meSpCG51

