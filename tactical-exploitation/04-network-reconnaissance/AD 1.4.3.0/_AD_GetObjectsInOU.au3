#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; Get FQDN for the currently logged on user
Global $sFQDN = _AD_SamAccountNameToFQDN()

; Strip off the CN
Global $iPos = StringInStr($sFQDN, ",")
Global $sOU = StringMid($sFQDN, $iPos + 1)

Global $aObjects[1][1]

; *****************************************************************************
; Example 1
; Get the OU the current user is assigned to.
; Then get an unfiltered list of all objects in this OU.
; *****************************************************************************
$aObjects = _AD_GetObjectsInOU($sOU, "(name=*)", 2, "sAMAccountName,distinguishedName,displayname")
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 1", "No OUs could be found")
Else
	_ArrayDisplay($aObjects, "Active Directory Functions - Example 1 - Objects in OU '" & $sOU & "'")
	Global $iResult = _AD_GetObjectsInOU($sOU, "(name=*)", 2, "sAMAccountName,distinguishedName,displayname", "", True)
	MsgBox(64, "Active Directory Functions - Example 1", "This example returned " & $iResult & " records")
EndIf

; *****************************************************************************
; Example 2
; Get the OU the current user is assigned to.
; Then get a filtered list of all users in this OU that start with the first
; letter of the current user. Sort the result by displayname.
; *****************************************************************************
Global $sUser = StringLeft(@UserName, 1)
$aObjects = _AD_GetObjectsInOU($sOU, "(&(objectcategory=person)(objectclass=user)(cn=" & $sUser & "*))", 2, "sAMAccountName,distinguishedName,displayname", "displayname")
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 2", "No OUs could be found")
Else
	_ArrayDisplay($aObjects, "Active Directory Functions - Example 2  - Objects in OU '" & $sOU & "'")
EndIf

; *****************************************************************************
; Example 3
; Use ANR (Ambigous Name Resolution) to get all objects with the same given Name
; as the current user in the ANR-supported attribute fields.
; Searches the whole domain.
; *****************************************************************************
Global $sGivenName = _AD_GetObjectAttribute(@UserName, "GivenName")
$aObjects = _AD_GetObjectsInOU("", "(ANR=" & $sGivenName & ")", 2, "sAMAccountName,distinguishedName,displayname", "displayname")
If @error > 0 Then
	MsgBox(64, "Active Directory Functions - Example 3", "No objects found")
Else
	_ArrayDisplay($aObjects, "Active Directory Functions - Example 3  - Ambigous Name Resolution. Search for '" & $sGivenName & "'")
EndIf

If MsgBox(36, "Active Directory Functions", "Would you like to see further examples using extended LDAP queries?") <> 7 Then
	$sOU = ""
	; ********************************
	; User accounts that do not expire
	; ********************************
	_Examples("(&(objectCategory=person)(objectClass=user)(|(accountExpires=9223372036854775807)(accountExpires=0)))", "sAMAccountName,distinguishedName,displayname", "User accounts that do not expire")
	; ****************************
	; User accounts that do expire
	; ****************************
	_Examples("(&(objectCategory=person)(objectClass=user)(!accountExpires=9223372036854775807)(!accountExpires=0))", "sAMAccountName,distinguishedName,displayname,accountexpires", "User accounts that do expire")
	; ***************************************
	; User accounts that already have expired
	; ***************************************
	Global $sAD_DTExpire = _Date_Time_GetSystemTime() ; Get current date/time
	$sAD_DTExpire = _Date_Time_SystemTimeToDateTimeStr($sAD_DTExpire, 1) ; convert to system time
	Global $iAD_DTExpire = Int(_DateDiff("s", "1601/01/01 00:00:00", $sAD_DTExpire) * 10000000) ; convert to Integer8
	_Examples("(&(objectCategory=person)(objectClass=user)(!accountExpires=9223372036854775807)(!accountExpires=0)(accountExpires<=" & $iAD_DTExpire & ")", "sAMAccountName,distinguishedName,displayname", "Expired user accounts")
	; *************************************
	; Users not required to have a password
	; *************************************
	_Examples("(&(objectCategory=person)(objectClass=user)(userAccountControl:1.2.840.113556.1.4.803:=32))", "sAMAccountName,distinguishedName,displayname", "Users not required to have a password")
	; **********************************************************************************
	; Users with any group other than "Domain Users" designated as their "primary" group
	; **********************************************************************************
	_Examples("(&(objectCategory=person)(objectClass=user)(!primaryGroupID=513))", "sAMAccountName,distinguishedName,displayname", "Users with any group other than 'Domain Users' designated as their 'primary group'")
	; **************************************************************
	; Users that must change their password the next time they logon
	; **************************************************************
	_Examples("(&(objectCategory=person)(objectClass=user)(pwdLastSet=0))", "sAMAccountName,distinguishedName,displayname", "Users that must change their password the next time they logon")
	; *********************************
	; Users that never logged on before
	; *********************************
	_Examples("(&(&(objectCategory=person)(objectClass=user))(|(lastLogon=0)(!(lastLogon=*))))", "sAMAccountName,distinguishedName,displayname", "Users that never logged on before")
	; **************************
	; List of all Group Policies
	; **************************
	_Examples("(objectClass=groupPolicyContainer)", "displayName,gPCFileSysPath", "List of Group Policies")
EndIf

; Close Connection to the Active Directory
_AD_Close()

; **********************************************************
; Executes LDAP queries and displays the results in an Array
; **********************************************************
Func _Examples($query, $fields, $description)

	Local $aObjects[1][1]
	$aObjects = _AD_GetObjectsInOU($sOU, $query, 2, $fields)
	If @error <> 0 Then
		MsgBox(64, "Active Directory Functions - Extended Example", "No entries found for LDAP query " & @CRLF & $query & @CRLF & $description & @CRLF & "Error: " & @error)
	Else
		_ArrayDisplay($aObjects, "LDAP query - " & $description & " - " & $query)
	EndIf

EndFunc   ;==>_Examples