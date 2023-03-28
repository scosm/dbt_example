
-- Pull data from the sample data into the staging layer.

-- Make a table, not a view, for this particular model.
-- https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations
{{ config(materialized='table') }}

with staging_data as (
    -- https://docs.getdbt.com/reference/dbt-jinja-functions/source
    select * from {{ source('final_source__account', 'staging1__account') }}
),
domains as (
    select * from {{ ref('domains') }}  -- How to refer to table that is seeds csv data.
),
final as (
    -- Take a subset of columns.
    select
        account_id
        ,account_type
        ,admin_account_id
        ,created
        ,last_modified
        ,username
        ,domainname
        ,include_geotargeting
        ,ip_anonymization
        ,project_name
        ,project_status
        ,project_platforms
        ,company_name
        ,plan_id
        ,account_name
        ,primary_subscription_id
        ,d.country
        ,d.currency
        ,d.currency_old
    from staging_data s
    left outer join domains d
        on s.domainname = d.domain
)
select * from final

