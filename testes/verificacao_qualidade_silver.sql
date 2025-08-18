/*
===============================================================================
Verifica��es de Qualidade
===============================================================================
Objetivo: executar verifica��es de qualidade para consist�ncia,
    precis�o e padroniza��o de dados na camada 'silver'. Ele inclui checagens de:
    - Chaves prim�rias nulas ou duplicadas.
    - Espa�os indesejados em campos de texto.
    - Padroniza��o e consist�ncia de dados.
    - Intervalos e ordens de datas inv�lidas.
    - Consist�ncia de dados entre campos relacionados.

Notas de Uso:
    - Execute estas verifica��es ap�s o carregamento da Camada Silver.
    - Investigue e corrija quaisquer discrep�ncias encontradas.
===============================================================================
*/

-- ====================================================================
-- Verificando 'silver.crm_cust_info'
-- ====================================================================
-- Verificar se h� NULOs ou Duplicados na Chave Prim�ria
-- Expectativa: Nenhum resultado
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Verificar Espa�os Indesejados
-- Expectativa: Nenhum resultado
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Padroniza��o e Consist�ncia de Dados
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- ====================================================================
-- Verificando 'silver.crm_prd_info'
-- ====================================================================
-- Verificar se h� NULOs ou Duplicados na Chave Prim�ria
-- Expectativa: Nenhum resultado
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Verificar Espa�os Indesejados
-- Expectativa: Nenhum resultado
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Verificar NULOs ou Valores Negativos em Custo
-- Expectativa: Nenhum resultado
SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Padroniza��o e Consist�ncia de Dados
SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- Verificar Datas Inv�lidas (Data de In�cio > Data de Fim)
-- Expectativa: Nenhum resultado
SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Verificando 'silver.crm_sales_details'
-- ====================================================================
-- Verificar Datas Inv�lidas
-- Expectativa: Nenhuma data inv�lida
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
    OR LEN(sls_due_dt) != 8 
    OR sls_due_dt > 20500101 
    OR sls_due_dt < 19000101;

-- Verificar Ordens de Datas Inv�lidas (Data do Pedido > Envio/Vencimento)
-- Expectativa: Nenhum resultado
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Verificar Consist�ncia dos Dados: Vendas = Quantidade * Pre�o
-- Expectativa: Nenhum resultado
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Verificando 'silver.erp_cust_az12'
-- ====================================================================
-- Identificar Datas Fora do Intervalo
-- Expectativa: Datas de nascimento entre 1924-01-01 e hoje
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();

-- Padroniza��o e Consist�ncia de Dados
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- ====================================================================
-- Verificando 'silver.erp_loc_a101'
-- ====================================================================
-- Padroniza��o e Consist�ncia de Dados
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Verificando 'silver.erp_px_cat_g1v2'
-- ====================================================================
-- Verificar Espa�os Indesejados
-- Expectativa: Nenhum resultado
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Padroniza��o e Consist�ncia de Dados
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
