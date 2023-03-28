
-- This model definition pulls in some sample data from a source in another database.
-- It produces a table that is our sample data to work with in our dbt example.

{{ config(materialized='table') }}

with source_sample_data as (
    -- https://docs.getdbt.com/reference/dbt-jinja-functions/source
    select * from {{ source('sample_data_source__account', 'CUST_GAE_ACCOUNT') }}
),
final as (
    select
        *
        ,created_gae::timestamp as created_gae_timestamp
        ,created::timestamp as created_timestamp
    from source_sample_data
)
select * from final

