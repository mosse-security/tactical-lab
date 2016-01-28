#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Allows user to change their password.
; *****************************************************************************
#include <AD.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $iReply = MsgBox(308, "Active Directory Functions - Example 1", "This script enables the specified user to change their password." & @CRLF & @CRLF & _
		"Are you sure you want to change the Active Directory?")
If $iReply <> 6 Then Exit

; Enter user to change
#region ### START Koda GUI section ### Form=
Global $Form1 = GUICreate("Active Directory Functions - Example 1", 714, 124)
GUICtrlCreateLabel("User to change (FQDN or sAMAccountName):", 8, 10, 231, 17)
Global $IUser = GUICtrlCreateInput("", 241, 10, 459, 21)
Global $BOK = GUICtrlCreateButton("Change User", 8, 72, 121, 33)
Global $BCancel = GUICtrlCreateButton("Cancel", 628, 72, 73, 33, BitOR($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	Global $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $BCancel
			Exit
		Case $BOK
			Global $sUser = GUICtrlRead($IUser)
			ExitLoop
	EndSwitch
WEnd

; Change user
Global $iValue = _AD_EnablePasswordChange($sUser)
If $iValue = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $sUser & "' successfully changed")
ElseIf @error = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $sUser & "' does not exist")
Else
	MsgBox(64, "Active Directory Functions - Example 1", "Return code '" & @error & "' from Active Directory")
EndIf

; Close Connection to the Active Directory
_AD_Close()