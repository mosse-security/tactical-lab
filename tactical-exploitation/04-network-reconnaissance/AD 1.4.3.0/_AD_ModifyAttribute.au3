#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/cs 0 /cn 0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *****************************************************************************
; Example 1
; Modify the description of the current user.
; *****************************************************************************
#include <AD.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $iReply = MsgBox(308, "Active Directory Functions - Example 1", "This script changes the attribute 'description' for a user." & @CRLF & @CRLF & _
		"Are you sure you want to change the Active Directory?")
If $iReply <> 6 Then Exit

; Enter user account and description
#region ### START Koda GUI section ### Form=
Global $Form1 = GUICreate("Active Directory Functions - Example 1", 514, 124)
GUICtrlCreateLabel("User account (samAccountName or sAMAccountName):", 8, 10, 231, 34)
GUICtrlCreateLabel("New description:", 8, 42, 231, 17)
Global $IUser = GUICtrlCreateInput(@UserName, 241, 8, 259, 21)
Global $IDescription = GUICtrlCreateInput("", 241, 40, 259, 21)
Global $BOK = GUICtrlCreateButton("Change description", 8, 72, 121, 33)
Global $BCancel = GUICtrlCreateButton("Cancel", 428, 72, 73, 33, BitOR($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	Global $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $BCancel
			Exit
		Case $BOK
			Global $sUser = GUICtrlRead($IUser)
			Global $sDescription = GUICtrlRead($IDescription)
			ExitLoop
	EndSwitch
WEnd

; Change attribute
Global $iValue = _AD_ModifyAttribute($sUser, "description", $sDescription)
If $iValue = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Description for user '" & $sUser & "' successfully changed")
ElseIf @error = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $sUser & "' does not exist")
Else
	MsgBox(64, "Active Directory Functions - Example 1", "Return code '" & @error & "' from Active Directory")
EndIf

; Close Connection to the Active Directory
_AD_Close()