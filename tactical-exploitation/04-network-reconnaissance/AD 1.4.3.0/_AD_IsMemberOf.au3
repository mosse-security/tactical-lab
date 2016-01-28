#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Get a list of group names the current user is a member of.
; Check the group membership of the current user for the first group.
; This will always return 1.
; *****************************************************************************
#include <AD.au3>

Global $aUser, $sFQDN_Group, $sFQDN_User, $iResult

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; Get the Fully Qualified Domain Name (FQDN) for the current user
$sFQDN_User = _AD_SamAccountNameToFQDN()

; Get an array of group names (FQDN) that the current user is immediately a member of
$aUser = _AD_GetUserGroups(@UserName)
$sFQDN_Group = $aUser[1]

; Check the group membership of the specified user for the specified group
$iResult = _AD_IsMemberOf($sFQDN_Group, $sFQDN_User)
Select
	Case $iResult = 1
		MsgBox(64, "Active Directory Functions", _
				"User: " & $sFQDN_User & @CRLF & _
				"Group: " & $sFQDN_Group & @CRLF & _
				"User is a member of the specified group!")
	Case ($iResult = 0 And @error = 1)
		MsgBox(64, "Active Directory Functions", _
				"User: " & $sFQDN_User & @CRLF & _
				"Group: " & $sFQDN_Group & @CRLF & _
				"Group does not exist!")
	Case ($iResult = 0 And @error = 2)
		MsgBox(64, "Active Directory Functions", _
				"User: " & $sFQDN_User & @CRLF & _
				"Group: " & $sFQDN_Group & @CRLF & _
				"User does not exist!")
	Case ($iResult = 0)
		MsgBox(64, "Active Directory Functions", _
				"User: " & $sFQDN_User & @CRLF & _
				"Group: " & $sFQDN_Group & @CRLF & _
				"User is a not member of the specified group!")
EndSelect

; Close Connection to the Active Directory
_AD_Close()