
-- Pull data from the sample data into the staging layer.

-- Make a table, not a view, for this particular model.
-- https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations
{{ config(materialized='table') }}

with staging_data as (
    -- https://docs.getdbt.com/reference/dbt-jinja-functions/source
    select * from {{ source('staging1_source__impressions_usage', 'staging0__impressions_usage') }}
),
final as (
    select
        *
    from staging_data
)
select * from final

