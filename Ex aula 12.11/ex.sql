CREATE DATABASE ex9
GO
USE ex9
GO
CREATE TABLE editora (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
site			VARCHAR(40)		NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE autor (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
biografia		VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE estoque (
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL	UNIQUE,
quantidade		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0.00),
codEditora		INT				NOT NULL,
codAutor		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO
CREATE TABLE compra (
codigo			INT				NOT NULL,
codEstoque		INT				NOT NULL,
qtdComprada		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL,
dataCompra		DATE			NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civilização Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Marilia Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matematica da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Linguistica Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ciencias da Computacão pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Política',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de Fisica I',26,68.00,4,104),
(10005,'Geometria Analitica',1,95.00,3,105),
(10006,'Gramática Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de Fisica III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103)
GO
INSERT INTO compra VALUES
(15051,10003,2,158.00,'04/07/2021'),
(15051,10008,1,95.00,'04/07/2021'),
(15051,10004,1,68.00,'04/07/2021'),
(15051,10007,1,78.00,'04/07/2021'),
(15052,10006,1,49.00,'05/07/2021'),
(15052,10002,3,165.00,'05/07/2021'),
(15053,10001,1,108.00,'05/07/2021'),
(15054,10003,1,79.00,'06/08/2021'),
(15054,10008,1,95.00,'06/08/2021')

--//////////////////////////////////////////////////////////////////////////////////////

--Pede-se:	
--1) Consultar nome, valor unitário, nome da editora e nome do autor dos livros 
--do estoque que foram vendidos. Não podem haver repetições.

select distinct est.nome, est.valor, ed.nome, au.nome
from estoque est
inner join autor au
on est.codAutor = au.codigo
inner join editora ed
on est.codEditora = ed.codigo
inner join compra c
on est.codigo = c.codEstoque

--2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051

select est.nome, c.qtdComprada, c.valor
from estoque est
inner join compra c
on est.codigo = c.codEstoque
where c.codigo = 15051

--3) Consultar Nome do livro e site da editora dos livros da Makron books
--(Caso o site tenha mais de 10 dígitos, remover o www.).	

select est.nome,
case 
	when len(edi.site) > 10
		then substring(edi.site, 5, 40) 
	end as site
from estoque est
inner join editora edi
on est.codEditora = edi.codigo
where edi.nome = 'Makron books'

--4) Consultar nome do livro e Breve Biografia do David Halliday	

select est.nome, au.biografia
from estoque est
inner join autor au
on est.codAutor = au.codigo
where au.nome = 'David Halliday'

--5) Consultar código de compra e quantidade 
--comprada do livro Sistemas Operacionais Modernos	

select c.codigo, c.qtdComprada
from compra c
inner join estoque est
on c.codEstoque = est.codigo
where est.nome like 'Sistemas Op%'

--6) Consultar quais livros não foram vendidos	

select est.nome
from estoque est
left outer join compra c
on est.codigo = c.codEstoque
where c.codEstoque is null

--7) Consultar quais livros foram vendidos e não estão cadastrados. 
--Caso o nome dos livros terminem com espaço, fazer o trim apropriado.	

select c.codEstoque, rtrim(est.nome) as nome
from compra c
left outer join estoque est
on c.codEstoque = est.codigo
where est.codigo is null

--Resposta: a relacao PK-FK esta bem feita, e por isso nao permite Compras
--que nao possuam objetos Estoque associados. Por isso nao possui saida.

--8) Consultar Nome e site da editora que não tem Livros no estoque 
--(Caso o site tenha mais de 10 dígitos, remover o www.)

select edi.nome, edi.site
from editora edi
left outer join estoque est
on edi.codigo = est.codEditora
where est.codEditora is null

--9) Consultar Nome e biografia do autor que não tem Livros no estoque
--(Caso a biografia inicie com Doutorado, substituir por Ph.D.)	

select au.nome, au.biografia
from autor au
left outer join estoque est
on au.codigo = est.codAutor
where est.codAutor is null

--10) Consultar o nome do Autor, e o maior valor de Livro no estoque. 
--Ordenar por valor descendente

select au.nome, est.valor
from autor au
inner join estoque est
on au.codigo = est.codAutor
where est.valor in (
	select max(est.valor)
	from estoque est
	group by est.codAutor
)
order by est.valor desc

--select est.valor , au.nome
--from estoque est
--inner join autor au
--on est.codAutor = au.codigo

--select * from autor

--11) Consultar o código da compra, o total de livros comprados e a soma dos valores gastos. 
--Ordenar por Código da Compra ascendente.	

select /*c.codigo,*/
	sum(c.qtdComprada) as total_livros_comprados,
	sum(c.valor) as total_valor
from compra c
group by c.codigo
order by c.codigo asc

--12) Consultar o nome da editora e a média de preços dos livros em estoque.
--Ordenar pela Média de Valores ascendente.	

select edi.nome, 
	cast(avg(est.valor) as decimal(7,2)) as media_valor_em_estoque
from editora edi
inner join estoque est
on edi.codigo = est.codEditora
group by edi.nome
order by media_valor_em_estoque

--13) Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora
--(Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna status onde:	
	--Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
	--Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
	--Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
	--A Ordenação deve ser por Quantidade ascendente

select est.nome, est.quantidade, edi.nome as nome_editora,
	case when len(edi.site) > 10
		then substring(edi.site, 5, 40)
	end as site,
	case
		when est.quantidade < 5
			then 'Produto em Ponto de Pedido'
		when est.quantidade > 5 and est.quantidade <= 10
			then 'Produto Acabando'
		when est.quantidade > 10
			then 'Estoque Suficiente'
		end as status
from estoque est
inner join editora edi
on est.codEditora = edi.codigo
order by est.quantidade asc

--select * from estoque
--order by quantidade

--14) Para montar um relatório, é necessário montar uma consulta com a seguinte saída: 
--Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros	
	--Só pode concatenar sites que não são nulos

select est.codigo as codigo_livro, est.nome as nome_livro, au.nome as nome_autor,
	case 
		when edi.site is null
			then 
				edi.nome
			else
				edi.nome+' : '+edi.site
	end as Info_Editora
from estoque est
inner join editora edi
on est.codEditora = edi.codigo
inner join autor au
on est.codAutor = au.codigo
group by est.codigo, est.nome, au.nome, edi.nome, edi.site

--15) Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje	

select c.codigo as codigo_compra, datediff(day, c.dataCompra, getdate()) as dias_atras,
	datediff(month, c.dataCompra, getdate()) as meses_atras
from compra c

--16) Consultar o código da compra e a soma dos valores
--gastos das compras que somam mais de 200.00	

select c.codigo as codigo_compra,
	case
		when sum(c.valor) > 200
			then
				sum(c.valor)
		end as valor_total_compra
from compra c
group by c.codigo
having sum(c.valor) > 200
