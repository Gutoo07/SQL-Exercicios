CREATE DATABASE ex3
GO
USE ex3
--================================================
CREATE TABLE mae (
ID_Mae		INT				NOT NULL		identity(1001, 1),
nome		VARCHAR(60)		NOT NULL,
logradouro	VARCHAR(100)	NOT NULL,
numero		INT				NOT NULL		check(numero >= 0),
cep			CHAR(8)			NOT NULL		check(len(cep) = 8),
complemento	VARCHAR(200)	NOT NULL,
telefone	CHAR(10)		NOT NULL		check(len(telefone) = 10),
data_nasc	DATE			NOT NULL
PRIMARY KEY (ID_Mae)
)
GO
CREATE TABLE medico (
CRM_numero		INT				NOT NULL,
CRM_UF			CHAR(2)			NOT NULL,
nome			VARCHAR(60)		NOT NULL,
celular			CHAR(11)		NULL		check(len(celular) = 11) unique,
especialidade	VARCHAR(30)		NOT NULL
PRIMARY KEY(CRM_numero, CRM_UF)
)
GO
CREATE TABLE bebe (
ID_Bebe			INT				NOT NULL	identity(1, 1),
nome			VARCHAR(60)		NOT NULL,
data_nasc		DATE			NOT NULL	default(GETDATE()),
altura			DECIMAL(7,2)	NOT NULL	check(altura >= 0),
peso			DECIMAL(7,2)	NOT NULL	check(peso >= 0),
ID_Mae			INT				NOT NULL
PRIMARY KEY (ID_Bebe)
FOREIGN KEY (ID_Mae) REFERENCES mae(ID_Mae)
)
GO
CREATE TABLE bebe_medico (
ID_Bebe			INT				NOT NULL,
CRM_numero		INT				NOT NULL,
CRM_UF			CHAR(2)			NOT NULL
PRIMARY KEY (ID_Bebe, CRM_Numero, CRM_UF)
FOREIGN KEY (ID_Bebe) REFERENCES bebe(ID_Bebe),
FOREIGN KEY (CRM_numero, CRM_UF) REFERENCES
	medico(CRM_numero, CRM_UF)
) 
--Informações das tabelas (Comando exclusivo SQL Server)
--EXEC sp_help nome_tabela
EXEC sp_help mae
EXEC sp_help bebe
EXEC sp_help medico
EXEC sp_help bebe_medico