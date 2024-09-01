{{ config(materialized='table', schema='silver') }}
WITH source AS (
    SELECT
        id_clientes,
        INITCAP(cliente) AS cliente,
        TRIM(endereco) AS endereco,
        id_concessionarias,
        data_inclusao,
        COALESCE(data_atualizacao, TIMESTAMP(data_inclusao)) AS data_atualizacao
    FROM {{ source('novadrive_bronze', 'bronze_clientes') }}
)

SELECT
    id_clientes,
    cliente,
    endereco,
    id_concessionarias,
    data_inclusao,
    data_atualizacao
FROM source
