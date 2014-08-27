#!/usr/local/bin/expect -f

# I steal things from the internet and then fail at making them better.
#
# Matt Carr
# matt.carr@utexas.edu
#
# In conjunction with a logout script that bypasses the filevault login screen.

auth_pass="YOURPASSWORD"
spawn sudo fdesetup -authrestart 
expect  ":"
send $auth_pass
expect eof

exit 0
