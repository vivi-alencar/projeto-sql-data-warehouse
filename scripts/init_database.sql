/*
=============================================================
Criar banco de dados e esquemas
=============================================================
Finalidade do script: criar novo banco de dados "DataWarehouse" após verificar se este já existe.
Caso exista, será removido e recriado.
O script configura três esquemas no banco de dados, seguindo o modelo medalhão:
- bronze (dados brutos)
- silver (dados tratados)
- gold (dados prontos para análise)

*** AVISO ***:
A execução deste script removerá TODO o banco de dados "DataWarehouse", caso exista.
TODOS os dados no banco de dados serão excluídos PERMANENTEMENTE.
Certifique-se de que backups tenham sido criados antes de executar este script.
*/

USE master;
GO

-- Remover e recriar o banco de dados 'DataWarehouse'
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
-- Forçar remoção do banco de dados existente (modo SINGLE_USER)
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Criar o banco de dados 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Criar esquemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
