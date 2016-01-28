#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1
; Checks if the password for the current user is expired.
; *****************************************************************************
If _AD_IsPasswordExpired() Then
	MsgBox(64, "Active Directory Functions", "Password for user '" & @UserName & "' has expired")
Else
	MsgBox(64, "Active Directory Functions", "Password for user '" & @UserName & "' has not expired")
EndIf

; *****************************************************************************
; Example 2
; Get a list of accounts for which the password has expired and check the first entry
; *****************************************************************************
Global $aExpired = _AD_GetPasswordExpired()
If @error = 0 Then
	Global $sUser = _AD_FQDNToSamAccountName($aExpired[1])
	If _AD_IsPasswordExpired($sUser) Then
		MsgBox(64, "Active Directory Functions", "Password for user '" & $sUser & "' has expired")
	Else
		MsgBox(64, "Active Directory Functions", "Password for user '" & $sUser & "' has not expired")
	EndIf
Else
	MsgBox(64, "Active Directory Functions", "No expired user passwords found")
EndIf

; Close Connection to the Active Directory
_AD_Close()