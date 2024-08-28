{{ config(materialized='table', schema='gold') }}
SELECT
    {{ dbt_utils.generate_surrogate_key(['id_estados']) }} as sk_estado_id,
    id_estados AS estado_id,
    estado AS nome_estado,
    sigla,
    data_inclusao,
    data_atualizacao
FROM {{ source('novadrive_silver','silver_estados') }}
