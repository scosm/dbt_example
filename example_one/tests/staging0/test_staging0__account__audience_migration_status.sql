

select
    audience_migration_status
from staging0.staging0__account
where
    audience_migration_status != 'Done'
