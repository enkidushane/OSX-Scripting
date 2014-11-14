#!/bin/bash

# I steal things from the internet and then fail at making them better.
#
# Matt Carr
# matt.carr@utexas.edu
#
#Custom Office 2011 Uninstaller base upon the instructions found here
#http://support.microsoft.com/kb/2398768

#variables
UserPrefs="/Users/*/Library/Preferences"
dockutil="/tmp/dockutil/dockutil"
defaultlib="/System/Library/User Template/English.lproj/Library/Preferences"

#check for sudo
if [ $EUID -eq 0 ]
then
        echo "We're running with scissors"
else
        echo "This needs to be run with root privs"
        exit 1
fi

#check to see if office is installed
if [ ! -d "/Applications/Microsoft Office 2011" ]
then
	echo "Office isn't installed, why are you running this?"
	exit 1
fi

#check to see if we're online
if eval "ping -c 1 www.google.com"
then
	echo "We're online"
	echo "Grabbing dockutil from github"
	
	#Going to use dockutil to edit the dock later.
	mkdir /tmp/dockutil
	curl https://raw.githubusercontent.com/fey-/dockutil/master/scripts/dockutil -o /tmp/dockutil/dockutil && chmod a+x /tmp/dockutil/dockutil

	#Dock Cleanup
	$dockutil --remove "Microsoft Word" --allhomes
	$dockutil --remove "Microsoft Excel" --allhomes
	$dockutil --remove "Microsoft PowerPoint" --allhomes
	$dockutil --remove "Microsoft Outlook" --allhomes
	$dockutil --remove "Microsoft AutoUpdate" --allhomes

	#Dock Cleanup for the User Template
	$dockutil --remove "Microsoft Word" --no-restart '/System/Library/User Template/English.lproj'
	$dockutil --remove "Microsoft Excel" --no-restart '/System/Library/User Template/English.lproj'
	$dockutil --remove "Microsoft PowerPoint" --no-restart '/System/Library/User Template/English.lproj'
	$dockutil --remove "Microsoft Outlook" --no-restart '/System/Library/User Template/English.lproj'
	$dockutil --remove "Microsoft AutoUpdate" --no-restart '/System/Library/User Template/English.lproj'

	#Remove DockUtil
	rm -rf /tmp/dockutil
	
else
	echo "We're offline and are not going to be able to grab dockutil, so we'll be skipping that"	
fi

#Bunch of RM Commands.
rm -rf /Applications/Microsoft\ Office\ 2011
rm -f $UserPrefs/com.microsoft.*
rm -f $DefaultLib/com.microsoft.*
rm -f /Library/PrivilegedHelperTools/com.microsoft.office.licensing.helper
rm -f /Library/Preferences/com.microsoft.office.licensing.plist
rm -f $UserPrefs/ByHost/com.microsoft.*
rm -f $DefaultLib/ByHost/com.microsoft.*
rm -rf /Library/Application\ Support/Microsoft
rm -f /private/var/db/receipts/com.microsoft.office*
rm -rf /Users/*/Library/Application\ Support/Microsoft/Office
rm -rf $DefaultLib/Application\ Support/Microsoft/Office
rm -rf '/Library/Automator/*Excel*'
rm -rf '/Library/Automator/*Office*'
rm -rf '/Library/Automator/*Outlook*'
rm -rf '/Library/Automator/*PowerPoint*'
rm -rf '/Library/Automator/*Word*'
rm -rf '/Library/Automator/Add New Sheet to Workbooks.action'
rm -rf '/Library/Automator/Create List from Data in Workbook.action'
rm -rf '/Library/Automator/Create Table from Data in Workbook.action'
rm -rf '/Library/Automator/Get Parent Presentations of Slides.action'
rm -rf '/Library/Automator/Get Parent Workbooks.action'
rm -rf '/Library/Automator/Set Document Settings.action'
rm -rf /Library/Fonts/Microsoft

#Clean up
echo "We're done here, pack it up"

exit 0
