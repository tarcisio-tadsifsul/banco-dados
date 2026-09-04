-- 1. Crie um banco de dados com nome “escola”.

-- 2. Cria as seguintes tabelas conforme modelo ER abaixo:
-- (VER MODELO ER NO arquivo db2_questionario2.pdf)

-- 3. Crie uma função triggerpara cada insertda tabela aluno, adicionar uma linha referente na tabela nota.

-- 4. Crie uma função triggerpara cada updatena tabela nota, recalcular o valor do campo media.

-- 5. Crie uma função para zerar os dados dos campos nota1, nota2 de todos os alunos.

-- 6. Crie uma tabela com o nome histórico, com os campos (nome, nota1, nota2, media, ano. . Obs: esta tabela deve ter seu próprio código.

-- 7. Criar uma função triggerpara cada deleteda tabela aluno, para adicionar uma cópia dos dados das tabelas (aluno+nota.  na tabela histórico.

-- 8. Crie uma função para recadastrar todos os alunos excluídos da tabela histórico, com suas antigas notas. Obs:Após recadastro o aluno deve ser excluído da tabela histórico.