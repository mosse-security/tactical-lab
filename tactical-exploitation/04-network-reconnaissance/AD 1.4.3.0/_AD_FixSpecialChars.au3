#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>
Global $sString
Global $sEscapedString, $sUnEscapedString

; *****************************************************************************
; Example 1
; Escape all special characters from a string
; *****************************************************************************
$sString = "Firstname, Lastname (Alias=xxx) (Department/Team)"
$sEscapedString = _AD_FixSpecialChars($sString)
MsgBox(16, "Active Directory Functions - Example 1", "Unescaped string: " & $sString & @CRLF & "Escaped string: " & $sEscapedString)

; *****************************************************************************
; Example 2
; Escape only some characters from a string
; *****************************************************************************
$sString = "Firstname, Lastname (Alias=xxx) (Department/Team)"
$sEscapedString = _AD_FixSpecialChars($sString, 0, ",/")
MsgBox(16, "Active Directory Functions - Example 2", "Unescaped string: " & $sString & @CRLF & "Escaped string: " & $sEscapedString)

; *****************************************************************************
; Example 3
; UnEscape all special characters from a string
; *****************************************************************************
$sString = "Firstname\, Lastname (Alias\=xxx) (Department\/Team)"
$sUnEscapedString = _AD_FixSpecialChars($sString, 1)
MsgBox(16, "Active Directory Functions - Example 3", "Escaped string: " & $sString & @CRLF & "UnEscaped string: " & $sUnEscapedString)

; *****************************************************************************
; Example 4
; UnEscape only some characters from a string
; *****************************************************************************
$sString = "Firstname\, Lastname (Alias\=xxx) (Department\/Team)"
$sUnEscapedString = _AD_FixSpecialChars($sString, 1, ",/")
MsgBox(16, "Active Directory Functions - Example 4", "Escaped string: " & $sString & @CRLF & "UnEscaped string: " & $sUnEscapedString)