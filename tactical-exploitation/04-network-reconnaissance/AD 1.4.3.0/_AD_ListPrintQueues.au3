#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1
; Get a list of all PrintQueues in the AD tree
; *****************************************************************************
Global $aPrintQueues = _AD_ListPrintQueues()
If @error > 0 Then
	MsgBox(16, "Active Directory Functions", "Could not find any print queues!")
	Exit
Else
	_ArrayDisplay($aPrintQueues, "AD - Example 1 - All print queues")
EndIf

; *****************************************************************************
; Example 2
; Get a list of all PrintQueues for a specified spool server
; *****************************************************************************
Global $sSpoolServer = StringSplit($aPrintQueues[1][1], ".")
$aPrintQueues = _AD_ListPrintQueues($sSpoolServer[1])
If @error > 0 Then
	MsgBox(16, "Active Directory Functions", "Could not find any print queues for server '" & $sSpoolServer[1] & "'")
	Exit
Else
	_ArrayDisplay($aPrintQueues, "Active Directory Functions - Example 2 - All print queues for spool server '" & $sSpoolServer[1] & "'")
EndIf

; *****************************************************************************
; Example 3
; List all properties for the first print queue
; *****************************************************************************
Global $aPrinterDetails = _AD_GetObjectProperties($aPrintQueues[1][2])
_ArrayDisplay($aPrinterDetails, "Active Directory Functions - Example 3 - All properties for  print queue '" & $aPrintQueues[1][2] & "'")

; Close Connection to the Active Directory
_AD_Close()