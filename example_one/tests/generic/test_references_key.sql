
-- This implements the same test as the "relationships" built-in generic test.
-- The respective models must have an "column_name" field and a "target_key_name" field.

{% test references_key(model, column_name, target_model, target_key_name) %}

with key_source as (
    select {{ column_name }} as key
    from {{ model }}
),
key_target as (
    select {{ target_key_name }} as key
    from {{ target_model }}
),
validation_errors as (

    select s.key
    from key_source s
    left outer join key_target t
        on s.key = t.key
    where
        t.key is null

)
select *
from validation_errors

{% endtest %}

