#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Open a connection to the Active Directory; get the Fully Qualified Domain
; Name (FQDN) for the current user; close the connection.
; *****************************************************************************
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; Get the Fully Qualified Domain Name (FQDN) for the current User
Global $sFQDN = _AD_SamAccountNameToFQDN()
MsgBox(64, "Active Directory Functions - Example 1", "The Fully Qualified Domain Name (FQDN) for the currently logged on user is: " & @CRLF & $sFQDN)

; Close Connection to the Active Directory
_AD_Close()