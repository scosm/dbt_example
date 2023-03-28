
-- This model definition pulls in some sample data from a source in another database.
-- It produces a table that is our sample data to work with in our dbt example.

{{ config(materialized='table') }}

with source_sample_data as (
    -- https://docs.getdbt.com/reference/dbt-jinja-functions/source
    select * from {{ source('sample_data_source__impressions_usage', 'GAE_IMPRESSIONS_USAGE') }}
),
final as (
    select * from source_sample_data
)

select * from final

