#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1
; Get a list of all OUs in the Active Directory
; *****************************************************************************
Global $aOUs = _AD_GetAllOUs()
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "No OUs could be found " & @error)
Else
	_ArrayDisplay($aOUs, "Active Directory Functions - Example 1 - All OUs found in the Active Directory")
EndIf

; Close Connection to the Active Directory
_AD_Close()
