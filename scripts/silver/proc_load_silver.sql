/*
===============================================================================
Stored Procedure: Bronze -> Silver
===============================================================================
Objetivo: executa o processo de ETL (Extract, Transform, Load)
    para popular as tabelas do schema 'silver' a partir do schema 'bronze'.

Ações executadas:
    - Trunca as tabelas Silver.
    - Insere dados transformados e tratados do Bronze para o Silver.

Parâmetros:
    Nenhum.
    Esta stored procedure não aceita parâmetros e não retorna valores.

Exemplo de uso:
    EXEC silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Carregando a Camada Silver';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Carregando tabelas do CRM';
        PRINT '------------------------------------------------';

        -- ============================
        -- silver.crm_cust_info
        -- Deduplica por cst_id (mantém o registro mais recente) e normaliza
        -- estado civil e gênero para valores legíveis.
        -- ============================
        SET @start_time = GETDATE();
        PRINT '>> Truncando tabela: silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;

        PRINT '>> Inserindo dados em: silver.crm_cust_info';
        INSERT INTO silver.crm_cust_info (
            cst_id, 
            cst_key, 
            cst_firstname, 
            cst_lastname, 
            cst_marital_status, 
            cst_gndr,
            cst_create_date
        )
        SELECT
            cst_id,
            cst_key,
            TRIM(cst_firstname) AS cst_firstname,         -- remove espaços extras
            TRIM(cst_lastname)  AS cst_lastname,
            CASE 
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                ELSE 'n/a'
            END AS cst_marital_status,                     -- normaliza estado civil
            CASE 
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'n/a'
            END AS cst_gndr,                               -- normaliza gênero
            cst_create_date
        FROM (
            SELECT
                *,
                ROW_NUMBER() OVER (
                    PARTITION BY cst_id 
                    ORDER BY cst_create_date DESC
                ) AS flag_last
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) t
        WHERE flag_last = 1; -- mantém apenas o último registro por cliente
        SET @end_time = GETDATE();
        PRINT '>> Duração da carga: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        -- ============================
        -- silver.crm_prd_info
        -- Extrai cat_id de prd_key, mapeia prd_line para valores textuais,
        -- ajusta datas (start/end) com janela LEAD.
        -- ============================
        SET @start_time = GETDATE();
        PRINT '>> Truncando tabela: silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;

        PRINT '>> Inserindo dados em: silver.crm_prd_info';
        INSERT INTO silver.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- extrai categoria do prefixo e troca '-' por '_'
            SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,        -- remove o prefixo para obter a chave do produto
            prd_nm,
            ISNULL(prd_cost, 0) AS prd_cost,                       -- preenche custo nulo com 0
            CASE 
                WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                ELSE 'n/a'
            END AS prd_line,                                       -- mapeia códigos para rótulos descritivos
            CAST(prd_start_dt AS DATE) AS prd_start_dt,
            CAST(
                LEAD(prd_start_dt) OVER (
                    PARTITION BY prd_key 
                    ORDER BY prd_start_dt
                ) - 1 AS DATE
            ) AS prd_end_dt                                        -- fim = dia anterior ao próximo início (técnica de SCD por faixa de datas)
        FROM bronze.crm_prd_info;
        SET @end_time = GETDATE();
        PRINT '>> Duração da carga: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        -- ============================
        -- silver.crm_sales_details
        -- Converte datas YYYYMMDD armazenadas como INT; recalcula sales se inválido;
        -- deriva price quando necessário.
        -- ============================
        SET @start_time = GETDATE();
        PRINT '>> Truncando tabela: silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;

        PRINT '>> Inserindo dados em: silver.crm_sales_details';
        INSERT INTO silver.crm_sales_details (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        )
        SELECT 
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            CASE 
                WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
            END AS sls_order_dt,                                  -- valida e converte YYYYMMDD -> DATE
            CASE 
                WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
            END AS sls_ship_dt,
            CASE 
                WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
            END AS sls_due_dt,
            CASE 
                WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
                    THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales,                                     -- recalcula sales se ausente/incorreto
            sls_quantity,
            CASE 
                WHEN sls_price IS NULL OR sls_price <= 0 
                    THEN sls_sales / NULLIF(sls_quantity, 0)
                ELSE sls_price
            END AS sls_price                                      -- deriva price se inválido (evita divisão por zero com NULLIF)
        FROM bronze.crm_sales_details;
        SET @end_time = GETDATE();
        PRINT '>> Duração da carga: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        -- ============================
        -- silver.erp_cust_az12
        -- Remove prefixo 'NAS' de cid, zera datas de nascimento futuras,
        -- normaliza valores de gênero.
        -- ============================
        SET @start_time = GETDATE();
        PRINT '>> Truncando tabela: silver.erp_cust_az12';
        TRUNCATE TABLE silver.erp_cust_az12;

        PRINT '>> Inserindo dados em: silver.erp_cust_az12';
        INSERT INTO silver.erp_cust_az12 (
            cid,
            bdate,
            gen
        )
        SELECT
            CASE
                WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- remove o prefixo 'NAS' (se houver)
                ELSE cid
            END AS cid, 
            CASE
                WHEN bdate > GETDATE() THEN NULL
                ELSE bdate
            END AS bdate,                                            -- datas de nascimento futuras viram NULL
            CASE
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE')   THEN 'Male'
                ELSE 'n/a'
            END AS gen                                               -- normaliza gênero e trata desconhecidos
        FROM bronze.erp_cust_az12;
        SET @end_time = GETDATE();
        PRINT '>> Duração da carga: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        PRINT '------------------------------------------------';
        PRINT 'Carregando tabelas do ERP';
        PRINT '------------------------------------------------';

        -- ============================
        -- silver.erp_loc_a101
        -- Remove hífens do cid e normaliza país (DE/US/USA etc.).
        -- ============================
        SET @start_time = GETDATE();
        PRINT '>> Truncando tabela: silver.erp_loc_a101';
        TRUNCATE TABLE silver.erp_loc_a101;

        PRINT '>> Inserindo dados em: silver.erp_loc_a101';
        INSERT INTO silver.erp_loc_a101 (
            cid,
            cntry
        )
        SELECT
            REPLACE(cid, '-', '') AS cid, 
            CASE
                WHEN TRIM(cntry) = 'DE'            THEN 'Germany'
                WHEN TRIM(cntry) IN ('US','USA')   THEN 'United States'
                WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
                ELSE TRIM(cntry)
            END AS cntry                                              -- normaliza país e trata vazios/nulos
        FROM bronze.erp_loc_a101;
        SET @end_time = GETDATE();
        PRINT '>> Duração da carga: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';
        
        -- ============================
        -- silver.erp_px_cat_g1v2
        -- Pass-through (sem transformação) — mantém como referência central
        -- de categorias/subcategorias/maintenance no Silver.
        -- ============================
        SET @start_time = GETDATE();
        PRINT '>> Truncando tabela: silver.erp_px_cat_g1v2';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        PRINT '>> Inserindo dados em: silver.erp_px_cat_g1v2';
        INSERT INTO silver.erp_px_cat_g1v2 (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT
            id,
            cat,
            subcat,
            maintenance
        FROM bronze.erp_px_cat_g1v2;
        SET @end_time = GETDATE();
        PRINT '>> Duração da carga: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' segundos';
        PRINT '>> -------------';

        -- Resumo
        SET @batch_end_time = GETDATE();
        PRINT '==========================================';
        PRINT 'Carga da Camada Silver concluída';
        PRINT '   - Duração total da carga: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' segundos';
        PRINT '==========================================';
        
    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERRO DURANTE A CARGA DA CAMADA SILVER';
        PRINT 'Mensagem de erro: ' + ERROR_MESSAGE();
        PRINT 'Número do erro: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Estado do erro: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END