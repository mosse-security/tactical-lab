#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Creates and activates a computer in a particular OU.
; *****************************************************************************
#include <AD.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $sFQDN = _AD_SamAccountNameToFQDN()
Global $sParentOU = StringMid($sFQDN, StringInStr($sFQDN, ",OU=") + 1)
Global $iReply = MsgBox(308, "Active Directory Functions - Example 1", "This script creates a new computer account in the specified OU." & @CRLF & @CRLF & _
		"Are you sure you want to change the Active Directory?")
If $iReply <> 6 Then Exit

; Enter parent OU and computer to create
#region ### START Koda GUI section ### Form=
Global $Form1 = GUICreate("Active Directory Functions - Example 1", 714, 156)
GUICtrlCreateLabel("OU to create the computer in (FQDN):", 8, 10, 231, 17)
GUICtrlCreateLabel("Computer account to create (samAccountName):", 8, 42, 231, 17)
GUICtrlCreateLabel("User/group to use this computer (samAccountName or FQDN):", 8, 74, 231, 34)
Global $IOU = GUICtrlCreateInput($sParentOU, 241, 8, 459, 21)
Global $IComputer = GUICtrlCreateInput("", 241, 40, 459, 21)
Global $IUser = GUICtrlCreateInput("", 241, 72, 459, 21)
Global $BOK = GUICtrlCreateButton("Create Computer", 8, 114, 121, 33)
Global $BCancel = GUICtrlCreateButton("Cancel", 628, 114, 73, 33, BitOR($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	Global $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $BCancel
			Exit
		Case $BOK
			Global $sOU = GUICtrlRead($IOU)
			Global $sComputer = GUICtrlRead($IComputer)
			Global $sUser = GUICtrlRead($IUser)
			ExitLoop
	EndSwitch
WEnd

; Create a new computer account
Global $iValue = _AD_CreateComputer($sOU, $sComputer, $sUser)
If $iValue = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Computer '" & $sComputer & "' in OU '" & $sOU & "' successfully created")
ElseIf @error = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "OU '" & $sOU & "' does not exist")
ElseIf @error = 2 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Computer '" & $sComputer & "' already exists")
ElseIf @error = 3 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User/group '" & $sOU & "' does not exist")
Else
	MsgBox(64, "Active Directory Functions - Example 1", "Return code '" & @error & "' from Active Directory")
EndIf

; Close Connection to the Active Directory
_AD_Close()