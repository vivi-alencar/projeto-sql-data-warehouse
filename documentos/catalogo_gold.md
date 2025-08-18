# Catálogo de dados – Camada gold

## Visão Geral
A **Camada Gold** é a representação de dados em nível de negócio, estruturada para dar suporte a casos de uso analíticos e de relatórios.  
Ela é composta por **tabelas de dimensão** e **tabelas de fatos** para métricas específicas de negócio.

---

## 1. gold.dim_customers

**Propósito:** Armazena detalhes dos clientes enriquecidos com dados demográficos e geográficos.

| Coluna          | Tipo         | Descrição |
|-----------------|--------------|-----------|
| customer_key    | INT          | Chave substituta que identifica de forma única cada registro de cliente na tabela de dimensão. |
| customer_id     | INT          | Identificador numérico único atribuído a cada cliente. |
| customer_number | NVARCHAR(50) | Identificador alfanumérico usado para rastrear e referenciar o cliente. |
| first_name      | NVARCHAR(50) | Primeiro nome do cliente, conforme registrado no sistema. |
| last_name       | NVARCHAR(50) | Sobrenome ou nome de família do cliente. |
| country         | NVARCHAR(50) | País de residência do cliente (ex.: 'Australia'). |
| marital_status  | NVARCHAR(50) | Estado civil do cliente (ex.: 'Married', 'Single'). |
| gender          | NVARCHAR(50) | Gênero do cliente (ex.: 'Male', 'Female', 'n/a'). |
| birthdate       | DATE         | Data de nascimento no formato YYYY-MM-DD (ex.: 1971-10-06). |
| create_date     | DATE         | Data e hora em que o registro do cliente foi criado no sistema. |

---

## 2. gold.dim_products

**Propósito:** Fornece informações sobre os produtos e seus atributos.

| Coluna               | Tipo         | Descrição |
|----------------------|--------------|-----------|
| product_key          | INT          | Chave substituta que identifica de forma única cada registro de produto na tabela de dimensão. |
| product_id           | INT          | Identificador único atribuído ao produto para rastreamento interno. |
| product_number       | NVARCHAR(50) | Código alfanumérico estruturado que representa o produto, usado para categorização ou inventário. |
| product_name         | NVARCHAR(50) | Nome descritivo do produto, incluindo detalhes como tipo, cor e tamanho. |
| category_id          | NVARCHAR(50) | Identificador único da categoria do produto, ligando à sua classificação de alto nível. |
| category             | NVARCHAR(50) | Classificação mais ampla do produto (ex.: Bikes, Components) para agrupar itens relacionados. |
| subcategory          | NVARCHAR(50) | Classificação mais detalhada dentro da categoria, como o tipo de produto. |
| maintenance_required | NVARCHAR(50) | Indica se o produto requer manutenção (ex.: 'Yes', 'No'). |
| cost                 | INT          | Custo ou preço base do produto, em unidades monetárias. |
| product_line         | NVARCHAR(50) | Linha ou série específica à qual o produto pertence (ex.: Road, Mountain). |
| start_date           | DATE         | Data em que o produto passou a estar disponível para venda ou uso. |

---

## 3. gold.fact_sales

**Propósito:** Armazena dados transacionais de vendas para análise.

| Coluna        | Tipo         | Descrição |
|---------------|--------------|-----------|
| order_number  | NVARCHAR(50) | Identificador alfanumérico único para cada pedido de venda (ex.: 'SO54496'). |
| product_key   | INT          | Chave substituta ligando o pedido à tabela de dimensão de produtos. |
| customer_key  | INT          | Chave substituta ligando o pedido à tabela de dimensão de clientes. |
| order_date    | DATE         | Data em que o pedido foi realizado. |
| shipping_date | DATE         | Data em que o pedido foi enviado ao cliente. |
| due_date      | DATE         | Data de vencimento do pagamento do pedido. |
| sales_amount  | INT          | Valor total monetário da venda para o item, em unidades inteiras de moeda (ex.: 25). |
| quantity      | INT          | Quantidade de unidades do produto vendidas para o item (ex.: 1). |
| price         | INT          | Preço unitário do produto para o item, em unidades inteiras de moeda (ex.: 25). |
