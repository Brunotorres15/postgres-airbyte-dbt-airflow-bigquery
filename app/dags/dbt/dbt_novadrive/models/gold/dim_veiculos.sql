{{ config(materialized='table', schema='gold') }}
SELECT
    {{ dbt_utils.generate_surrogate_key(['id_veiculos']) }} as sk_veiculo_id,
    id_veiculos AS veiculo_id,
    nome AS nome_veiculo,
    tipo,
    valor AS valor_sugerido,
    data_atualizacao,
    data_inclusao
FROM {{ source('novadrive_silver','silver_veiculos') }}
