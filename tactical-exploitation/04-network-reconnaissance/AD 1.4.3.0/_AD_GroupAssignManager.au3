#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Assigns a group manager (attribute "managedby") to a group.
; *****************************************************************************
#include <AD.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $iReply = MsgBox(308, "Active Directory Functions - Example 1", "This script assigns a group manager to a group." & @CRLF & @CRLF & _
		"Are you sure you want to change the Active Directory?")
If $iReply <> 6 Then Exit

; Enter group and user to assign as manager
#region ### START Koda GUI section ### Form=
Global $Form1 = GUICreate("Active Directory Functions - Example 1", 714, 124)
GUICtrlCreateLabel("Group (samAccountName or FQDN):", 8, 10, 231, 17)
GUICtrlCreateLabel("Manager for this group (samAccountName or FQDN):", 8, 42, 231, 34)
Global $IGroup = GUICtrlCreateInput("", 241, 8, 459, 21)
Global $IUser = GUICtrlCreateInput(@UserName, 241, 40, 459, 21)
Global $BOK = GUICtrlCreateButton("Assign Manager", 8, 82, 121, 33)
Global $BCancel = GUICtrlCreateButton("Cancel", 628, 82, 73, 33, BitOR($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	Global $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $BCancel
			Exit
		Case $BOK
			Global $sGroup = GUICtrlRead($IGroup)
			Global $sUser = GUICtrlRead($IUser)
			ExitLoop
	EndSwitch
WEnd

; Assign user as manager for the group
Global $iValue = _AD_GroupAssignManager($sGroup, $sUser)
If $iValue = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $sUser & "' successfuly assigned as manager to group '" & $sGroup & "'")
ElseIf @error = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Group '" & $sGroup & "' does not exist")
ElseIf @error = 2 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $sUser & "' does not exist")
Else
	MsgBox(64, "Active Directory Functions - Example 1", "Return code '" & @error & "' from Active Directory")
EndIf

; Close Connection to the Active Directory
_AD_Close()