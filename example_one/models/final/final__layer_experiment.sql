
-- Pull data from the sample data into the staging layer.

-- Make a table, not a view, for this particular model.
-- https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations
{{ config(materialized='table') }}

with staging_data as (
    -- https://docs.getdbt.com/reference/dbt-jinja-functions/source
    select * from {{ source('final_source__layer_experiment', 'staging1__layer_experiment') }}
),
final as (
    select
        layer_experiment_id
        ,layer_id
        ,project_id
        ,status
        ,created
        ,last_modified
        ,experiment_type
        ,layer_experiment_name
        ,is_archived
        ,is_launched
    from staging_data
)
select * from final

