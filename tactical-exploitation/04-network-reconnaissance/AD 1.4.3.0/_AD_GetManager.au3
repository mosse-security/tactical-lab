#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $aManager[1][2]
Global $bNotFound = False
; *****************************************************************************
; Example 1
; Get a list of users that have the attribute "manager" set
; *****************************************************************************
$aManager = _AD_GetManager()
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "No managed users could be found")
	$bNotFound = True
Else
	_ArrayDisplay($aManager, "Active Directory Functions - Example 1 - managed users")
EndIf

; *****************************************************************************
; Example 2
; Get a list of users that are managed by the first manager found in example 1
; *****************************************************************************
If $bNotFound Then
	MsgBox(64, "Active Directory Functions - Example 2", "Can't run example 2 because example 1 returned no data")
	Exit
EndIf
Global $Result = _AD_GetObjectAttribute(_AD_FQDNToSamAccountName($aManager[1][1]), "directReports")
_ArrayDisplay($Result, "Active Directory Functions - Example 2 - users managed by '" & $aManager[1][1] & "'")

; Close Connection to the Active Directory
_AD_Close()