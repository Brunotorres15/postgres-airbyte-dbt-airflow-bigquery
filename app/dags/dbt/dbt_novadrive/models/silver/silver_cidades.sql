{{ config(materialized='table', schema='silver') }}
WITH source AS (
    SELECT
        id_cidades,
        INITCAP(cidade) AS nome_cidade, 
        id_estados,
        data_inclusao,
        COALESCE(data_atualizacao, TIMESTAMP(data_inclusao)) AS data_atualizacao 
    FROM {{ source('novadrive_bronze', 'bronze_cidades') }}
)

SELECT
    id_cidades,
    nome_cidade,
    id_estados,
    data_inclusao,
    data_atualizacao
FROM source
