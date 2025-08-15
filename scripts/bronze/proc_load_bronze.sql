/*
===============================================================================
Stored Procedure: Source -> Bronze
===============================================================================
Objetivo: carregar dados para o schema 'bronze' a partir de arquivos CSV externos.
    Ações executadas:
    - Truncar as tabelas da camada Bronze antes de carregar novos dados.
    - Usar o comando `BULK INSERT` para carregar dados dos arquivos CSV para as tabelas Bronze.

Parâmetros:
    Nenhum.  
    Esta stored procedure não aceita parâmetros nem retorna valores.

Exemplo de Uso:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '================================================';
		PRINT 'Carregando a Camada Bronze';
		PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Carregando tabelas do CRM';
		PRINT '------------------------------------------------';

		-- Carregar bronze.crm_cust_info
		SET @start_time = GETDATE();
		PRINT '>> Truncando tabela: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserindo dados em: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\SQL\ProjetoDWH\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,             -- Ignora o cabeçalho (primeira linha)
			FIELDTERMINATOR = ',',    -- Delimitador de campos
			TABLOCK                   -- Bloqueio de tabela para carga mais rápida
		);
		SET @end_time = GETDATE();
		PRINT '>> Duração da carga: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' segundos';
		PRINT '>> -------------';

		-- Carregar bronze.crm_prd_info
        SET @start_time = GETDATE();
		PRINT '>> Truncando tabela: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> Inserindo dados em: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\SQL\ProjetoDWH\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Duração da carga: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' segundos';
		PRINT '>> -------------';

		-- Carregar bronze.crm_sales_details
        SET @start_time = GETDATE();
		PRINT '>> Truncando tabela: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> Inserindo dados em: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\SQL\ProjetoDWH\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Duração da carga: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' segundos';
		PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Carregando tabelas do ERP';
		PRINT '------------------------------------------------';
		
		-- Carregar bronze.erp_loc_a101
		SET @start_time = GETDATE();
		PRINT '>> Truncando tabela: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>> Inserindo dados em: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\SQL\ProjetoDWH\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Duração da carga: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' segundos';
		PRINT '>> -------------';

		-- Carregar bronze.erp_cust_az12
		SET @start_time = GETDATE();
		PRINT '>> Truncando tabela: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>> Inserindo dados em: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\SQL\ProjetoDWH\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Duração da carga: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' segundos';
		PRINT '>> -------------';

		-- Carregar bronze.erp_px_cat_g1v2
		SET @start_time = GETDATE();
		PRINT '>> Truncando tabela: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>> Inserindo dados em: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\SQL\ProjetoDWH\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Duração da carga: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' segundos';
		PRINT '>> -------------';

		-- Resumo do processo
		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Carga da Camada Bronze concluída';
        PRINT '   - Duração total da carga: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' segundos';
		PRINT '=========================================='
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERRO DURANTE A CARGA DA CAMADA BRONZE'
		PRINT 'Mensagem de erro: ' + ERROR_MESSAGE();
		PRINT 'Número do erro: ' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Estado do erro: ' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
