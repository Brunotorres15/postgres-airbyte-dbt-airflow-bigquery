{{ config(materialized='table', schema='silver') }}
WITH source AS (
    SELECT
        id_concessionarias,
        TRIM(concessionaria) AS nome_concessionaria, 
        id_cidades,
        data_inclusao,
        COALESCE(data_atualizacao, TIMESTAMP(data_inclusao)) AS data_atualizacao 
    FROM {{ source('novadrive_bronze', 'bronze_concessionarias') }}
)
SELECT
    id_concessionarias,
    nome_concessionaria,
    id_cidades,
    data_inclusao,
    data_atualizacao
FROM source
