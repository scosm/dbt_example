
-- Pull data from the sample data into the staging layer.

-- Make a table, not a view, for this particular model.
-- https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations
{{ config(materialized='table') }}

with staging_data as (
    -- https://docs.getdbt.com/reference/dbt-jinja-functions/source
    select * from {{ source('final_source__impressions_usage', 'staging1__impressions_usage') }}
),
final as (
    -- Take a subset of columns.
    select
        account_id
        ,project_id
        ,experiment_id
        ,project_type
        ,impression_count
        ,e3_impression_count
        ,e3_impression_deduped_count
    from staging_data
)
select * from final

