
-- Pull data from the sample data into the staging layer.

-- Make a table, not a view, for this particular model.
-- https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations
{{ config(materialized='table') }}

with staging_data as (
    select * from {{ source('staging1_source__usage', 'staging0__usage') }}
),
final as (
    select * from staging_data
)
select * from final

