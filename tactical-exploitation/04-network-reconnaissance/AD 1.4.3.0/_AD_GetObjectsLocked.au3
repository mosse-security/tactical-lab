#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $aLocked[1][2]
; *****************************************************************************
; Example 1
; Get a list of locked accounts
; *****************************************************************************
$aLocked = _AD_GetObjectsLocked()
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "No locked user accounts have been found. Error: " & @error)
Else
	_ArrayDisplay($aLocked, "Active Directory Functions - Example 1 - Locked User Accounts")
EndIf

; *****************************************************************************
; Example 2
; Get a list of locked computers
; *****************************************************************************
$aLocked = _AD_GetObjectsLocked("computer")
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 2", "No locked computers have been found")
Else
	_ArrayDisplay($aLocked, "Active Directory Functions - Example 2 - Locked Computers")
EndIf

; Close Connection to the Active Directory
_AD_Close()