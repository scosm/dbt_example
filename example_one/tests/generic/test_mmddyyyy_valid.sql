
-- Validates if the column matches a valid date of form mmddyyyy.

{% test mmddyyyy_valid(model, column_name) %}

with source as (
    select {{ column_name }} as mmddyyyy
    from {{ model }}
),
filtered as (
    select
        -- Postgres substring() is 1-based in indexing chars in strings.
        -- If this string-int parsing fails, the test will show a SQL error... which we will see.
        to_number(substring(mmddyyyy, 1, 2), '99') as mm
        ,to_number(substring(mmddyyyy, 3, 2), '99') as dd
        ,to_number(substring(mmddyyyy, 5, 4), '9999') as yyyy
    from source
),
limited as (
    select
        mm
        ,dd
        ,yyyy
    from filtered
    where
        -- Check days in a month.
        (mm < 1 or mm > 12) or (dd < 1 or dd > 31)
        or
        (mm = 2 and dd > 29) or
        (mm = 2and mod(yyyy, 100) != 0 and mod(yyyy, 4) = 0 and dd > 28) or -- Leap years, for years not century years (which must be divisible by 400).
        (mm = 2 and mod(yyyy, 100) = 0 and mod(yyyy, 400) = 0 and dd > 28) -- Leap years that are centuries: must be divisible by 400.
        or
        (mm in (4, 6, 9, 11) and dd > 30)
        or
        -- Check a reasonable year.
        (yyyy < 2015) or yyyy > year(current_date)
),
validation_errors as (
    select mm, dd, yyyy
    from limited
)
select *
from validation_errors

{% endtest %}

