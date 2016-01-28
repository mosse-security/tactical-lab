#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1
; Get the Fully Qualified Domain Name (FQDN) for the current User
; *****************************************************************************
Global $sFQDN = _AD_SamAccountNameToFQDN()
MsgBox(64, "Active Directory Functions - Example 1", "The Fully Qualified Domain Name (FQDN) for the currently logged on user is: " & @CRLF & $sFQDN)

; *****************************************************************************
; Example 2
; Get the Fully Qualified Domain Name (FQDN) for the computer running this script
; A $ sign has to be appended to the computer name to create a correct sAMAccountName
; *****************************************************************************
$sFQDN = _AD_SamAccountNameToFQDN(@ComputerName & "$")
MsgBox(64, "Active Directory Functions - Example 2", "The Fully Qualified Domain Name (FQDN) for this computer is: " & @CRLF & $sFQDN)

; Close Connection to the Active Directory
_AD_Close()