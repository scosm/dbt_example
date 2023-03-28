
-- Pull data from the sample data into the staging layer.

-- Make a table, not a view, for this particular model.
-- https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations
{{ config(materialized='table') }}

-- Use CTEs to pull the sources (encapsulate from transformation).
with staging_usage as (
    -- https://docs.getdbt.com/reference/dbt-jinja-functions/source
    select *
    from {{ source('final_source__usage', 'staging1__usage') }}
),
staging_account as (
    select *
    from {{ source('final_source__account', 'staging1__account') }}
),
-- Partially denormalize
join_usage_account as (
    select u.*
        ,a.admin_account_id
        ,a.project_name
        ,a.primary_subscription_id
    from staging_usage u
    left outer join staging_account a
        on u.account_id = a.account_id
),
final as (
    select
        account_id
        ,calculated_cost_in_cents
        ,quantity
        ,reported_quantity
        ,subscription_id
        ,usage_by_platform
        ,usage_by_project
        ,usage_id
        -- Three added fields:
        ,split_part(charge_tag, '+', 1) as charge_tag_account_id
        ,split_part(charge_tag, '+', 2) as charge_tag_product_id
        ,split_part(charge_tag, '+', 3) as charge_tag_mmddyyyy
        ,created
        ,last_modified
        ,product_id
        ,push_status
        ,lower(uom) as uom
        -- Three added fields:
        ,admin_account_id
        ,project_name
        ,primary_subscription_id
    from join_usage_account
)
select * from final

