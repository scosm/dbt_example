

select u.account_id
from staging0.staging0__usage u
left outer join staging0.staging0__account a
    on u.account_id = a.account_id
where
    a.account_id is null

