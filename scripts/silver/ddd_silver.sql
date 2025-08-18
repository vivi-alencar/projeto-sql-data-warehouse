/*
===============================================================================
Script DDL: Criar Tabelas Silver
===============================================================================
Objetivo: criar tabelas no esquema 'silver', apagando as tabelas existentes 
    caso já existam.
    Execute este script para redefinir a estrutura DDL das tabelas 'silver'.
===============================================================================
*/

-- Se a tabela silver.crm_cust_info já existir, apaga
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

-- Cria a tabela silver.crm_cust_info
CREATE TABLE silver.crm_cust_info (
    cst_id             INT,            -- ID do cliente
    cst_key            NVARCHAR(50),   -- Chave do cliente
    cst_firstname      NVARCHAR(50),   -- Nome
    cst_lastname       NVARCHAR(50),   -- Sobrenome
    cst_marital_status NVARCHAR(50),   -- Estado civil
    cst_gndr           NVARCHAR(50),   -- Gênero
    cst_create_date    DATE,           -- Data de criação no sistema origem
    dwh_create_date    DATETIME2 DEFAULT GETDATE() -- Data de carga no Data Warehouse
);
GO

-- Se a tabela silver.crm_prd_info já existir, apaga
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

-- Cria a tabela silver.crm_prd_info
CREATE TABLE silver.crm_prd_info (
    prd_id          INT,            -- ID do produto
    cat_id          NVARCHAR(50),   -- ID da categoria
    prd_key         NVARCHAR(50),   -- Chave do produto
    prd_nm          NVARCHAR(50),   -- Nome do produto
    prd_cost        INT,            -- Custo
    prd_line        NVARCHAR(50),   -- Linha de produto
    prd_start_dt    DATE,           -- Data de início de disponibilidade
    prd_end_dt      DATE,           -- Data de fim de disponibilidade
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Se a tabela silver.crm_sales_details já existir, apaga
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

-- Cria a tabela silver.crm_sales_details
CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),   -- Número do pedido
    sls_prd_key     NVARCHAR(50),   -- Chave do produto
    sls_cust_id     INT,            -- ID do cliente
    sls_order_dt    DATE,           -- Data do pedido
    sls_ship_dt     DATE,           -- Data de envio
    sls_due_dt      DATE,           -- Prazo final
    sls_sales       INT,            -- Valor total da venda
    sls_quantity    INT,            -- Quantidade
    sls_price       INT,            -- Preço unitário
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Se a tabela silver.erp_loc_a101 já existir, apaga
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

-- Cria a tabela silver.erp_loc_a101
CREATE TABLE silver.erp_loc_a101 (
    cid             NVARCHAR(50),   -- Código do cliente
    cntry           NVARCHAR(50),   -- País
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Se a tabela silver.erp_cust_az12 já existir, apaga
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

-- Cria a tabela silver.erp_cust_az12
CREATE TABLE silver.erp_cust_az12 (
    cid             NVARCHAR(50),   -- Código do cliente
    bdate           DATE,           -- Data de nascimento
    gen             NVARCHAR(50),   -- Gênero
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

-- Se a tabela silver.erp_px_cat_g1v2 já existir, apaga
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

-- Cria a tabela silver.erp_px_cat_g1v2
CREATE TABLE silver.erp_px_cat_g1v2 (
    id              NVARCHAR(50),   -- Identificador
    cat             NVARCHAR(50),   -- Categoria
    subcat          NVARCHAR(50),   -- Subcategoria
    maintenance     NVARCHAR(50),   -- Informação de manutenção
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
