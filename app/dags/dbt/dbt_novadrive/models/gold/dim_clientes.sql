{{ config(materialized='table', schema='gold') }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['id_clientes']) }} as sk_client_id,
    id_clientes AS cliente_id,
    cliente AS nome_cliente,
    endereco,
    id_concessionarias AS concessionaria_id,
    data_inclusao,
    data_atualizacao
FROM {{ source('novadrive_silver','silver_clientes') }}
