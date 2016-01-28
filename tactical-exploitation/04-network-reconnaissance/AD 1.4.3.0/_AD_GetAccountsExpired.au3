#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $aExpired[1]
; *****************************************************************************
; Example 1
; Get a list of expired user accounts
; *****************************************************************************
$aExpired = _AD_GetAccountsExpired()
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "No expired user accounts could be found")
Else
	_ArrayDisplay($aExpired, "Active Directory Functions - Example 1 - Expired User Accounts")
EndIf

; *****************************************************************************
; Example 2
; Get a list of user accounts that expire end of this year
; *****************************************************************************
$aExpired = _AD_GetAccountsExpired("user", @YEAR & "/12/31")
If @error = 0 Then
	_ArrayDisplay($aExpired, "Active Directory Functions - Example 2 - Expired User Accounts (by the end of this year)")
ElseIf @error = 1 Then
	MsgBox(64, "Active Directory Functions - Example 2", "No expired user accounts could be found")
Else
	MsgBox(64, "Active Directory Functions - Example 2", "Invalid parameters provided")
EndIf

; *****************************************************************************
; Example 3
; Get a list of user accounts that expire between january and october this year
; *****************************************************************************
$aExpired = _AD_GetAccountsExpired("user", @YEAR & "/10/31", @YEAR & "/01/01")
If @error = 0 Then
	_ArrayDisplay($aExpired, "Active Directory Functions - Example 3 - Expired User Accounts (january to october this year)")
ElseIf @error = 1 Then
	MsgBox(64, "Active Directory Functions - Example 3", "No expired user accounts could be found")
Else
	MsgBox(64, "Active Directory Functions - Example 3", "Invalid parameters provided")
EndIf

; *****************************************************************************
; Example 4
; Get a list of expired computer accounts
; *****************************************************************************
$aExpired = _AD_GetAccountsExpired("computer")
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 4", "No expired computer accounts could be found")
Else
	_ArrayDisplay($aExpired, "Active Directory Functions - Example 4 - Expired Computer Accounts")
EndIf

; Close Connection to the Active Directory
_AD_Close()