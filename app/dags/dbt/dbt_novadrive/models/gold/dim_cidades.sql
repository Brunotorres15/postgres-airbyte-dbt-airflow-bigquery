{{ config(materialized='table', schema='gold') }}
SELECT
{{ dbt_utils.generate_surrogate_key(['id_cidades']) }} as sk_cidade_id,
    id_cidades AS cidade_id,
    nome_cidade,
    id_estados AS estado_id,
    data_inclusao,
    data_atualizacao
FROM {{ source('novadrive_silver','silver_cidades') }}
