#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1
; Get a list of all Domain Controllers in the Active Directory
; *****************************************************************************
Global $aDC = _AD_ListDomainControllers()
_ArrayDisplay($aDC, "Active Directory Functions - Example 1 - All Domain Controllers, distinguished name, DNS host name, and the site name")

; *****************************************************************************
; Example 2
; Get a list of all Sites Names
; *****************************************************************************
_ArraySort($aDC, 0, 1, 0, 3)
Global $aSite = _ArrayUnique($aDC, 4, 1)
_ArrayDisplay($aSite, "Active Directory Functions - Example 2 - All Site Names")

; *****************************************************************************
; Example 3
; Get a list of all Read Only Domain Controllers in the Active Directory
; *****************************************************************************
$aDC = _AD_ListDomainControllers(True)
If @error <> 0 Then
	MsgBox(16, "Active Directory Functions - Example 3 - All Read Only Domain Controllers", "No RODCs found!")
Else
	_ArrayDisplay($aDC, "Active Directory Functions - Example 3 - All Read Only Domain Controllers, distinguished name, DNS host name, and the site name")
EndIf

; *****************************************************************************
; Example 4
; Get a list of all Domain Controllers inlcuding Global Catalogs
; *****************************************************************************
$aDC = _AD_ListDomainControllers(False, True)
If @error <> 0 Then
	MsgBox(16, "Active Directory Functions - Example 4 - All Domain Controllers including Global Catalogs", "No DCs found!")
Else
	_ArrayDisplay($aDC, "Active Directory Functions - Example 4 - All Domain Controllers, distinguished name, DNS host name, and the site name")
EndIf

; Close Connection to the Active Directory
_AD_Close()