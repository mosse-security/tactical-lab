#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $aDisabled[1]
; *****************************************************************************
; Example 1
; Get a list of disabled accounts
; *****************************************************************************
$aDisabled = _AD_GetObjectsDisabled()
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "No disabled user accounts could be found")
Else
	_ArrayDisplay($aDisabled, "Active Directory Functions - Example 1 - Disabled User Accounts")
EndIf

; *****************************************************************************
; Example 2
; Get a list of disabled computers
; *****************************************************************************
$aDisabled = _AD_GetObjectsDisabled("computer")
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 2", "No disabled computers could be found")
Else
	_ArrayDisplay($aDisabled, "Active Directory Functions - Example 2 - Disabled Computers")
EndIf

; Close Connection to the Active Directory
_AD_Close()