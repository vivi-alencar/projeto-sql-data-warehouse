# Catálogo de dados – Camada silver

## Visão Geral
A **Camada Silver** contém dados **padronizados, limpos e transformados** a partir da Bronze.  
Objetivos principais:
- Garantir **unicidade** de chaves primárias.  
- Normalizar valores de **status civil, gênero, linha de produto e países**.  
- Corrigir **datas inválidas** e recalcular **valores de vendas/preços** quando necessário.  
- Preparar os dados para **integrações e análises** na camada Gold.

---

## 1. silver.crm_cust_info

| Coluna             | Tipo          | Descrição |
|--------------------|---------------|-----------|
| cst_id             | INT           | Identificador único do cliente (última ocorrência válida). |
| cst_key            | NVARCHAR(50)  | Chave de cliente, sem espaços extras. |
| cst_firstname      | NVARCHAR(50)  | Primeiro nome, `TRIM` aplicado. |
| cst_lastname       | NVARCHAR(50)  | Sobrenome, `TRIM` aplicado. |
| cst_marital_status | NVARCHAR(20)  | Estado civil normalizado: `Single`, `Married`, `n/a`. |
| cst_gndr           | NVARCHAR(20)  | Gênero normalizado: `Male`, `Female`, `n/a`. |
| cst_create_date    | DATE          | Data de criação do registro. |

---

## 2. silver.crm_prd_info

| Coluna        | Tipo          | Descrição |
|---------------|---------------|-----------|
| prd_id        | INT           | Identificador único do produto. |
| cat_id        | NVARCHAR(10)  | Categoria derivada do prefixo de `prd_key` (substitui `-` por `_`). |
| prd_key       | NVARCHAR(50)  | Chave do produto extraída do `prd_key` original (sem prefixo de categoria). |
| prd_nm        | NVARCHAR(50)  | Nome do produto, sem espaços extras. |
| prd_cost      | DECIMAL(10,2) | Custo normalizado (`NULL` → `0`). Não pode ser negativo. |
| prd_line      | NVARCHAR(20)  | Linha normalizada: `Mountain`, `Road`, `Other Sales`, `Touring`, `n/a`. |
| prd_start_dt  | DATE          | Data de início convertida. |
| prd_end_dt    | DATE          | Data de fim calculada como 1 dia antes do próximo início. |

---

## 3. silver.crm_sales_details

| Coluna        | Tipo          | Descrição |
|---------------|---------------|-----------|
| sls_ord_num   | NVARCHAR(50)  | Número do pedido. |
| sls_prd_key   | NVARCHAR(50)  | Chave de produto relacionada. |
| sls_cust_id   | INT           | Cliente relacionado à venda. |
| sls_order_dt  | DATE          | Data do pedido (inteiro convertido; inválidos → `NULL`). |
| sls_ship_dt   | DATE          | Data de envio (inteiro convertido; inválidos → `NULL`). |
| sls_due_dt    | DATE          | Data de vencimento (inteiro convertido; inválidos → `NULL`). |
| sls_sales     | DECIMAL(10,2) | Valor da venda. Se inconsistente, recalculado como `sls_quantity * ABS(sls_price)`. |
| sls_quantity  | INT           | Quantidade do item. |
| sls_price     | DECIMAL(10,2) | Preço unitário. Se inválido (`NULL`/≤0), derivado como `sls_sales / sls_quantity`. |

---

## 4. silver.erp_cust_az12

| Coluna | Tipo          | Descrição |
|--------|---------------|-----------|
| cid    | NVARCHAR(50)  | Identificador do cliente; prefixo `NAS` removido quando presente. |
| bdate  | DATE          | Data de nascimento (datas futuras corrigidas para `NULL`). |
| gen    | NVARCHAR(20)  | Gênero normalizado: `Male`, `Female`, `n/a`. |

---

## 5. silver.erp_loc_a101

| Coluna | Tipo          | Descrição |
|--------|---------------|-----------|
| cid    | NVARCHAR(50)  | Identificador do cliente; hífens removidos. |
| cntry  | NVARCHAR(50)  | País normalizado: `Germany`, `United States`, `n/a`, ou código/descrição original. |

---

## 6. silver.erp_px_cat_g1v2

| Coluna         | Tipo          | Descrição |
|----------------|---------------|-----------|
| id             | NVARCHAR(50)  | Identificador de produto. |
| cat            | NVARCHAR(50)  | Categoria, `TRIM` aplicado. |
| subcat         | NVARCHAR(50)  | Subcategoria, `TRIM` aplicado. |
| maintenance | NVARCHAR(50)  | Indicador de manutenção, `TRIM` aplicado. |

---
