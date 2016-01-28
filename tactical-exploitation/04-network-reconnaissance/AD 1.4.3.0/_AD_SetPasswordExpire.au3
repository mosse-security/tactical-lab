#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Sets user's password as expired or not expired.
; *****************************************************************************
#include <AD.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
;#include <EditConstants.au3>
#include <WindowsConstants.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

Global $iReply = MsgBox(308, "Active Directory Functions - Example 1", "This script sets the password for a user you specify as expired or not expired." & @CRLF & @CRLF & _
		"Are you sure you want to change the Active Directory?")
If $iReply <> 6 Then Exit

#region ### START Koda GUI section ### Form=
Global $Form = GUICreate("Active Directory Functions - Example 1", 515, 162, 251, 112)
GUICtrlCreateLabel("UserId", 8, 12, 39, 21)
Global $IUserId = GUICtrlCreateInput(@UserName, 241, 8, 259, 21)
GUICtrlCreateLabel("Set password expired:", 8, 44, 131, 21)
Global $IRadio1 = GUICtrlCreateRadio("", 241, 40, 17, 21)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateLabel("Set password not expired:", 8, 76, 131, 21)
Global $IRadio2 = GUICtrlCreateRadio("", 241, 72, 17, 21)
Global $BOK = GUICtrlCreateButton("Set Password Expiration", 8, 118, 130, 33)
Global $BCancel = GUICtrlCreateButton("Cancel", 428, 118, 73, 33)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

Global $iFunction = 0
While 1
	Global $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $BCancel
			Exit
		Case $BOK
			Global $SUserId = GUICtrlRead($IUserId)
			If GUICtrlRead($IRadio1) = $GUI_CHECKED Then $iFunction = 0
			If GUICtrlRead($IRadio2) = $GUI_CHECKED Then $iFunction = -1
			ExitLoop
	EndSwitch
WEnd

; Change the Password Expiration
Global $iValue = _AD_SetPasswordExpire($SUserId, $iFunction)
If $iValue = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $SUserId & "' successfully changed")
ElseIf @error = 1 Then
	MsgBox(64, "Active Directory Functions - Example 1", "User '" & $SUserId & "' does not exist")
Else
	MsgBox(64, "Active Directory Functions - Example 1", "Return code '" & @error & "' from Active Directory")
EndIf

; Close Connection to the Active Directory
_AD_Close()