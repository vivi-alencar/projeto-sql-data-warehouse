# Matriz de Qualidade – Camada Silver

Este documento resume as principais regras de limpeza e padronização aplicadas na camada *Silver*.  
Objetivo: garantir dados consistentes, sem duplicidades e em formato adequado para análises.

---

## crm_cust_info
| Coluna              | Regra de Qualidade                                                                 |
|---------------------|------------------------------------------------------------------------------------|
| cst_id              | Duplicados eliminados (mantém apenas o registro mais recente).                     |
| cst_marital_status  | Valores `S` → "Single", `M` → "Married", outros → "n/a".                          |
| cst_gndr            | Valores `F` → "Female", `M` → "Male", outros → "n/a".                             |
| cst_firstname/lastname | Espaços extras removidos (TRIM).                                               |

---

## crm_prd_info
| Coluna     | Regra de Qualidade                                                   |
|------------|----------------------------------------------------------------------|
| prd_id     | Não pode ser nulo ou duplicado.                                      |
| cat_id     | Derivado do prefixo de `prd_key` (padrão normalizado).               |
| prd_key    | Sufixo de `prd_key` após `cat_id`.                                   |
| prd_cost   | Nulos substituídos por `0`.                                          |
| prd_line   | Códigos (`M`, `R`, `S`, `T`) traduzidos para valores descritivos.    |
| Datas      | `prd_start_dt` e `prd_end_dt` validados (fim ≥ início).              |

---

## crm_sales_details
| Coluna     | Regra de Qualidade                                                                            |
|------------|-----------------------------------------------------------------------------------------------|
| Datas      | Datas inválidas ou em formato incorreto → convertidas para `NULL`.                            |
| sls_sales  | Recalculado se nulo, ≤ 0 ou inconsistente (usa `sls_quantity * ABS(sls_price)`).              |
| sls_price  | Se inválido, derivado de `sls_sales / sls_quantity`.                                          |
| sls_order_dt vs sls_ship_dt/due_dt | Verificação: ordem ≤ envio ≤ prazo final.                              |

---

## erp_cust_az12
| Coluna  | Regra de Qualidade                                                           |
|---------|------------------------------------------------------------------------------|
| cid     | Prefixo `NAS` removido se presente.                                          |
| bdate   | Datas futuras → `NULL`. Aceito apenas intervalo 1924-01-01 até hoje.         |
| gen     | Normalizado para `"Male"`, `"Female"` ou `"n/a"`.                            |

---

## erp_loc_a101
| Coluna  | Regra de Qualidade                                         |
|---------|------------------------------------------------------------|
| cid     | Remoção do hífen                                           |
| cntry   | `DE` → "Germany", `US/USA` → "United States". Outros: "n/a"|

---

## erp_px_cat_g1v2
| Coluna        | Regra de Qualidade                    |
|---------------|---------------------------------------|
| cat           | Espaços extras removidos.  |
| subcat        | Espaços extras removidos.  |
| maintenance   | Espaços extras removidos.  |

---
