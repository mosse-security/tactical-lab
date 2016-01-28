#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Returns an array of user accounts for which the password will not expire
; *****************************************************************************
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; Returns an array of user accounts for which the password will not expire
Global $aNotExpire[1]
$aNotExpire = _AD_GetPasswordDontExpire()
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "No user accounts for which the password will not expire could be found")
Else
	_ArrayDisplay($aNotExpire, "Active Directory Functions - Example 1 - User accounts for which the password will not expire")
EndIf

; Close Connection to the Active Directory
_AD_Close()