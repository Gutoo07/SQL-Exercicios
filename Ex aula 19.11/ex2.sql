CREATE DATABASE av2
GO
USE av2
GO
CREATE TABLE fornecedor (
codigo			INT				NOT NULL,
nome			VARCHAR(50)		NOT NULL,
atividade		VARCHAR(80)		NOT NULL,
telefone		CHAR(8)			NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE cliente (
codigo			INT				NOT NULL,
nome			VARCHAR(50)		NOT NULL,
logradouro		VARCHAR(80)		NOT NULL,
numero			INT				NOT NULL,
telefone		CHAR(8)			NOT NULL,
data_nasc		DATE			NOT NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE produto (
codigo			INT				NOT NULL,
nome			VARCHAR(50)		NOT NULL,
valor_unitario	DECIMAL(7,2)	NOT NULL,
qtd_estoque		INT				NOT NULL,
descricao		VARCHAR(80)		NOT NULL,
cod_forn		INT				NOT NULL
PRIMARY KEY(codigo)
FOREIGN KEY(cod_forn) REFERENCES fornecedor(codigo)
)
GO
CREATE TABLE pedido (
codigo			INT			NOT NULL,
cod_cli			INT			NOT NULL,
cod_prod		INT			NOT NULL,
quantidade		INT			NOT NULL,
previsao_ent	DATE		NOT NULL
PRIMARY KEY(codigo, cod_cli, cod_prod, previsao_ent)
FOREIGN KEY(cod_cli) REFERENCES cliente(codigo),
FOREIGN KEY(cod_prod) REFERENCES produto(codigo)
)
GO
INSERT INTO fornecedor VALUES (1001,'Estrela','Brinquedo','41525898')
INSERT INTO fornecedor VALUES (1002,'Lacta','Chocolate','42698596')
INSERT INTO fornecedor VALUES (1003,'Asus','Informática','52014596')
INSERT INTO fornecedor VALUES (1004,'Tramontina','Utensílios Domésticos','50563985')
INSERT INTO fornecedor VALUES (1005,'Grow','Brinquedos','47896325')
INSERT INTO fornecedor VALUES (1006,'Mattel','Bonecos','59865898')
INSERT INTO cliente VALUES (33601,'Maria Clara','R. 1° de Abril',870,'96325874','15/08/2000')
INSERT INTO cliente VALUES (33602,'Alberto Souza','R. XV de Novembro',987,'95873625','02/02/1985')
INSERT INTO cliente VALUES (33603,'Sonia Silva','R. Voluntários da Pátria',1151,'75418596','23/08/1957')
INSERT INTO cliente VALUES (33604,'José Sobrinho','Av. Paulista',250,'85236547','09/12/1986')
INSERT INTO cliente VALUES (33605,'Carlos Camargo','Av. Tiquatira',9652,'75896325','25/03/1971')
INSERT INTO produto VALUES (1,'Banco Imobiliário',65.00,15,'Versão Super Luxo',1001)
INSERT INTO produto VALUES (2,'Puzzle 5000 peças',50.00,5,'Mapas Mundo',1005)
INSERT INTO produto VALUES (3,'Faqueiro',350.00,0,'120 peças',1004)
INSERT INTO produto VALUES (4,'Jogo para churrasco',75.00,3,'7 peças',1004)
INSERT INTO produto VALUES (5,'Tablet',750.00,29,'Tablet',1003)
INSERT INTO produto VALUES (6,'Detetive',49.00,0,'Nova Versão do Jogo',1001)
INSERT INTO produto VALUES (7,'Chocolate com Paçoquinha',6.00,0,'Barra',1002)
INSERT INTO produto VALUES (8,'Galak',5.00,65,'Barra',1002)
INSERT INTO pedido VALUES (99001,33601,1,1,'07/03/2023')
INSERT INTO pedido VALUES (99001,33601,2,1,'07/03/2023')
INSERT INTO pedido VALUES (99001,33601,8,3,'07/03/2023')
INSERT INTO pedido VALUES (99002,33602,2,1,'09/03/2023')
INSERT INTO pedido VALUES (99002,33602,4,3,'09/03/2023')
INSERT INTO pedido VALUES (99003,33605,5,1,'15/03/2023')
GO
SELECT * FROM fornecedor
SELECT * FROM cliente
SELECT * FROM produto
SELECT * FROM pedido

--1. Consultar a quantidade, valor total e valor total com desconto
--(25%) dos itens comprados par Maria Clara.

select pe.quantidade, (pe.quantidade * pr.valor_unitario) as valor_total,
	cast(((pe.quantidade*pr.valor_unitario) * 0.75) as decimal(7,2)) as valor_total_desconto
from pedido pe
inner join produto pr
on pe.cod_prod = pr.codigo
inner join cliente cl
on cl.codigo = pe.cod_cli
where cl.nome = 'Maria Clara'

--2. Consultar quais brinquedos não tem itens em estoque.

select pr.nome as brinquedos_sem_estoque
from produto pr
inner join fornecedor fr
on pr.cod_forn = fr.codigo
where fr.atividade like 'Brinquedo%' and pr.qtd_estoque = 0

--3. Consultar quais nome e descrições de produtos que não estão em pedidos

select pr.codigo, pr.nome, pr.descricao
from produto pr left outer join pedido pe
on pr.codigo = pe.cod_prod
where pe.cod_prod is null

--4. Alterar a quantidade em estoque do faqueiro para 10 peças.

update produto
set qtd_estoque = 10
where nome = 'Faqueiro'

--5. Consultar Quantos clientes tem mais de 40 anos.

select count(cl.data_nasc) as mais_40_anos
from cliente cl
where datediff(year, cl.data_nasc, getdate()) >=40

--6. Consultar Nome e telefone (Formatado XXXX-XXXX) dos fornecedores de Brinquedos e Chocolate.

select fr.nome, substring(fr.telefone, 1, 4)+'-'+substring(fr.telefone, 5, 4) as tel
from fornecedor fr
where fr.atividade like 'Chocolate' or fr.atividade like '%Brinquedo%'

--7. Consultar nome e desconto de 25% no preço dos produtos que custam menos de R$50,00

select pr.nome, cast((pr.valor_unitario * 0.75) as decimal(7,2)) as valor_descontado
from produto pr
where pr.valor_unitario < 50.00

--8. Consultar nome e aumento de 10% no preço dos produtos que custam mais de R$100,00

select pr.nome, cast((pr.valor_unitario * 1.10) as decimal(7,2)) as valor_aumentado
from produto pr
where pr.valor_unitario > 100.00

--9. Consultar desconto de 15% no valor total de cada produto da venda 99001.

select (pr.valor_unitario * pe.quantidade) as valor_total,
	cast(((pr.valor_unitario * pe.quantidade) * 0.85) as decimal(7,2)) as valor_descontado
from produto pr
inner join pedido pe
on pr.codigo = pe.cod_prod
where pe.codigo = 99001

--10. Consultar Código do pedido, nome do cliente e idade atual do cliente

select pe.codigo, cl.nome,
	datediff(year, cl.data_nasc, getdate()) as idade_atual
from pedido pe
inner join cliente cl
on cl.codigo = pe.cod_cli

--11. Consultar o nome do fornecedor do produto mais caro

select fr.nome, pr.valor_unitario
from fornecedor fr
inner join produto pr
on fr.codigo = pr.cod_forn
where pr.valor_unitario in(
	select max(valor_unitario)
	from produto
)

--12. Consultar a média dos valores cujos produtos ainda estão em estoque

select cast(avg(pr.valor_unitario) as decimal(7,2)) as media
from produto pr
where pr.codigo in(
	select pr.codigo
	from produto pr
	where pr.qtd_estoque > 0
)

--13. Consultar o nome do cliente, endereço composto por logradouro e número, 
--o valor unitário do produto, o valor total (Quantidade * valor unitario) da compra
--do cliente de nome Maria Clara

select cl.nome,
	cl.logradouro+', '+cast(cl.numero as varchar(5)) as endereco,
	pr.valor_unitario, pe.quantidade, (pr.valor_unitario * pe.quantidade) as valor_total
from cliente cl
inner join pedido pe
on cl.codigo = pe.cod_cli
inner join produto pr
on pe.cod_prod = pr.codigo
where cl.nome = 'Maria Clara'

--14. Considerando que o pedido de Maria Clara foi entregue 15/03/2023,
--consultar quantos dias houve de atraso. A cláusula do WHERE deve ser o nome da cliente.

select datediff(day, pe.previsao_ent, '15/03/2023') as dias_atraso
from cliente cl
inner join pedido pe
on cl.codigo = pe.cod_cli
where cl.nome = 'Maria Clara'

--15. Consultar qual a nova data de entrega para o pedido de Alberto%
--sabendo que se pediu 9 dias a mais. A cláusula do WHERE deve ser o nome do cliente.
--A data deve ser exibida no formato dd/mm/aaaa.

select pe.previsao_ent, DATEADD(day, 9, pe.previsao_ent) as nova_previsao
from cliente cl
inner join pedido pe
on cl.codigo = pe.cod_cli
where cl.nome like 'Alberto%'