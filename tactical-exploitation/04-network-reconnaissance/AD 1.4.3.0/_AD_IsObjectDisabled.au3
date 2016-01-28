#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1
; Checks if the account for the current user is disabled.
; *****************************************************************************
If _AD_IsObjectDisabled() Then
	MsgBox(64, "Active Directory Functions", "User account '" & @UserName & "' is disabled")
Else
	MsgBox(64, "Active Directory Functions", "User account '" & @UserName & "' is not disabled")
EndIf

; *****************************************************************************
; Example 2
; Get a list of disabled accounts and checks the first entry
; *****************************************************************************
Global $aDisabled = _AD_GetObjectsDisabled()

If $aDisabled[0] > 0 Then
	Global $sUser = _AD_FQDNToSamAccountName($aDisabled[1])
	If _AD_IsObjectDisabled($sUser) Then
		MsgBox(64, "Active Directory Functions", "User account '" & $sUser & "' is disabled")
	Else
		MsgBox(64, "Active Directory Functions", "User account '" & $sUser & "' is not disabled")
	EndIf
Else
	MsgBox(64, "Active Directory Functions", "No disabled users accounts found")
EndIf

; Close Connection to the Active Directory
_AD_Close()