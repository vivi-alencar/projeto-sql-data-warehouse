/*
===============================================================================
Verificações de Qualidade
===============================================================================
Objetivo: executar verificações de qualidade para validar a integridade, 
    consistência e exatidão da Camada Gold. Essas verificações garantem:
    - Exclusividade das chaves substitutas (surrogate keys) nas tabelas de dimensão.
    - Integridade referencial entre tabelas de fatos e dimensões.
    - Validação dos relacionamentos no modelo de dados para fins analíticos.

Notas de Uso:
    - Investigue e resolva quaisquer discrepâncias encontradas durante as verificações.
===============================================================================
*/

-- ====================================================================
-- Verificando 'gold.dim_customers'
-- ====================================================================
-- Verificar a exclusividade da chave de cliente em gold.dim_customers
-- Expectativa: Nenhum resultado
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Verificando 'gold.dim_products'
-- ====================================================================
-- Verificar a exclusividade da chave de produto em gold.dim_products
-- Expectativa: Nenhum resultado
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Verificando 'gold.fact_sales'
-- ====================================================================
-- Verificar a conectividade do modelo de dados entre fatos e dimensões
-- Expectativa: Nenhum resultado
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
