#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Queries the sAMACccountName and the password and tries to change the password.
; *****************************************************************************
#include <AD.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $iReply = MsgBox(308, "Active Directory Functions - Example 1", "This script sets the password for a user you specify." & @CRLF & @CRLF & _
		"Are you sure you want to change the Active Directory?")
If $iReply <> 6 Then Exit

; Enter user and password to change
#region ### START Koda GUI section ### Form=
Global $Form1 = GUICreate("Active Directory Functions - Example 1", 414, 124, 251, 112)
GUICtrlCreateLabel("User account (sAMAccountName or FQDN):", 8, 10, 231, 17)
GUICtrlCreateLabel("New password:", 8, 42, 121, 17)
Global $IUser = GUICtrlCreateInput("", 241, 8, 159, 21)
Global $IPassword = GUICtrlCreateInput("", 241, 40, 159, 21)
Global $BOK = GUICtrlCreateButton("Change Password", 8, 72, 121, 33)
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
			Global $sPassword = GUICtrlRead($IPassword)
			ExitLoop
	EndSwitch
WEnd

; Set the password
Global $iValue = _AD_SetPassword($sUser, $sPassword)
If $iValue = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "Password for user '" & $sUser & "' successfully changed")
ElseIf @error = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $sUser & "' does not exist")
Else
	MsgBox(64, "Active Directory Functions - Example 1", "Return code '" & @error & "' from Active Directory")
EndIf

; Close Connection to the Active Directory
_AD_Close()