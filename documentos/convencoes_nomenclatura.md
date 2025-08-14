# Convenções de nomenclatura – Armazén de dados

## Princípios Gerais
- **Formato:** Use *snake_case*, com letras minúsculas e underscores (`_`) para separar palavras.  
- **Idioma:** Use inglês para todos os nomes.  
- **Evitar Palavras Reservadas:** Não utilize palavras reservadas do SQL como nomes de objetos.  

---

## Convenções de Nomenclatura de Tabelas

### Bronze – Regras
- Todos os nomes devem começar com o nome do sistema de origem.  
- O nome da tabela deve corresponder exatamente ao nome original na fonte, sem renomear.  
- Formato: `<sourcesystem>_<entity>`  
  - `<sourcesystem>`: Nome do sistema de origem (ex.: `crm`, `erp`).  
  - `<entity>`: Nome exato da tabela no sistema de origem.  
- **Exemplo:**  
  - `crm_customer_info` → informações de clientes do sistema CRM.

---

### Silver – Regras
- Mesmas regras da camada Bronze.  
- Formato: `<sourcesystem>_<entity>`  
  - `<sourcesystem>`: Nome do sistema de origem (ex.: `crm`, `erp`).  
  - `<entity>`: Nome exato da tabela no sistema de origem.  
- **Exemplo:**  
  - `crm_customer_info` → informações de clientes do sistema CRM.

---

### Gold – Regras
- Usar nomes significativos, alinhados ao negócio, começando com o prefixo da categoria.  
- Formato: `<category>_<entity>`  
  - `<category>`: Descreve o papel da tabela, como `dim` (dimensão) ou `fact` (fato).  
  - `<entity>`: Nome descritivo da tabela, alinhado ao domínio de negócio (ex.: `customers`, `products`, `sales`).  
- **Exemplos:**  
  - `dim_customers` → Tabela de dimensão para dados de clientes.  
  - `fact_sales` → Tabela de fatos contendo transações de vendas.

---

## Glossário de Prefixos de Categoria

| Padrão   | Significado            | Exemplo(s) |
|----------|-----------------------|------------|
| dim_     | Tabela de dimensão    | dim_customer, dim_product |
| fact_    | Tabela de fatos       | fact_sales |
| report_  | Tabela de relatórios  | report_customers, report_sales_monthly |

---

## Convenções de Nomenclatura de Colunas

### Chaves Substitutas
- Todas as chaves primárias em tabelas de dimensão devem usar o sufixo `_key`.  
- Formato: `<table_name>_key`  
  - `<table_name>`: Nome da tabela ou entidade.  
  - `_key`: Sufixo indicando chave substituta (*surrogate key*).  
- **Exemplo:**  
  - `customer_key` → chave substituta na tabela `dim_customers`.

### Colunas Técnicas
- Todas as colunas técnicas devem começar com o prefixo `dwh_`, seguido por um nome descritivo.  
- Formato: `dwh_<column_name>`  
  - `dwh`: Prefixo exclusivo para metadados gerados pelo sistema.  
  - `<column_name>`: Nome descritivo da coluna.  
- **Exemplo:**  
  - `dwh_load_date` → coluna usada para armazenar a data em que o registro foi carregado.

---

## Convenção para Stored Procedures
- Todas as *stored procedures* usadas para carga de dados devem seguir o padrão:  
  - `load_<layer>`  
    - `<layer>`: Camada que está sendo carregada, como `bronze`, `silver` ou `gold`.  
- **Exemplos:**  
  - `load_bronze` → procedure para carregar dados na camada Bronze.  
  - `load_silver` → procedure para carregar dados na camada Silver.  
  - `load_gold` → procedure para carregar dados na camada Gold.
