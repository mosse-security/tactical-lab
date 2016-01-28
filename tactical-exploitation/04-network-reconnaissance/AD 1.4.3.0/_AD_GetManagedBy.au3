#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $aManagedBy[1][2]
Global $bNotFound = False
; *****************************************************************************
; Example 1
; Get a list of groups that have the attribute "managedBy" set
; *****************************************************************************
$aManagedBy = _AD_GetManagedBy()
If @error > 0 Or $aManagedBy[0][0] = 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "No managed groups could be found")
	$bNotFound = True
Else
	_ArrayDisplay($aManagedBy, "Active Directory Functions - Example 1 - groups managed by")
EndIf

; *****************************************************************************
; Example 2
; Get a list of groups that are managed by the first manager found in example 1
; *****************************************************************************
If $bNotFound Then
	MsgBox(64, "Active Directory Functions - Example 2", "Can't run example 2 because example 1 returned no data")
	Exit
EndIf
Global $Result = _AD_GetObjectAttribute(_AD_FQDNToSamAccountName($aManagedBy[1][1]), "managedObjects")
_ArrayDisplay($Result, "Active Directory Functions - Example 2 - groups managed by '" & $aManagedBy[1][1] & "'")

; Close Connection to the Active Directory
_AD_Close()