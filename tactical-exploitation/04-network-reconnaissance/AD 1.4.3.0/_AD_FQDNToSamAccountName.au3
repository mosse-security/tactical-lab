#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; ********************************************************************************
; Example 1 - Process the current user.
; Get the FQDN from the SamAccountname. Then get the SamAccountName from the FQDN.
; ********************************************************************************
; Get the Fully Qualified Domain Name (FQDN) for the current User
Global $sFQDN = _AD_SamAccountNameToFQDN()

; Get the sAMAccountName from the Fully Qualified Domain Name (FQDN) for the current User
Global $sSamAccountName = _AD_FQDNToSamAccountName($sFQDN)

MsgBox(64, "Active Directory Functions - Example 1", "The Fully Qualified Domain Name (FQDN) for the currently logged on user is: " & @CRLF & $sFQDN & @CRLF & @CRLF & _
		"The Security Accounts Manager (SAM) Account Name (SamAccountName) for the current logged on user is: " & @CRLF & $sSamAccountName)

; ********************************************************************************
; Example 2 - Process the computer running the script.
; Get the FQDN from the SamAccountname. Then get the SamAccountName from the FQDN.
; ********************************************************************************
; Get the Fully Qualified Domain Name (FQDN) for the computer running the script
$sFQDN = _AD_SamAccountNameToFQDN(@ComputerName & "$")

; Get the sAMAccountName from the Fully Qualified Domain Name (FQDN) for the computer running the script
$sSamAccountName = _AD_FQDNToSamAccountName($sFQDN)

MsgBox(64, "Active Directory Functions - Example 2", "The Fully Qualified Domain Name (FQDN) for this computer is: " & @CRLF & $sFQDN & @CRLF & @CRLF & _
		"The Security Accounts Manager (SAM) Account Name (SamAccountName) for this computer is: " & @CRLF & $sSamAccountName)

; Close Connection to the Active Directory
_AD_Close()