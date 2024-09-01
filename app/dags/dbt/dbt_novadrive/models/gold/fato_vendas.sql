{{ config(materialized='incremental', unique_key='venda_id', schema='gold') }}
--{{ config(materialized='table', unique_key='venda_id', schema='gold') }}
WITH vendas AS (
    SELECT
        v.id_vendas AS venda_id,
        v.id_veiculos AS veiculo_id,
        v.id_concessionarias AS concessionaria_id,
        v.id_vendedores AS vendedor_id,
        v.id_clientes AS cliente_id,
        v.valor_venda, 
        v.data_venda,
        v.data_inclusao,
        v.data_atualizacao
    FROM {{ source('novadrive_silver', 'silver_vendas') }} v
    JOIN {{ ref('dim_veiculos') }} vei ON v.id_veiculos = vei.veiculo_id
    JOIN {{ ref('dim_concessionarias') }} con ON v.id_concessionarias = con.concessionaria_id
    JOIN {{ ref('dim_vendedores') }} ven ON v.id_vendedores = ven.vendedor_id
    JOIN {{ ref('dim_clientes') }} cli ON v.id_clientes = cli.cliente_id
)

SELECT
    venda_id,
    veiculo_id,
    concessionaria_id,
    vendedor_id,
    cliente_id,
    valor_venda,
    data_venda,
    data_inclusao,
    data_atualizacao
FROM vendas
{% if is_incremental() %}
    WHERE venda_id > (SELECT MAX(venda_id) FROM {{ this }})
{% endif %}