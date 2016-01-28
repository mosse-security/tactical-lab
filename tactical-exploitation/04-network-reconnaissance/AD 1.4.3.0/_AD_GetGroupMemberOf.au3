#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Returns a list of group membership (FQDN) for a group
; *****************************************************************************
#include <AD.au3>

Global $aGroups, $aMemberOf[1]

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; Get an array of group names (FQDN) that the user is immediately a member of with element 0 containing the number of groups.
$aGroups = _AD_GetUserGroups()

; Get a sorted list of membership for the first group the currently logged on user is a member of
$aMemberOf = _AD_GetGroupMemberOf($aGroups[1])
_ArraySort($aMemberOf, 0, 1)
_ArrayDisplay($aMemberOf, "Active Directory Functions - Example 1 - Membership for group '" & $aGroups[1] & "'")

; Close Connection to the Active Directory
_AD_Close()