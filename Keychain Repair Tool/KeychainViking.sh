#!/bin/sh

# Keychain Viking by Laeeq Humam May 2016
# Not to be used as .app. Use as standalone or packaged script


# At XWS this is here
CD="/usr/local/XWSUtils/CocoaDialog.app/Contents/MacOS/CocoaDialog"
ICNS="/usr/local/XWSUtils/CocoaDialog.app/Contents/Resources/info.icns"

# Dont bother about CocoaD, its already on Prod with customization for XWS

# Excuse me, who are you? and whats your Keychain
USER=`who | grep console | awk '{print $1}'`
KEYCHAIN=`su $USER -c "security list-keychains" | grep login | sed -e 's/\"//g' | sed -e 's/\// /g' | awk '{print $NF}'`

#rv=($($CD ok-msgbox --title "Keychain Viking" --no-newline --informative-text "Please enter your latest active password and hit Return Key. For assistance, call HelpDesk at 1105."))
#PASSWORD=${rv[1]}

# Let me copy your identity and delete your Keychain
su $USER -c "security delete-keychain $KEYCHAIN"

$CD bubble --debug --title "Keychain Viking" --text "Problematic Keychain is being deleted. Wait for 3 seconds..." \
	--background-top "e0e0e0" --background-bottom "f8f8f8" \
	--icon "info"


# Now the Viking needs your password to create a New Keychain
rv=($($CD secure-standard-inputbox --title "Keychain Viking" --no-newline --informative-text "Please enter your latest active password to create a new Keychain. For assistance, call HelpDesk at 1105."))
PASSIN=${rv[1]}

# Need help from the Commander EXPECT
expect <<- DONE
  set timeout -1
  spawn su $USER -c "security create-keychain login.keychain"
  expect "*?chain:*"
  send "$PASSIN\n"
  expect "*?chain:*"
  send "$PASSIN\r"
  expect EOF
DONE


# Assign this keychain to the account
su $USER -c "security default-keychain -s login.keychain" > /dev/null 2>&1

# ADD a line to disble both options in Keychain >> Edit >> Settings >> uncheck both

# Inform the user 
$CD bubble --debug --title "Keychain Viking" --text "A new Keychain has been created. Please continue using your Mac." \
	--background-top "e0e0e0" --background-bottom "f8f8f8" \
	--icon "info"
### ADD KEYCHAIN UNLOCKING AFTER 5mins
