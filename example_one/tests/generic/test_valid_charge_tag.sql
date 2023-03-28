
-- charge_tag form: <account_id>+<product_id>+<mmddyyyy>

{% test valid_charge_tag(model, column_name, account_id_field, accounts_model, accounts_model_id) %}

with expanded as (
    select
        {{ column_name }} as charge_tag
        ,{{ account_id_field }} as account_id  -- Account id in the given table under test.

        -- The pieces of charge_tag.
        ,split_part({{ column_name }}, '+', 1) as charge_tag_account_id
        ,split_part({{ column_name }}, '+', 2) as charge_tag_product_id
        ,split_part({{ column_name }}, '+', 3) as charge_tag_mmddyyyy

        -- The pieces of the third part, charge_tag_mmddyyyy, and converted to integers.
        -- Postgres substring() is 1-based in indexing chars in strings.
        -- If this string-int parsing fails, the test will show a SQL error... which we will see.
        ,to_number(substring(split_part({{ column_name }}, '+', 3), 1, 2), '99') as charge_tag_mm
        ,to_number(substring(split_part({{ column_name }}, '+', 3), 3, 2), '99') as charge_tag_dd
        ,to_number(substring(split_part({{ column_name }}, '+', 3), 5, 4), '9999') as charge_tag_yyyy
    from {{ model }}
),  -- (Fon't forget these commas. Or dbt will report an irrelevant SQL parsing error.)
accounts as (
    select {{ account_id_field }} as account_id
    from {{ accounts_model }}
),
-- Above: Resolve all the Jinja references and set up the necessary fields,
-- so that below, the validation can be done on straight SQL,
-- which is cleaner, more readable, less bug prone, etc.

-- This UNION could be broken into separate tests, à la unit testing best practice (test one thing).
-- But we also want the test call just to say, "Validate charge_tag, whatever that might involve."
validation_errors as (

    -- For the UNION, fields are provided so the fields in each part are compatible.
    -- (You can't union a strings with integers, for example.)

    -- Check that the embedded account_id is valid in the accounts list(foreign key).
    select
        e.charge_tag_account_id
        ,0
    from expanded e
    left outer join accounts a
        on e.charge_tag_account_id = a.account_id
    where
        a.account_id is null

    union

    -- Check that product id is valid.
    -- TODO: There ought to be a dimension table with the product_ids, as one source of truth.
    select e.charge_tag_product_id, 0
    from expanded e
    where e.charge_tag_product_id not in ( 'ab_testing', 'ab_testing_v2', 'mobile', 'usage', 'full_stack' )

    union

    -- Check that the embedded account_id is the same as what's in the account_id column.
    select e.charge_tag_account_id, 0
    from expanded e
    where e.account_id != e.charge_tag_account_id  

    union

    -- Check that months are valid.
    select '', charge_tag_mm
    from expanded e
    where charge_tag_mm not between 1 and 12

    union

    --  Check that days are valid.
    --  TODO: Need to limit days as function of month. This is simple hack.
    select '', charge_tag_dd
    from expanded e
    where charge_tag_dd not between 1 and 31
    
    union

    -- Check that years are valid.
    select '', charge_tag_dd
    from expanded e
    where charge_tag_yyyy not between 2014 and 2022
)
select *
from validation_errors

{% endtest %}

