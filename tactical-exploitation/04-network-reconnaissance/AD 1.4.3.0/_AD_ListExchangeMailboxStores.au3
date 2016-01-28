#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Get a list of all Exchange Mailbox Stores in the Forest
; *****************************************************************************
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $aExServers = _AD_ListExchangeMailboxStores()
If @error > 0 Then
	MsgBox(16, "Active Directory Functions", "Could not find any Exchange Mailbox Stores!")
Else
	_ArrayDisplay($aExServers, "Active Directory Functions - Example 1 - All Exchange Mailbox Stores in the Forest")
EndIf

; Close Connection to the Active Directory
_AD_Close()