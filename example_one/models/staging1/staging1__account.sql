
-- Pull data from the sample data into the staging layer.

-- Make a table, not a view, for this particular model.
-- https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations
{{ config(materialized='table') }}

with staging_data as (
    -- https://docs.getdbt.com/reference/dbt-jinja-functions/source
    select * from {{ source('staging1_source__account', 'staging0__account') }}
),
final as (
    select
        *
        ,lower(split_part(email, '@', 1)) as username   -- Postgres version of split; cf. SQL Server: string_split().
        ,lower(split_part(email, '@', 2)) as domainname
    from staging_data
)
select * from final

