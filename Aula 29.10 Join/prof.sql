USE aulajoin
 
SELECT * FROM alunos
SELECT * FROM materias
SELECT * FROM alunomateria
SELECT * FROM avaliacoes
SELECT * FROM notas
 
/*INNER JOIN - Sintaxe SQL 2
SELECT tab1.col1, tab1.col2, tab2.col1, tab3.col2
FROM tabela1 tab1 
INNER JOIN tabela2 tab2
ON tab1.pk = tab2.fk
INNER JOIN tabela3 tab3
ON tab2.pk = tab3.fk
WHERE condições
*/
/*INNER JOIN - Sintaxe SQL 3
SELECT tab1.col1, tab1.col2, tab2.col1, tab3.col2
FROM tabela1 tab1, tabela2 tab2, tabela3 tab3
WHERE tab1.pk = tab2.fk
	AND tab2.pk = tab3.fk
	AND condições
*/
/*LEFT OUTER JOIN - Sintaxe
SELECT tab1.col1, tab1.col2
FROM tabela1 tab1 LEFT OUTER JOIN tabela2 tab2
ON tab1.PK = tab2.FK
WHERE tab2.FK IS NULL
*/
/*RIGHT OUTER JOIN - Sintaxe
SELECT tab1.col1, tab1.col2
FROM tabela2 tab2 RIGHT OUTER JOIN tabela1 tab1 
ON tab1.PK = tab2.FK
WHERE tab2.FK IS NULL
*/
 
--Criar listas de chamadas (RA tem um (-) antes do último 
--digito), 
--ordenados pelo nome, caso o nome tenha mais de 30 caract.
--mostrar 29 e um ponto(.) no final 
--SQL 2
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
	CASE WHEN (LEN(al.nome) >= 30)
		THEN SUBSTRING(al.nome,1,29)+'.'
		ELSE al.nome
	END AS nome,
	mat.nome AS disciplina
FROM alunos al
INNER JOIN alunomateria am
ON al.ra = am.ra_aluno
INNER JOIN materias mat
ON mat.id = am.id_materia
WHERE mat.nome LIKE 'Banco%'
ORDER BY al.nome ASC
 
--SQL 3
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
	CASE WHEN (LEN(al.nome) >= 30)
		THEN SUBSTRING(al.nome,1,29)+'.'
		ELSE al.nome
	END AS nome,
	mat.nome AS disciplina
FROM alunos al, alunomateria am, materias mat
WHERE al.ra = am.ra_aluno
	AND mat.id = am.id_materia
	AND mat.nome LIKE 'Banco%'
ORDER BY al.nome ASC
 
-- Pegar as notas da turma de Banco de Dados
--SQL 2
 
--SQL 3
SELECT SUBSTRING(al.ra,1,9)+'-'+SUBSTRING(al.ra,10,1) AS ra, 
	CASE WHEN (LEN(al.nome) >= 30)
		THEN SUBSTRING(al.nome,1,29)+'.'
		ELSE al.nome
	END AS nome,
	mat.nome AS disciplina,
	av.tipo, 
	av.peso, 
	nt.nota
FROM alunos al, notas nt, materias mat, avaliacoes av
WHERE al.ra = nt.ra_aluno
	AND mat.id = nt.id_materia
	AND av.id = nt.id_avaliacao
	AND mat.nome LIKE 'Banco%'
 
-- Matérias que não tem notas cadastradas
SELECT mat.nome
FROM materias mat LEFT OUTER JOIN notas nt
ON mat.id = nt.id_materia
WHERE nt.id_materia IS NULL
 
SELECT mat.nome
FROM notas nt RIGHT OUTER JOIN materias mat
ON mat.id = nt.id_materia
WHERE nt.id_materia IS NULL
 
--Exercicios
--Fazer uma consulta que retorne o RA mascarado, 
--o nome do aluno, a nota já com o peso aplicado
--da disciplina Banco de Dados
--Mascara RA (9 digitos - ultimo digito)
 
-- Fazer uma consulta que retorne o RA mascarado e o 
--nome dos alunos que não estão matriculados 
--em nenhuma matéria
 
--Fazer uma consulta que retorne o RA mascarado, 
--o nome dos alunos, o nome da matéria, 
--a nota, o tipo da avaliação, dos alunos que tiraram 
--Notas abaixo da média(6.0) em P1 ou P2, 
--ordenados por matéria e nome do aluno