{{ config(materialized='table', schema='silver') }}
WITH source AS (
    SELECT
        id_estados,
        UPPER(estado) AS estado,
        UPPER(sigla) AS sigla,
        data_inclusao,
        data_atualizacao
    FROM {{ source('novadrive_bronze', 'bronze_estados') }}
)

SELECT
    id_estados,
    estado,
    sigla,
    data_inclusao,
    data_atualizacao
FROM source
