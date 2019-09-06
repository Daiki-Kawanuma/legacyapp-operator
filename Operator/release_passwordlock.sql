UPDATE hirarin.users
SET
    locked_flag = '0',
	unlock_target_flag = '0'
WHERE last_login_date < (now() - INTERVAL '30 MINUTE')
    AND locked_flag = '1'
    AND unlock_target_flag = '1'