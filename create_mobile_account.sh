#!/bin/bash

# I steal things from the internet and then fail at making them better.
#
# Matt Carr
# matt.carr@utexas.edu
#

#Variables for Cocoa Dialog
CD="/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog"
CDI="/Applications/Utilities/CocoaDialog.app/Contents/Resources"

#Input box asking for users Account
CDInput=`$CD inputbox \
	--title "Input User EID for $HOSTNAME" \
	--button1 "Ok" --button2 "Cancel"`

if [ "$CDInput" == "2" ]; then
			exit 0
else

#Cleaning up the input for later
EID=$(echo $CDInput | cut -d" " -f2)

#Check to see if the machine is bound to the Austin Domain, if it isn't then bind it.
dsconfigad -show | grep "austin.utexas.edu"
IsBound=$(echo $?)
if [ $IsBound -eq 1 ]; then
	
echo "Not bound to the domain, rerun ad bind workflow in Deploy Studio"	

fi

# Create Mobile Account
echo "Creating mobile account"
sudo /System/Library/CoreServices/ManagedClient.app/Contents/Resources/createmobileaccount -n $EID


#Check to see if the account was created
dscl . list /Users | grep "$EID"
out=$(echo $?)

if [ $out -eq 0 ]; then
	echo "Account was created properly, continuing on."
	
else
	echo "The Mobile Account Failed. Check the EID"
	#Prompt if there is a failure
	rv=`$CD ok-msgbox --text "Mobile Account Creation Failure" \
	    --informative-text "The Mobile Account Failed. Check the EID" \
		--no-cancel \
	    --no-newline --float`
	if [ "$rv" == "1" ]; then
		exit 0
	    echo "The Mobile Account Failed. Check the EID"
	elif [ "$rv" == "2" ]; then
	    echo "Canceling"
	    exit 0
	fi

fi
	
#Create Home Directory for User
echo "Creating home directory"
sudo createhomedir -c -u $EID

if [ $out -eq 0 ] && [ -e /Users/$EID ]; then

	#Add User to Admin Group
	rv=`$CD yesno-msgbox --text "Does the user need local admin?" \
		--button1 "Yes" \
		--button2 "No" \
		--no-cancel`
	
	if [ "$rv" == "1" ]; then
		echo "We're granting Admin"	
		sudo dseditgroup -o edit -a $EID -t user admin

	else
	  	echo "We are not granting Admin"
	fi


	#Make some user friendly readouts for the name
	EIDRealName=$(dscl . -read /Users/$EID RealName)
	EIDRealNameClean=$(echo $EIDRealName | sed -e 's/RealName: //g')
  
  	#Prompt if successful
	rv=`$CD ok-msgbox --text "Mobile Account Creation Success" \
	    --informative-text "Everything checks out for $EIDRealNameClean." \
		--no-cancel \
	    --no-newline --float`
	if [ "$rv" == "1" ]; then
	    echo "Everything checks out."
	elif [ "$rv" == "2" ]; then
	    echo "Canceling"
	    exit 0
	fi

else
	
	#Prompt if there is a failure
	rv=`$CD ok-msgbox --text "Mobile Account Creation Failure" \
	    --informative-text "Something broke, check the logs." \
		--no-cancel \
	    --no-newline --float`
	if [ "$rv" == "1" ]; then
	    echo "Something broke."
	elif [ "$rv" == "2" ]; then
	    echo "Canceling"
	    exit 0
	fi
	
	
fi

fi
exit 0
