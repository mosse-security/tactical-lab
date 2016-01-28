#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1
; Test for a multi-value attribute
; *****************************************************************************
Global $aResult = _AD_GetObjectAttribute(@UserName, "proxyAddresses")
If @error Then
	MsgBox(64, "Active Directory Functions - Example 1", "Attribute 'proxyAddresses' for user '" & @UserName & "' could not be found")
Else
	_ArrayDisplay($aResult, "Active Directory Functions - Example 1 - User '" & @UserName & "', Attribute 'proxyAddresses'")
EndIf

; *****************************************************************************
; Example 2
; Test for a single-value attribute
; *****************************************************************************
$aResult = _AD_GetObjectAttribute(@UserName, "mail")
If @error Then
	MsgBox(64, "Active Directory Functions - Example 2", "Attribute 'mail' for user '" & @UserName & "' could not be found")
Else
	MsgBox(64, "Active Directory Functions - Example 2", _
			"String returned for User '" & @UserName & "', Attribute 'mail': " & $aResult)
EndIf

; Close Connection to the Active Directory
_AD_Close()