#!/usr/local/bin/expect -f

auth_pass="YOURPASSWORD"
spawn sudo fdesetup -authrestart 
expect  ":"
send $auth_pass
expect eof

exit 0
