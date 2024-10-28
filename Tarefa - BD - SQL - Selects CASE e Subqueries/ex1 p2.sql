use master
drop database ex1

GO
CREATE DATABASE ex1
GO
USE ex1
GO
--TABELAS--------------------------------------------------------------------------------
CREATE table projects(
id 				int  			not null 	identity(10001, 1),
nome			varchar(45)		not null,
descricao		varchar(45)		not null,
data_projeto	date		not null		check(data_projeto > '01/09/2014'),
PRIMARY KEY (id))
GO
----------------------------------------------------------------------------------------- 
CREATE table users(
id				int				not null	identity,
nome			varchar(45)		not null,
username		varchar(45)		not null	unique,
senha			varchar(45)		not null	default('123mudar'),
email			varchar(45)		not null,
PRIMARY KEY(id))
GO
--alter table users
--alter column username	varchar(10)	not null

--*pelo que entendi nao consigo mudar a coluna username pois esta definida com UNIQUE
--*testei sem UNIQUE e assim deu pra fazer ALTER COLUMN
--*sendo assim, imagino que teria que dar DROP TABLE e refazer USERS por completo
drop table users
GO

CREATE table users(
id				int				not null	identity,
nome			varchar(45)		not null,
username		varchar(10)		not null	unique,
senha			varchar(45)		not null	default('123mudar'),
email			varchar(45)		not null,
PRIMARY KEY(id))
GO
alter table users
alter column senha varchar(8)	not null
GO	
----------------------------------------------------------------------------------------- 
CREATE TABLE users_has_projects(
users_id		int		not null,
projects_id		int		not null
PRIMARY KEY(users_id, projects_id)
FOREIGN KEY(users_id) REFERENCES users(id),
FOREIGN KEY(projects_id) REFERENCES projects(id)
)
GO
--INSERTS------------------------------------------------------------------------------------------------------------------------

INSERT INTO users (nome, username, email) VALUES
('Maria', 'Rh_maria', 'maria@empresa.com')
INSERT INTO users (nome, username, senha, email) VALUES
('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com')
INSERT INTO users (nome, username, email) VALUES
('Ana', 'Rh_ana', 'ana@empresa.com'),
('Clara', 'Ti_clara', 'clara@empresa.com')
INSERT INTO users (nome, username, senha, email) VALUES
('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')
GO

INSERT INTO projects (nome, descricao, data_projeto) VALUES 
('Re-folha', 'Refatoração das Folhas', '05/09/2014'),
('Manutenção PCs', 'Manutenção PCs', '06/09/2014'),
('Auditoria', ' ', '07/09/2014')
GO

INSERT INTO users_has_projects VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)
GO
--UPDATES-------------------------------------------------------------------------------- 

UPDATE projects
SET data_projeto = '12/09/2014'
	WHERE id = 10002
GO
UPDATE users
SET username = 'Rh_cido'
	WHERE username like '%apareci%'
GO
UPDATE users
SET senha = CASE
	WHEN username = 'Rh_maria' and senha = '123mudar'
		THEN
			'888@*'
		ELSE
			senha --sem este ELSE o UPDATE estava tendando inserir NULL nas tuplas restantes.
	END
GO

DELETE users_has_projects
WHERE users_id = 2 and projects_id = 10002

--SELECTS-------------------------------------------------------------------------------- 
go
select id, nome, email, username, case
	when senha = '123mudar'
		then
			'123mudar'
		else
			'********'
	end as senha
from users

go
select nome, descricao, data_projeto, DATEADD(DAY, 15, data_projeto) as data_final
from projects
where id in (
	select projects_id
	from users_has_projects
	where users_id in (
		select id
		from users
		where email = 'aparecido@empresa.com'
	)
)

go
select nome, email from users
where id in (
	select users_id from users_has_projects
	where projects_id in (
		select id from projects
		where nome = 'Auditoria'
	)
)

go
select nome, descricao, 
	convert(char(10), data_projeto, 103) as data_inicio,
	'16/09/2014' as data_final,
	(datediff(DAY, data_projeto, '16/09/2014')) * 79.85 as custo_total
from projects
where nome like('%Manutenção%')


--select * from users
--select * from projects
--select * from users_has_projects