
-- Check that uom is lower-case, after the final__usage model transformation.
select uom
from final.final__usage
where
    uom != lower(uom)

