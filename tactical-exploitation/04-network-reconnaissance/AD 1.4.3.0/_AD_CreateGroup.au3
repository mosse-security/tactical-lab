#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Create a group in the specified OU.
; *****************************************************************************
#include <AD.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $iReply = MsgBox(308, "Active Directory Functions - Example 1", "This script creates a group in the OU you specify." & @CRLF & @CRLF & _
		"Are you sure you want to change the Active Directory?")
If $iReply <> 6 Then Exit

; Get OU of current user
Global $sFQDN = _AD_SamAccountNameToFQDN()
Global $sParentOU = StringMid($sFQDN, StringInStr($sFQDN, ",OU=") + 1)

; Enter OU and group
#region ### START Koda GUI section ### Form=
Global $Form1 = GUICreate("Active Directory Functions - Example 1", 714, 124)
GUICtrlCreateLabel("Enter the target OU (FQDN):", 8, 10, 231, 17)
GUICtrlCreateLabel("Enter the group name (without leading CN=):", 8, 42, 231, 17)
Global $IOU = GUICtrlCreateInput($sParentOU, 241, 8, 459, 21)
Global $IGroup = GUICtrlCreateInput("", 241, 40, 459, 21)
Global $BOK = GUICtrlCreateButton("Create group", 8, 72, 121, 33)
Global $BCancel = GUICtrlCreateButton("Cancel", 628, 72, 73, 33, BitOR($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	Global $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $BCancel
			Exit
		Case $BOK
			Global $sOU = GUICtrlRead($IOU)
			Global $sGroup = GUICtrlRead($IGroup)
			ExitLoop
	EndSwitch
WEnd

; Create the group
Global $iValue = _AD_CreateGroup($sOU, $sGroup)
If $iValue = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Group '" & $sGroup & "' successfully created")
ElseIf @error = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Group '" & $sGroup & "' already exists")
ElseIf @error = 2 Then
	MsgBox(64, "Active Directory Functions - Example 1", "OU '" & $sOU & "' does not exist")
Else
	MsgBox(64, "Active Directory Functions - Example 1", "Return code '" & @error & "' from Active Directory")
EndIf

; Close Connection to the Active Directory
_AD_Close()