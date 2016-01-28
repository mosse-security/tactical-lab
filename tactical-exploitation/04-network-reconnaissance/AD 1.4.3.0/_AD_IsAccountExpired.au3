#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1
; Checks if the current user account is expired.
; *****************************************************************************
Global $iResult = _AD_IsAccountExpired()
If @error Then
	MsgBox(16, "Active Directory Example Skript", "Function _AD_IsAccountExpired encountered a problem. @error = " & @error & ", @extended = " & @extended)
ElseIf $iResult = 1 Then
	MsgBox(64, "Active Directory Functions", "User account '" & @UserName & "' has expired")
Else
	MsgBox(64, "Active Directory Functions", "User account '" & @UserName & "' has not expired")
EndIf

; *****************************************************************************
; Example 2
; Checks if the current computer account is expired.
; *****************************************************************************
$iResult = _AD_IsAccountExpired(@ComputerName & "$")
If @error Then
	MsgBox(16, "Active Directory Example Skript", "Function _AD_IsAccountExpired encountered a problem. @error = " & @error & ", @extended = " & @extended)
ElseIf $iResult = 1 Then
	MsgBox(64, "Active Directory Functions", "Computer account '" & @ComputerName & "$" & "' has expired")
Else
	MsgBox(64, "Active Directory Functions", "Computer account '" & @ComputerName & "$" & "' has not expired")
EndIf

; Close Connection to the Active Directory
_AD_Close()

