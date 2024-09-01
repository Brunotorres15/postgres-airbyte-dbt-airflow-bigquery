{{ config(materialized='table', schema='gold') }}
SELECT
    {{ dbt_utils.generate_surrogate_key(['id_concessionarias']) }} as sk_concessionaria_id,
    id_concessionarias AS concessionaria_id,
    nome_concessionaria,
    id_cidades AS cidade_id,
    data_inclusao,
    data_atualizacao
FROM {{ source('novadrive_silver', 'silver_concessionarias') }}
