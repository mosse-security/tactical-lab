#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1 - Process the current user.
; Get the FQDN from the SamAccountname. Then get the displayname from the FQDN.
; *****************************************************************************
; Get the Fully Qualified Domain Name (FQDN) for the current User
Global $sFQDN = _AD_SamAccountNameToFQDN()

; Get the Display Name for the current User
Global $sDisplayName = _AD_FQDNToDisplayname($sFQDN)
Switch @error
	Case 0
		MsgBox(64, "Active Directory Functions - Example 1", _
				"The Fully Qualified Domain Name (FQDN) for the currently logged on user is: " & @CRLF & $sFQDN & @CRLF & @CRLF & _
				"The Display Name for the currently logged on user is: " & @CRLF & $sDisplayName)
	Case 1
		MsgBox(48, "Active Directory Functions - Example 1", _
				"Object: " & @CRLF & $sFQDN & @CRLF & @CRLF & "could not be found!" & @CRLF & @CRLF & _
				"Error / Extended Error: " & @error & " / " & @extended)
	Case 2
		MsgBox(48, "Active Directory Functions - Example 1", _
				"Object: " & @CRLF & $sFQDN & @CRLF & @CRLF & "has no property 'displayname'." & @CRLF & @CRLF & _
				"Error / Extended Error: " & @error & " / " & @extended)
	Case Else
		MsgBox(48, "Active Directory Functions - Example 1", _
				"Unknown error returned for object: " & @CRLF & $sFQDN & @CRLF & @CRLF & _
				"Error / Extended Error: " & @error & " / " & @extended)
EndSwitch

; *****************************************************************************
; Example 2 - Process the computer running the script.
; Get the FQDN from the SamAccountname. Then get the displayname from the FQDN.
; *****************************************************************************
; Get the Fully Qualified Domain Name (FQDN) for the computer running this script
; A $ sign has to be appended to the computer name to create a correct sAMAccountName
$sFQDN = _AD_SamAccountNameToFQDN(@ComputerName & "$")

; Get the Display Name for the computer running this script
$sDisplayName = _AD_FQDNToDisplayname($sFQDN)
Switch @error
	Case 0
		MsgBox(64, "Active Directory Functions - Example 1", _
				"The Fully Qualified Domain Name (FQDN) for the currently logged on user is: " & @CRLF & $sFQDN & @CRLF & @CRLF & _
				"The Display Name for the currently logged on user is: " & @CRLF & $sDisplayName)
	Case 1
		MsgBox(48, "Active Directory Functions - Example 1", _
				"Object: " & @CRLF & $sFQDN & @CRLF & @CRLF & "could not be found!" & @CRLF & @CRLF & _
				"Error / Extended Error: " & @error & " / " & @extended)
	Case 2
		MsgBox(48, "Active Directory Functions - Example 1", _
				"Object: " & @CRLF & $sFQDN & @CRLF & @CRLF & "has no property 'displayname'." & @CRLF & @CRLF & _
				"Error / Extended Error: " & @error & " / " & @extended)
	Case Else
		MsgBox(48, "Active Directory Functions - Example 1", _
				"Unknown error returned for object: " & @CRLF & $sFQDN & @CRLF & @CRLF & _
				"Error / Extended Error: " & @error & " / " & @extended)
EndSwitch

; Close Connection to the Active Directory
_AD_Close()
