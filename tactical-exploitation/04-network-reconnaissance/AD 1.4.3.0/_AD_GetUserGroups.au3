#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Get a sorted array of group names (FQDN) that the user is immediately a
; member of.
; *****************************************************************************
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; Get a sorted array of group names (FQDN) that the user is immediately a member of
Global $aUser = _AD_GetUserGroups(@UserName)
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & @UserName & "' has not been assigned to any group")
Else
	_ArraySort($aUser, 0, 1)
	_ArrayDisplay($aUser, "Active Directory Functions - Example 1 - Group names user '" & @UserName & "' is immediately a member of")
EndIf

; Close Connection to the Active Directory
_AD_Close()