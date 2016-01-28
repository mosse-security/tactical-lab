#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Get a list of all FSMO Role Owners
; *****************************************************************************
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; Get a list of all FSMO Role Owners plus description
Global $aFSMO[6][2] = [[""],["Domains PDC Emulator"],["Domains RID (Relative-Identifierer) master"],["Domains Infrastructure master"],["Forest-wide Schema master"],["Forest-wide Domain naming master"]]
Global $aTemp = _AD_ListRoleOwners()
Global $iCount
For $iCount = 1 To $aTemp[0]
	$aFSMO[$iCount][1] = $aTemp[$iCount]
Next
$aFSMO[0][0] = $aTemp[0]
_ArrayDisplay($aFSMO, "Active Directory Functions - Example 1"); , -1, 0, "<")

; Close Connection to the Active Directory
_AD_Close()