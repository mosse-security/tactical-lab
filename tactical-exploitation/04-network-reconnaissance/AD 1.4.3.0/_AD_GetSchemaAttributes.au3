#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1
; Return all attributes that get propagated to the Global Catalog
; *****************************************************************************
Global $aResult = _AD_GetSchemaAttributes(2)
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Error getting attributes. @error = " & @error & ", @extended = " & @extended)
Else
	_ArrayDisplay($aResult, "Active Directory Functions - Example 1 - Attributes propagated to the Global Catalog")
EndIf

; *****************************************************************************
; Example 2
; Return all attributes that are indexed (and therefore give better search performance)
; *****************************************************************************
$aResult = _AD_GetSchemaAttributes(3)
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 2", "Error getting attributes. @error = " & @error & ", @extended = " & @extended)
Else
	_ArrayDisplay($aResult, "Active Directory Functions - Example 1 - Indexed attributes")
EndIf

; Close Connection to the Active Directory
_AD_Close()