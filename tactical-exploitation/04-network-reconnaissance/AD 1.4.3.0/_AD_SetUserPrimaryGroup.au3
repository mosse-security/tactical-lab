#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Sets the users primary group.
; *****************************************************************************
#include <AD.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $iReply = MsgBox(308, "Active Directory Functions - Example 1", "This script sets the users primary group." & @CRLF & @CRLF & _
		"Are you sure you want to change the Active Directory?")
If $iReply <> 6 Then Exit

; Enter user and primary group
#region ### START Koda GUI section ### Form=
Global $Form1 = GUICreate("Active Directory Functions - Example 1", 414, 124, 251, 112)
GUICtrlCreateLabel("User account (sAMAccountName or FQDN):", 8, 10, 231, 17)
GUICtrlCreateLabel("Primary group (sAMAccountName or FQDN):", 8, 42, 231, 17)
Global $IUser = GUICtrlCreateInput("", 241, 8, 159, 21)
Global $IGroup = GUICtrlCreateInput("", 241, 40, 159, 21)
Global $BOK = GUICtrlCreateButton("Set Primary Group", 8, 72, 121, 33)
Global $BCancel = GUICtrlCreateButton("Cancel", 328, 72, 73, 33, BitOR($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	Global $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $BCancel
			Exit
		Case $BOK
			Global $sUser = GUICtrlRead($IUser)
			$sUser = _AD_SamAccountNameToFQDN($sUser)
			Global $sGroup = GUICtrlRead($IGroup)
			ExitLoop
	EndSwitch
WEnd

; Set the primary group
Global $iValue = _AD_SetUserPrimaryGroup($sUser, $sGroup)
If $iValue = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Primary group for user '" & $sUser & "' successfully changed to '" & $sGroup & "'")
ElseIf @error = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $sUser & "' does not exist")
ElseIf @error = 2 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Group '" & $sGroup & "' does not exist")
ElseIf @error = 3 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $sUser & "' is no member of group '" & $sGroup & "'")
Else
	MsgBox(64, "Active Directory Functions - Example 1", "Return code '" & @error & "' from Active Directory")
EndIf

; Close Connection to the Active Directory
_AD_Close()