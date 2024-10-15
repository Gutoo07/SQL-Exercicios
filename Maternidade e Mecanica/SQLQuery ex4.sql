CREATE DATABASE ex4
GO
USE ex4
--================================================
create table cliente (
id			int				not null		identity(3401, 15),
nome		varchar(100)	not null,
logradouro	varchar(200)	not null,
numero		int				not null		check(numero >= 0),
cep			char(8)			not null		check(len(cep) = 8),
complemento	varchar(255)	not null
primary key(id)
)
GO
create table telefone_cliente (
clienteId	int				not null,
telefone	varchar(11)		check(len(telefone) = 10 or len(telefone) = 11)
primary key(clienteId, telefone)
foreign key (clienteId) references cliente(id)
)
GO
create table veiculo (
placa		char(7)			not null	check(len(placa) = 7),
marca		varchar(30)		not null,
modelo		varchar(39)		not null,
cor			varchar(15)		not null,
ano_fabricacao	int			not null	check(ano_fabricacao > 1997),
ano_modelo		int			not null	check(ano_modelo > 1997),
data_aquisicao	date		not null,
clienteId		int			not null
primary key(placa)
foreign key(clienteId) references cliente(id),
CONSTRAINT chk_sx_alt 
	CHECK((ano_modelo > 1997 AND ano_modelo >= ano_fabricacao))
)
create table peca (
id			int				not null	identity(3411, 7),
nome		varchar(30)		not null	unique,
preco		decimal(4,2)	not null	check(preco >= 0),
estoque		int				not null	check(estoque >= 10)
primary key(id)
)
create table categoria (
id			int				not null	identity(1, 1),
categoria	varchar(10)		not null
	check(categoria = 'estagiário' or categoria = 'Nível 1' or categoria = 'Nível 2' or categoria = 'Nível 3'),
valor_hora	decimal(4,2)	not null	check(valor_hora >= 0)
primary key(id),
CONSTRAINT chk_sx_alt2 
	CHECK((categoria = 'estagiário' and valor_hora > 15) or (categoria = 'Nível 1' and valor_hora > 25)
	or (categoria = 'Nível 2' and valor_hora > 35) or (categoria = 'Nível 3' and valor_hora > 50))
)
create table funcionario(
id						int				not null	identity(101, 1),
nome					varchar(100)	not null,
logradouro				varchar(200)	not null,
numero					int				not null	check(numero >= 0),
telefone				char(11)		not null	check(len(telefone) = 10 or len(telefone) = 11),
categoria_habilitacao	int				not null
	check(categoria_habilitacao = 'A' or categoria_habilitacao = 'B' or categoria_habilitacao = 'C' or categoria_habilitacao = 'D'),
categoriaId				int				not null
primary key(id),
foreign key(categoriaId) references categoria(id)
)
create table reparo (
veiculoPlaca		char(7)			not null,
funcionarioId		int				not null,
pecaId				int				not null,
data_reparo			date			not null	default(GETDATE()),
custo_total			decimal(4,2)	not null	check(custo_total >= 0),
tempo				int				not null	check(tempo >= 0)
primary key (veiculoPlaca, funcionarioId, pecaId, data_reparo),
foreign key(veiculoPlaca) references veiculo(placa),
foreign key(funcionarioId) references funcionario(id),
foreign key(pecaId) references peca(id)
)
