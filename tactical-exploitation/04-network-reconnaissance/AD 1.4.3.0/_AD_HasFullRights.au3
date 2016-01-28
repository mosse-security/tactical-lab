#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Get a list of groups the current user is a member of. Then check for the
; first group in the array if the current user has full rights for the group.
; *****************************************************************************
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; Get a list of groups the current user is a member of
Global $aMemberOf = _AD_GetUserGroups()

; Check if the current user has full rights on the first group in the array
Global $sUser = @UserName
If _AD_HasFullRights($aMemberOf[1], $sUser) Then
	MsgBox(64, "Active Directory Functions", "User '" & $sUser & "' has full rights on group '" & $aMemberOf[1] & "'")
Else
	MsgBox(64, "Active Directory Functions", "User '" & $sUser & "' does not have full rights on group '" & $aMemberOf[1] & "'")
EndIf

; Close Connection to the Active Directory
_AD_Close()