#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Get a list of users that have the attribute "manager" set
; *****************************************************************************
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; Get a list of groups that have the attribute "managedBy" set
Global $bNotFound, $bFound, $iCount, $aManager
Global $aManagedBy = _AD_GetManagedBy()
If @error > 0 Or $aManagedBy[0][0] = 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "No managed groups could be found")
	$bNotFound = True
EndIf

; Check the list of groups if a manager can modify the group membership
$bFound = False
For $iCount = 1 To $aManagedBy[0][0]
	$aManager = _AD_GroupManagerCanModify($aManagedBy[1][0])
	If $aManager = 1 Then
		$bFound = True
		ExitLoop
	EndIf
Next
If Not $bFound Then
	MsgBox(64, "Active Directory Functions - Example 1", "No group manager can modify the group membership")
	Exit
Else
	MsgBox(64, "Active Directory Functions - Example 1", "Group manager can modify the group membership for group '" & $aManagedBy[$iCount][0] & "'")
EndIf

; Close Connection to the Active Directory
_AD_Close()