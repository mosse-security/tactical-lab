#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Get a list of all groups the current user is a member of.
; Then get a sorted list of all group members for the first group of this array.
; *****************************************************************************
#include <AD.au3>

Global $aGroups[1], $aMembers[1]

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; Get an array of group names (FQDN) that the user is immediately a member of with element 0 containing the number of groups.
$aGroups = _AD_GetUserGroups()
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "The current user is not a member of any group")
Else
	; Get a sorted list of members for the first group the currently logged on user is a member of
	$aMembers = _AD_GetGroupMembers($aGroups[1])
	If @error > 0 Then
		MsgBox(64, "Active Directory Functions - Example 1", "The group '" & $aGroups[1] & "' has no members")
	Else
		_ArraySort($aMembers, 0, 1)
		_ArrayDisplay($aMembers, "Active Directory Functions - Example 1 - List of members for group '" & $aGroups[1] & "'")
	EndIf
EndIf

; Close Connection to the Active Directory
_AD_Close()