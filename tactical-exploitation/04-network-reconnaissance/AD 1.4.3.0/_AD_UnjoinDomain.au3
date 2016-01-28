#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#RequireAdmin
; *****************************************************************************
; Example 1
; Unjoins a computer from the domain.
; *****************************************************************************
#include <AD.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $iReply = MsgBox(308, "Active Directory Functions - Example 1", "This script unjoins a computer from the domain and joins it to a workgroup." & @CRLF & @CRLF & _
		"Are you sure you want to change the Active Directory?")
If $iReply <> 6 Then Exit

; Enter the computer to unjoin
#region ### START Koda GUI section ### Form=
Global $Form1 = GUICreate("Active Directory Functions - Example 1", 714, 156)
GUICtrlCreateLabel("Computer to unjoin (NetBIOSName):", 8, 10, 231, 17)
Global $IComputer = GUICtrlCreateInput("", 241, 8, 459, 21)
GUICtrlCreateLabel("Workgroup to join the computer:", 8, 42, 231, 17)
Global $IWorkgroup = GUICtrlCreateInput("", 241, 40, 459, 21)
Global $BOK = GUICtrlCreateButton("Unjoin Computer", 8, 114, 121, 33)
Global $BCancel = GUICtrlCreateButton("Cancel", 628, 114, 73, 33, BitOR($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	Global $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $BCancel
			Exit
		Case $BOK
			Global $sComputer = GUICtrlRead($IComputer)
			Global $sWorkgroup = GUICtrlRead($IWorkgroup)
			ExitLoop
	EndSwitch
WEnd

; Unjoin the computer from the domain
Global $iValue = _AD_UnjoinDomain($sComputer, $sWorkgroup)
If $iValue = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Computer '" & $sComputer & "' successfully unjoined. Please reboot the computer")
ElseIf @error = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Computer account for '" & $sComputer & "' does not exist in the domain")
ElseIf @error = 3 Then
	MsgBox(64, "Active Directory Functions - Example 1", "WMI object could not be created. @extended=" & @extended)
ElseIf @error = 4 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Computer '" & $sComputer & "' is a member of another or no domain")
ElseIf @error = 5 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Unjoining computer '" & $sComputer & "' from the domain was not successful. @extended=" & @extended)
ElseIf @error = 6 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Joining the Computer '" & $sComputer & "' to workgroup '" & $sWorkgroup & "' was not successful. @extended=" & @extended)
Else
	MsgBox(64, "Active Directory Functions - Example 1", "Return code '" & @error & "' from Active Directory")
EndIf

; Close Connection to the Active Directory
_AD_Close()