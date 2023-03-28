
-- Check that admin_account_id is among the account_id values (a valid account_id).
select u.admin_account_id
from final.final__account u
left outer join final.final__account v
    on u.admin_account_id = v.account_id
where
    v.account_id is null

