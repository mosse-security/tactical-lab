#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1 - Process the Windows Schema.
; Check a property that is part of the Windows Schema and exists for every user.
; *****************************************************************************
Global $sProperty = "displayname"
If _AD_ObjectExistsInSchema($sProperty) Then
	MsgBox(64, "Active Directory Functions", "Property '" & $sProperty & "' does exist in the Windows AD Schema")
Else
	MsgBox(64, "Active Directory Functions", "Property '" & $sProperty & "' does not exist in the Windows AD Schema")
EndIf

; *****************************************************************************
; Example 2 - Process the Exchange Schema.
; Check a property that is part of the Exchange Schema and exists for every user.
; *****************************************************************************
$sProperty = "mailNickname"
If _AD_ObjectExistsInSchema($sProperty) Then
	MsgBox(64, "Active Directory Functions", "Property '" & $sProperty & "' does exist in the Exchange AD Schema")
Else
	MsgBox(64, "Active Directory Functions", "Property '" & $sProperty & "' does not exist in the Exchange AD Schema")
EndIf

; *****************************************************************************
; Example 3 - Query a non existent property.
; *****************************************************************************
$sProperty = "non-existing-property"
If _AD_ObjectExistsInSchema($sProperty) Then
	MsgBox(64, "Active Directory Functions", "Property '" & $sProperty & "' does exist in the AD Schema")
Else
	MsgBox(64, "Active Directory Functions", "Property '" & $sProperty & "' does not exist in the AD Schema")
EndIf

; Close Connection to the Active Directory
_AD_Close()