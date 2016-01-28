#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1
; Get last login date for current user. Returned as YYYYMMDDHHMMSS
; *****************************************************************************
Global $iLLDate = _AD_GetLastLoginDate()
MsgBox(64, "Active Directory Functions - Example 1", "Last Login Date for User '" & @UserName & "'" & @CRLF & $iLLDate)

; *****************************************************************************
; Example 2
; Get last login date for current computer. Returned as YYYYMMDDHHMMSS
; *****************************************************************************
$iLLDate = _AD_GetLastLoginDate(@ComputerName & "$")
MsgBox(64, "Active Directory Functions - Example 2", "Last Login Date for Computer '" & @ComputerName & "$'" & @CRLF & $iLLDate)

; Close Connection to the Active Directory
_AD_Close()