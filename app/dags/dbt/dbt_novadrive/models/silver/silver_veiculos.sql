{{ config(materialized='table', schema='silver') }}
WITH source AS (
    SELECT
        id_veiculos,
        nome,
        tipo,
        ROUND(CAST(valor AS NUMERIC), 2) AS valor,
        COALESCE(data_atualizacao, TIMESTAMP(data_inclusao)) AS data_atualizacao,
        data_inclusao
    FROM {{ source('novadrive_bronze', 'bronze_veiculos') }}
)
SELECT
    id_veiculos,
    nome,
    tipo,
    valor,
    data_atualizacao,
    data_inclusao
FROM source
