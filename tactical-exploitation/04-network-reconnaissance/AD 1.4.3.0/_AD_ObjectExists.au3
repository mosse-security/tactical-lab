#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1 - Process the current user.
; In the first step get some attributes of the current user.
; In the second step check the user for this attributes.
; *****************************************************************************

; Get some information for the current logged on user we later can test
Global $asProperties[8] = ["sAMAccountName", "cn", "mail", "userPrincipalName", "name", "mailNickname", "displayName", "dNSHostName"]
Global $asObjects[8], $iCount

For $iCount = 0 To UBound($asObjects) - 1
	$asObjects[$iCount] = _AD_GetObjectAttribute(@UserName, $asProperties[$iCount])
Next

; Test for the information we gathered above
Global $sOutput = "Get Attributes for User: " & @UserName & @CRLF & @CRLF
For $iCount = 0 To UBound($asObjects) - 1
	If _AD_ObjectExists($asObjects[$iCount], $asProperties[$iCount]) Then
		$sOutput &= "Object '" & $asObjects[$iCount] & "' for property '" & $asProperties[$iCount] & "' exists" & @CRLF
	ElseIf @error = 1 Then
		$sOutput &= "Object '" & $asObjects[$iCount] & "' for property '" & $asProperties[$iCount] & "' does not exist" & @CRLF
	Else
		$sOutput &= "Object '" & $asObjects[$iCount] & "' for property '" & $asProperties[$iCount] & "' is not unique: >=" & @error & " records found" & @CRLF
	EndIf
Next
MsgBox(64, "Active Directory Functions", $sOutput)

; *****************************************************************************
; Example 2 - Process the computer running the script.
; In the first step get some attributes of the computer.
; In the second step check the computer for this attributes.
; *****************************************************************************

; Get some information for the computer running the script
Global $asProperties[7] = ["sAMAccountName", "operatingSystem", "operatingSystemVersion", "operatingSystemServicePack", "name", "dNSHostName", "displayName"]

For $iCount = 0 To UBound($asProperties) - 1
	$asObjects[$iCount] = ""
	$asObjects[$iCount] = _AD_GetObjectAttribute(@ComputerName & "$", $asProperties[$iCount])
Next

; Test for the information we gathered above
$sOutput = "Get Attributes for Computer: " & @ComputerName & @CRLF & @CRLF
For $iCount = 0 To UBound($asProperties) - 1
	If _AD_ObjectExists($asObjects[$iCount], $asProperties[$iCount]) Then
		$sOutput &= "Object '" & $asObjects[$iCount] & "' for property '" & $asProperties[$iCount] & "' exists" & @CRLF
	ElseIf @error = 1 Then
		$sOutput &= "Object '" & $asObjects[$iCount] & "' for property '" & $asProperties[$iCount] & "' does not exist" & @CRLF
	Else
		$sOutput &= "Object '" & $asObjects[$iCount] & "' for property '" & $asProperties[$iCount] & "' is not unique: >=" & @error & " records found" & @CRLF
	EndIf
Next
MsgBox(64, "Active Directory Functions", $sOutput)

; *****************************************************************************
; Example 3 - Checks an Organizational Unit (OU) for existance.
; Get the primary group for the current user and then check for existance.
; *****************************************************************************
Global $sOU = _AD_GetUserPrimaryGroup()
If _AD_ObjectExists($sOU, "distinguishedName") Then
	MsgBox(64, "Active Directory Functions", "OU '" & $sOU & "' exists")
Else
	MsgBox(64, "Active Directory Functions", "OU '" & $sOU & "' does not exist")
EndIf

; Close Connection to the Active Directory
_AD_Close()