create database ex2
go
use ex2
go

----------TABELAS------------------------------------------------------
create table filme (
id		int			not null,
titulo	varchar(40)	not null,
ano		int			null	check(ano <= 2021),
primary key(id))
go
-----------------------------------------------------------------------
create table estrela(
id		int			not null,
nome	varchar(50)	not null
primary key(id))
go
-----------------------------------------------------------------------
create table cliente(
num_cadastro	int				not null,
nome			varchar(70)		not null,
logradouro		varchar(150)	not null,
num				int				not null	check(num >= 0),
cep				char(8)			null		check(len(cep) = 8)
primary key(num_cadastro))
go
-----------------------------------------------------------------------
create table dvd(
num				int		not null,
data_fabricacao	date	not null	check(data_fabricacao < getdate()),
filmeId			int		not null
primary key(num)
foreign key(filmeId) references filme(id))
go
-----------------------------------------------------------------------
create table filme_estrela(
filmeId			int		not null,
estrelaId		int		not null
primary key(filmeId, estrelaId)
foreign key(filmeId) references filme(id),
foreign key(estrelaId) references estrela(id))
go
-----------------------------------------------------------------------
create table locacao(
dvdNum					int				not null,
clienteNum_cadastro		int				not null,
data_locacao			date			not null	default(getdate()),
data_devolucao			date			not null,
valor					decimal(7,2)	not null	check(valor >= 0)
primary key(dvdNum, clienteNum_cadastro, data_locacao)
foreign key(dvdNum) references dvd(num),
foreign key(clienteNum_cadastro) references cliente(num_cadastro),
constraint chk_sx_alt 
	check (data_devolucao > data_locacao))
go
----------ALTERACOES------------------------------------------------------
alter table estrela
add nome_real	varchar(50) null
go

alter table filme
alter column titulo	varchar(80)	not null
go

----------INSERTS------------------------------------------------------

insert into filme values
(1001, 'Whiplash', 2015),
(1002, 'Birdman', 2015),
(1003, 'Interestelar', 2014),
(1004, 'A Culpa é das estrelas', 2014),
(1005, 'Alexandre e o Dia Terrível, Horrível, Espantoso e Horroroso', 2014),
(1006, 'Sing', 2016)

go
insert into estrela values
(9901, 'Michael Keaton', 'Michael John Douglas'),
(9902, 'Emma Stone', 'Emily Jean Stone')
go
insert into estrela (id, nome) values
(9903, 'Miles Teller')
go
insert into estrela values
(9904, 'Steve Carell', 'Steven John Carell'),
(9905, 'Jennifer Garner', 'Jennifer Anne Garner')

go
insert into filme_estrela values
(1002, 9901),
(1002, 9902),
(1001, 9903),
(1005, 9904),
(1005, 9905)

go
insert into dvd values
(10001, '02/12/2020', 1001),
(10002, '18/10/2019', 1002),
(10003, '03/04/2020', 1003),
(10004, '02/12/2020', 1001),
(10005, '18/10/2019', 1004),
(10006, '03/04/2020', 1002),
(10007, '02/12/2020', 1005),
(10008, '18/10/2019', 1002),
(10009, '03/04/2020', 1003)

go
insert into cliente values
(5501, 'Matilde Luz', 'Rua Síria', 150, '03086040'),
(5502, 'Carlos Carreiro', 'Rua Bartolomeu Aires', 1250, '04419110')
insert into cliente (num_cadastro, nome, logradouro, num) values
(5503, 'Daniel Ramalho', 'Rua Itajutiba', 169),
(5504, 'Roberta Bento', 'Rua Jayme Von Rosenburg', 36)
insert into cliente values
(5505, 'Rosa Cerqueira', 'Rua Arnaldo Simões Pinto', 235, '02917110')

go
insert into locacao values
(10001, 5502, '18/02/2021', '21/02/2021', 3.50),
(10009, 5502, '18/02/2021', '21/02/2021', 3.50),
(10002, 5503, '18/02/2021', '19/02/2021', 3.50),
(10002, 5505, '20/02/2021', '23/02/2021', 3.00),
(10004, 5505, '20/02/2021', '23/02/2021', 3.00),
(10005, 5505, '20/02/2021', '23/02/2021', 3.00),
(10001, 5501, '24/02/2021', '26/02/2021', 3.50),
(10008, 5501, '24/02/2021', '26/02/2021', 3.50)

----------OPERACOES------------------------------------------------------

go
update cliente
set cep = case
	when num_cadastro = 5503
		then
			'08411150'
	when num_cadastro = 5504
		then
			'02918190'
	else
		cep
	end

go
update locacao
set valor = case
	when clienteNum_cadastro = 5502 and data_locacao = '18/02/2021'
		then
			3.25
	when clienteNum_cadastro = 5501 and data_locacao = '24/02/2021'
		then
			3.10
	else	
		valor
	end

go
update dvd
set data_fabricacao = '14/07/2019'
where num = 10005

go
update estrela
set nome_real = 'Miles Alexander Teller'
where nome like('%Teller%')

go
delete filme
where titulo = 'Sing'

----------SELECTS------------------------------------------------------

go
select titulo from filme
where ano = 2014

go
select id, ano from filme
where titulo = 'Birdman'

go
select id, ano from filme
where titulo like('%plash')

go
select * from estrela
where nome like('Steve%')

go
select filmeId, convert(char(10), data_fabricacao, 103) as fab from dvd
where data_fabricacao > '01/01/2020'

go
select dvdNum, data_locacao, data_devolucao, valor, valor + 2.00 as valor_com_multa from locacao
where clienteNum_cadastro = 5505

go
select logradouro, num, cep from cliente
where nome = 'Matilde Luz'

go
select nome_real from estrela
where nome = 'Michael Keaton'

go
select num_cadastro, nome,
	logradouro + ', ' + cast(num as varchar(4))+ ' - ' + cep as end_comp from cliente
where num_cadastro >= 5503
