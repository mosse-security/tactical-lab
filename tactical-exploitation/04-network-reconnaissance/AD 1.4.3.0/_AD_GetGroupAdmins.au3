#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Get a list of admins for the first group the current user is a member of
; *****************************************************************************
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; Get a sorted array of group names (FQDN) that the user is immediately a member of
Global $aUser
$aUser = _AD_GetUserGroups(@UserName)
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & @UserName & "' has not been assigned to any group")
	Exit
Else
	_ArraySort($aUser, 0, 1)
EndIf

; Check all groups the current user is a member of and display the first one with admins
Global $Found = False
Global $iCount, $aAdmins
For $iCount = 1 To $aUser[0]
	$aAdmins = _AD_GetGroupAdmins($aUser[$iCount])
	If @error = 0 Then
		$Found = True
		ExitLoop
	EndIf
Next
If Not $Found Then
	MsgBox(64, "Active Directory Functions - Example 1", "No admins assigned to all groups the current user is a member of")
	Exit
Else
	_ArrayDisplay($aAdmins, "Active Directory Functions - Example 1 - Admins for group '" & $aUser[$iCount] & "'")
EndIf

; Close Connection to the Active Directory
_AD_Close()