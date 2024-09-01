{{ config(materialized='table', schema='gold') }}
SELECT
    {{ dbt_utils.generate_surrogate_key(['id_vendedores']) }} as sk_vendedor_id,
    id_vendedores AS vendedor_id,
    nome_vendedor,
    id_concessionarias AS concessionaria_id,
    data_inclusao,
    data_atualizacao
FROM {{ source('novadrive_silver','silver_vendedores') }}
