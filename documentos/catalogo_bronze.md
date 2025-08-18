# Catálogo de dados – Camada bronze

## Visão Geral
A **Camada Bronze** armazena os dados **brutos**, espelhando os arquivos CSV entregues pelos sistemas de origem (CRM e ERP), **sem transformações** além da ingestão.

---

## 1. bronze.crm_cust_info

| Nome da coluna     | Tipo de dados | Descrição |
|--------------------|---------------|-----------|
| cst_id             | INT           | Identificador do cliente. |
| cst_key            | NVARCHAR(50)  | Chave/identificador alternativo do cliente. |
| cst_firstname      | NVARCHAR(50)  | Primeiro nome do cliente. |
| cst_lastname       | NVARCHAR(50)  | Sobrenome do cliente. |
| cst_marital_status | NVARCHAR(50)  | Estado civil em código/texto (ex.: `S`, `M`). |
| cst_gndr           | NVARCHAR(50)  | Gênero em código/texto (ex.: `F`, `M`). |
| cst_create_date    | DATE          | Data de criação do registro. |

---

## 2. bronze.crm_prd_info

| Nome da coluna| Tipo de dados | Descrição |
|---------------|---------------|-----------|
| prd_id        | INT           | Identificador do produto. |
| prd_key       | NVARCHAR(50)  | Chave composta/estruturada do produto. |
| prd_nm        | NVARCHAR(50)  | Nome do produto. |
| prd_cost      | INT           | Custo/preço base (pode vir nulo/zero/negativo). |
| prd_line      | NVARCHAR(50)  | Código/linha do produto (ex.: `M`, `R`, etc.). |
| prd_start_dt  | DATETIME      | Início de disponibilidade. |
| prd_end_dt    | DATETIME      | Fim de disponibilidade. |

---

## 3. bronze.crm_sales_details

| Nome da coluna| Tipo de dados | Descrição |
|---------------|---------------|-----------|
| sls_ord_num   | NVARCHAR(50)  | Número do pedido. |
| sls_prd_key   | NVARCHAR(50)  | Chave do produto no item de pedido. |
| sls_cust_id   | INT           | Identificador do cliente relacionado ao pedido. |
| sls_order_dt  | INT           | Data do pedido (`YYYYMMDD`). |
| sls_ship_dt   | INT           | Data de envio (`YYYYMMDD`). |
| sls_due_dt    | INT           | Prazo final (`YYYYMMDD`). |
| sls_sales     | INT           | Valor total do item de venda. |
| sls_quantity  | INT           | Quantidade do item. |
| sls_price     | INT           | Preço unitário. |

---

## 4. bronze.erp_loc_a101

| Nome da coluna| Tipo de dados | Descrição |
|---------------|---------------|-----------|
| cid           | NVARCHAR(50)  | Identificador de cliente. |
| cntry         | NVARCHAR(50)  | Código/descrição de país (ex.: `DE`, `US`). |

---

## 5. bronze.erp_cust_az12

| Nome da coluna | Tipo de dados | Descrição |
|----------------|---------------|-----------|
| cid            | NVARCHAR(50)  | Identificador de cliente (pode conter prefixos). |
| bdate          | DATE          | Data de nascimento. |
| gen            | NVARCHAR(50)  | Gênero (ex.: `M`, `F`, `Male`, `Female`). |

---

## 6. bronze.erp_px_cat_g1v2

| Nome da coluna | Tipo de dados | Descrição |
|----------------|---------------|-----------|
| id             | NVARCHAR(50)  | Identificador do produto. |
| cat            | NVARCHAR(50)  | Categoria principal. |
| subcat         | NVARCHAR(50)  | Subcategoria. |
| maintenance    | NVARCHAR(50)  | Indicador de manutenção (ex.: `Yes`/`No`). |

