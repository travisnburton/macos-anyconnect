(*
for latest version please visit https://github.com/travisnburton/macos-anyconnect

NOTE: update 'VPNServer' variable with your VPN server address 
*)

set VPNServer to "foo.com"


-- disconnect active AnyConnect sessions
try
	do shell script "/opt/cisco/anyconnect/bin/vpn disconnect && killall \"Cisco AnyConnect Secure Mobility Client\""
end try


-- get MobilePass PIN
set getPIN to display dialog "What is your PIN?" default answer "" with hidden answer
set PIN to text returned of getPIN

-- get OTP, copy to clipboard and quit MobilePass
tell application "MobilePASS"
	activate
end tell

tell application "System Events"
	tell table 1 of scroll area 1 of window "MobilePASS" of application process "MobilePASS"
		select row 1
	end tell
	tell application process "MobilePASS"
		set value of text field 1 of window 1 to PIN
	end tell
	click button "Copy Passcode" of window "MobilePASS" of application process "MobilePASS"
end tell

tell application "MobilePASS"
	quit
end tell

-- connect to AnyConnect 
tell application "Cisco AnyConnect Secure Mobility Client"
	activate
end tell
repeat until application "Cisco AnyConnect Secure Mobility Client" is running
	delay 1
end repeat
tell application "System Events"
	repeat until (window 1 of process "Cisco AnyConnect Secure Mobility Client" exists)
		delay 1
	end repeat
	tell process "Cisco AnyConnect Secure Mobility Client"
		keystroke VPNServer as string
		keystroke return
	end tell
	delay 0.5
	repeat until (window ("Cisco AnyConnect | " & VPNServer) of process "Cisco AnyConnect Secure Mobility Client" exists)
		delay 1
	end repeat
	tell process "Cisco AnyConnect Secure Mobility Client"
		keystroke "v" using {command down}
		keystroke return
	end tell
	repeat until (window "Cisco AnyConnect - Banner" of process "Cisco AnyConnect Secure Mobility Client" exists)
		delay 1
	end repeat
	tell process "Cisco AnyConnect Secure Mobility Client"
		keystroke "v" using {command down}
		keystroke return
	end tell
end tell
