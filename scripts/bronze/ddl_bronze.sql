
/*
===============================================================================
Script DDL: Criação de Tabelas Bronze
===============================================================================
Objetivo: criar tabelas no schema 'bronze', removendo-as previamente caso
    já existam.  
===============================================================================
*/

-- ===========================================
-- Tabela: bronze.crm_cust_info
-- Origem: Sistema CRM
-- Descrição: Informações básicas de clientes
-- ===========================================
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,            -- ID numérico do cliente
    cst_key             NVARCHAR(50),   -- Chave de identificação do cliente
    cst_firstname       NVARCHAR(50),   -- Primeiro nome
    cst_lastname        NVARCHAR(50),   -- Sobrenome
    cst_marital_status  NVARCHAR(50),   -- Estado civil
    cst_gndr            NVARCHAR(50),   -- Gênero
    cst_create_date     DATE            -- Data de criação do registro
);
GO

-- ===========================================
-- Tabela: bronze.crm_prd_info
-- Origem: Sistema CRM
-- Descrição: Informações básicas de produtos
-- ===========================================
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,            -- ID numérico do produto
    prd_key      NVARCHAR(50),   -- Chave de identificação do produto
    prd_nm       NVARCHAR(50),   -- Nome do produto
    prd_cost     INT,            -- Custo
    prd_line     NVARCHAR(50),   -- Linha do produto
    prd_start_dt DATETIME,       -- Data de início de disponibilidade
    prd_end_dt   DATETIME        -- Data de fim de disponibilidade
);
GO

-- ===========================================
-- Tabela: bronze.crm_sales_details
-- Origem: Sistema CRM
-- Descrição: Detalhes de transações de vendas
-- ===========================================
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),  -- Número do pedido
    sls_prd_key  NVARCHAR(50),  -- Chave do produto
    sls_cust_id  INT,           -- ID do cliente
    sls_order_dt INT,           -- Data do pedido
    sls_ship_dt  INT,           -- Data de envio
    sls_due_dt   INT,           -- Data de vencimento
    sls_sales    INT,           -- Valor total da venda
    sls_quantity INT,           -- Quantidade vendida
    sls_price    INT            -- Preço unitário
);
GO

-- ===========================================
-- Tabela: bronze.erp_loc_a101
-- Origem: Sistema ERP
-- Descrição: Localização dos clientes (país)
-- ===========================================
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(50),  -- ID do cliente
    cntry  NVARCHAR(50)   -- País
);
GO

-- ===========================================
-- Tabela: bronze.erp_cust_az12
-- Origem: Sistema ERP
-- Descrição: Informações complementares de clientes
-- ===========================================
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid    NVARCHAR(50),  -- ID do cliente
    bdate  DATE,          -- Data de nascimento
    gen    NVARCHAR(50)   -- Gênero
);
GO

-- ===========================================
-- Tabela: bronze.erp_px_cat_g1v2
-- Origem: Sistema ERP
-- Descrição: Categorias e subcategorias de produtos
-- ===========================================
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),  -- ID do produto
    cat          NVARCHAR(50),  -- Categoria
    subcat       NVARCHAR(50),  -- Subcategoria
    maintenance  NVARCHAR(50)   -- Indica necessidade de manutenção (Yes/No)
);
GO
