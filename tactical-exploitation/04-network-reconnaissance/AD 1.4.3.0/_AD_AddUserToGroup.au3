#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Add a user to a specified group.
; *****************************************************************************
#include <AD.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)
_AD_ErrorNotify(2)
Global $iReply = MsgBox(308, "Active Directory Functions - Example 1", "This script adds a user to a group." & @CRLF & @CRLF & _
		"Are you sure you want to change the Active Directory?")
If $iReply <> 6 Then Exit

; Enter user account and group
#region ### START Koda GUI section ### Form=
Global $Form1 = GUICreate("Active Directory Functions - Example 1", 514, 124)
GUICtrlCreateLabel("User account (FQDN or samAccountName):", 8, 10, 231, 17)
GUICtrlCreateLabel("Group name (without leading CN=):", 8, 42, 231, 17)
Global $lUser = GUICtrlCreateInput(@UserName, 241, 8, 259, 21)
Global $IGroup = GUICtrlCreateInput("", 241, 40, 259, 21)
Global $BOK = GUICtrlCreateButton("Assign user to group", 8, 72, 121, 33)
Global $BCancel = GUICtrlCreateButton("Cancel", 428, 72, 73, 33, BitOR($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	Global $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $BCancel
			Exit
		Case $BOK
			Global $sUser = GUICtrlRead($lUser)
			Global $sGroup = GUICtrlRead($IGroup)
			ExitLoop
	EndSwitch
WEnd

; Add user to group
Global $iValue = _AD_AddUserToGroup($sGroup, $sUser)
If $iValue = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $sUser & "' successfully assigned to group '" & $sGroup & "'")
ElseIf @error = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Group '" & $sGroup & "' does not exist")
ElseIf @error = 2 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $sUser & "' does not exist")
ElseIf @error = 3 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $sUser & "' is already a member of group '" & $sGroup & "'")
Else
	MsgBox(64, "Active Directory Functions - Example 1", "Return code '" & @error & "' from Active Directory")
EndIf

; Close Connection to the Active Directory
_AD_Close()