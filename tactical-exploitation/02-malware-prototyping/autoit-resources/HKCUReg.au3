#include-once
#include <File.au3>
#include <Security.au3>
#include ".\Reg.au3"

; #INDEX# =======================================================================================================================================
; Title .........: HKCUReg
; AutoIt Version : 3.3.8.0++
; Language ......: English
; Description ...: Perform registry operations on 'HKCU' for a specific or all user accounts on a computer
; ===============================================================================================================================================

; #CURRENT# =====================================================================================================================================
;_HKCU_Delete
;_HKCU_EnumKey
;_HKCU_EnumVal
;_HKCU_Import
;_HKCU_Read
;_HKCU_Write
; ===============================================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================================
;GetProfile
;ProfileAdd
;Split_sKey
; ===============================================================================================================================================

; #FUNCTION# ====================================================================================================================================
; Name...........: _HKCU_Delete
; Description ...: Deletes a key or value from the registry
; Syntax.........: _HKCU_Delete($sKey [, $sValue])
; Parameters ....: $sKey - see RegDelete function for details (no 'HKCU' required)
;                  $sValue - [optional] see RegDelete function for details
; Requirement(s).:
; Return values .: Returns an Array where:
;                  Column 0 - User account name
;                  Column 1 - RegDelete function return value
;                  Column 2 - RegDelete function @error macro
; Author ........: engine
; Modified.......:
; Remarks .......: It is possible to access remote registries by using $sKey in the form "\\\computername\keyname"
;                  It is possible to access a specific user account by using $sKey in the form "\\username\keyname"
;                  It is possible to access both a remote registry and a specific user account by using $sKey in the form
;                  "\\\computername\\username\keyname"
; Related .......:
; Link ..........;
; Examples ......;  _HKCU_Delete("Software\7-Zip", "Path")
;                   _HKCU_Delete("\\\computername\Software\7-Zip", "Path")
;                   _HKCU_Delete("\\username\Software\7-Zip", "Path")
;                   _HKCU_Delete("\\\computername\\username\Software\7-Zip", "Path")
; ===============================================================================================================================================

Func _HKCU_Delete($sKey, $sValue = Default)
	Local $asSplit = Split_sKey($sKey)
	Local $avProfile = GetProfile($asSplit[1], $asSplit[0])
	Local $avArray[$avProfile[0][0] + 1][3], $iLoaded, $iResult
	$avArray[0][0] = $avProfile[0][0]
	For $i = 1 To $avProfile[0][0]
		If $avProfile[$i][3] = 0 Then
			$iLoaded = _RegLoadHive($avProfile[$i][1] & "\NTUSER.DAT", $avProfile[$i][2])
		EndIf
		If $sValue = Default Then
			$iResult = RegDelete($avProfile[$i][2] & "\" & $asSplit[2])
		Else
			$iResult = RegDelete($avProfile[$i][2] & "\" & $asSplit[2], $sValue)
		EndIf
		$avArray[$i][0] = $avProfile[$i][0]
		$avArray[$i][1] = $iResult
		$avArray[$i][2] = @error
		If $iLoaded Then _RegUnloadHive($avProfile[$i][2])
	Next
	Return $avArray
EndFunc ;==> _HKCU_Delete

; #FUNCTION# ====================================================================================================================================
; Name...........: _HKCU_EnumKey
; Description ...: Reads the name of a subkey according to it's instance
; Syntax.........: _HKCU_EnumKey($sKey, $iInstance)
; Parameters ....: $sKey - see RegEnumKey function for details (no 'HKCU' required)
;                  $iInstance - see RegEnumKey function for details
; Requirement(s).:
; Return values .: Returns an Array where:
;                  Column 0 - User account name
;                  Column 1 - RegEnumKey function return value
;                  Column 2 - RegEnumKey function @error macro
; Author ........: engine
; Modified.......:
; Remarks .......: It is possible to access remote registries by using $sKey in the form "\\\computername\keyname"
;                  It is possible to access a specific user account by using $sKey in the form "\\username\keyname"
;                  It is possible to access both a remote registry and a specific user account by using $sKey in the form
;                  "\\\computername\\username\keyname"
; Related .......:
; Link ..........;
; Example .......;
;                  #include <Array.au3>
;                  #include "HKCUReg.au3"
;
;                  $sComputer = @ComputerName
;
;                  For $i = 1 To 100
;                  		$b = _HKCU_EnumKey("\\\" & $sComputer & "\Software", $i)
;                   	$iProd = 1
;                   	For $j = 1 To $b[0][0]
;                   		$iProd *= $b[$j][2]
;                   	Next
;                   	If $iProd <> 0 Then ExitLoop
;                   	_ArrayDisplay($b, $i)
;                  Next
; ===============================================================================================================================================

Func _HKCU_EnumKey($sKey, $iInstance)
	Local $asSplit = Split_sKey($sKey)
	Local $avProfile = GetProfile($asSplit[1], $asSplit[0])
	Local $avArray[$avProfile[0][0] + 1][3], $iLoaded
	$avArray[0][0] = $avProfile[0][0]
	For $i = 1 To $avProfile[0][0]
		If $avProfile[$i][3] = 0 Then
			$iLoaded = _RegLoadHive($avProfile[$i][1] & "\NTUSER.DAT", $avProfile[$i][2])
		EndIf
		$avArray[$i][0] = $avProfile[$i][0]
		$avArray[$i][1] = RegEnumKey($avProfile[$i][2] & "\" & $asSplit[2], $iInstance)
		$avArray[$i][2] = @error
		If $iLoaded Then _RegUnloadHive($avProfile[$i][2])
	Next
	Return $avArray
EndFunc ;==> _HKCU_EnumKey

; #FUNCTION# ====================================================================================================================================
; Name...........: _HKCU_EnumVal
; Description ...: Reads the name of a value according to it's instance
; Syntax.........: _HKCU_EnumVal($sKey, $iInstance)
; Parameters ....: $sKey - see RegEnumVal function for details (no 'HKCU' required)
;                  $iInstance - see RegEnumVal function for details
; Requirement(s).:
; Return values .: Returns an Array where:
;                  Column 0 - User account name
;                  Column 1 - RegEnumVal function return value
;                  Column 2 - RegEnumVal function @error macro
;                  Column 3 - RegEnumVal function @extended macro
; Author ........: engine
; Modified.......:
; Remarks .......: It is possible to access remote registries by using $sKey in the form "\\\computername\keyname"
;                  It is possible to access a specific user account by using $sKey in the form "\\username\keyname"
;                  It is possible to access both a remote registry and a specific user account by using $sKey in the form
;                  "\\\computername\\username\keyname"
; Related .......:
; Link ..........;
; Example .......;
;                  #include <Array.au3>
;                  #include "HKCUReg.au3"
;
;                  $sComputer = @ComputerName
;
;                  For $i = 1 To 100
;                   	$b = _HKCU_EnumVal("\\\" & $sComputer & "\Software\AutoIt v3\Aut2Exe", $i)
;                   	$iProd = 1
;                   	For $j = 1 To $b[0][0]
;                   		$iProd *= $b[$j][2]
;                   	Next
;                   	If $iProd <> 0 Then ExitLoop
;                   	_ArrayDisplay($b, $i)
;                  Next
; ===============================================================================================================================================

Func _HKCU_EnumVal($sKey, $iInstance)
	Local $asSplit = Split_sKey($sKey)
	Local $avProfile = GetProfile($asSplit[1], $asSplit[0])
	Local $avArray[$avProfile[0][0] + 1][4], $iLoaded
	$avArray[0][0] = $avProfile[0][0]
	For $i = 1 To $avProfile[0][0]
		If $avProfile[$i][3] = 0 Then
			$iLoaded = _RegLoadHive($avProfile[$i][1] & "\NTUSER.DAT", $avProfile[$i][2])
		EndIf
		$avArray[$i][0] = $avProfile[$i][0]
		$avArray[$i][1] = RegEnumVal($avProfile[$i][2] & "\" & $asSplit[2], $iInstance)
		$avArray[$i][2] = @error
		$avArray[$i][3] = @extended
		If $iLoaded Then _RegUnloadHive($avProfile[$i][2])
	Next
	Return $avArray
EndFunc ;==> _HKCU_EnumVal

; #FUNCTION# ====================================================================================================================================
; Name...........: _HKCU_Import
; Description ...: Imports a previously exported reg file to the registry
; Syntax.........: _HKCU_Import($sReg [, $sName])
; Parameters ....: $sReg - Path and filename of the file to be imported, file extension (.reg)
;                  $sName - User account name, defaults to all users
; Requirement(s).: Registry Console Tool
; Return values .: Returns an Array where:
;                  Column 0 - User account name
;                  Column 1 - Return value:
;                           1 - Success
;                           0 - Failure
;                  Column 2 - @error macro:
;                           1 - Failure
;                           0 - Success
; Author ........: engine
; Modified.......:
; Remarks .......: This function doesn't support remote computers
; Related .......:
; Link ..........;
; Examples ......;  _HKCU_Import("ffdshow.reg")
;                   _HKCU_Import("ffdshow.reg", "Guest")
; ===============================================================================================================================================

Func _HKCU_Import($sReg, $sName = "")
	Local $avProfile = GetProfile($sName)
	Local $avArray[$avProfile[0][0] + 1][3], $iLoaded, $avReg, $sReplace, $sTempReg, $iResult
	$avArray[0][0] = $avProfile[0][0]
	For $i = 1 To $avProfile[0][0]
		If $avProfile[$i][3] = 0 Then
			$iLoaded = _RegLoadHive($avProfile[$i][1] & "\NTUSER.DAT", $avProfile[$i][2])
		EndIf
		_FileReadToArray($sReg, $avReg)
		If Not @error Then
			$sReplace = StringReplace($avProfile[$i][2], "\\" & @ComputerName & "\", "")
			For $k = 1 To $avReg[0]
				$avReg[$k] = StringReplace($avReg[$k], "HKEY_CURRENT_USER", $sReplace)
			Next
			$sTempReg = _TempFile(@UserProfileDir, "~", ".reg")
			_FileWriteFromArray($sTempReg, $avReg, 1)
			$iResult = RunWait('reg import "' & $sTempReg & '"', "", @SW_HIDE)
		EndIf
		$avArray[$i][0] = $avProfile[$i][0]
		$avArray[$i][1] = 1 - $iResult - @error
		$avArray[$i][2] = @error
		FileDelete($sTempReg)
		If $iLoaded Then _RegUnloadHive($avProfile[$i][2])
	Next
	Return $avArray
EndFunc ;==> _HKCU_Import

; #FUNCTION# ====================================================================================================================================
; Name...........: _HKCU_Read
; Description ...: Reads a value from the registry
; Syntax.........: _HKCU_Read($sKey, $sValue)
; Parameters ....: $sKey - see RegRead function for details (no 'HKCU' required)
;                  $sValue - see RegRead function for details
; Requirement(s).:
; Return values .: Returns an Array where:
;                  Column 0 - User account name
;                  Column 1 - RegRead function return value
;                  Column 2 - RegRead function @error macro
;                  Column 3 - RegRead function @extended macro
; Author ........: engine
; Modified.......:
; Remarks .......: It is possible to access remote registries by using $sKey in the form "\\\computername\keyname"
;                  It is possible to access a specific user account by using $sKey in the form "\\username\keyname"
;                  It is possible to access both a remote registry and a specific user account by using $sKey in the form
;                  "\\\computername\\username\keyname"
; Related .......:
; Link ..........;
; Examples ......;  _HKCU_Read("Software\7-Zip", "Path")
;                   _HKCU_Read("\\\computername\Software\7-Zip", "Path")
;                   _HKCU_Read("\\username\Software\7-Zip", "Path")
;                   _HKCU_Read("\\\computername\\username\Software\7-Zip", "Path")
; ===============================================================================================================================================

Func _HKCU_Read($sKey, $sValue)
	Local $asSplit = Split_sKey($sKey)
	Local $avProfile = GetProfile($asSplit[1], $asSplit[0])
	Local $avArray[$avProfile[0][0] + 1][4], $iLoaded
	$avArray[0][0] = $avProfile[0][0]
	For $i = 1 To $avProfile[0][0]
		If $avProfile[$i][3] = 0 Then
			$iLoaded = _RegLoadHive($avProfile[$i][1] & "\NTUSER.DAT", $avProfile[$i][2])
		EndIf
		$avArray[$i][0] = $avProfile[$i][0]
		$avArray[$i][1] = RegRead($avProfile[$i][2] & "\" & $asSplit[2], $sValue)
		$avArray[$i][2] = @error
		$avArray[$i][3] = @extended
		If $iLoaded Then _RegUnloadHive($avProfile[$i][2])
	Next
	Return $avArray
EndFunc ;==> _HKCU_Read

; #FUNCTION# ====================================================================================================================================
; Name...........: _HKCU_Write
; Description ...: Creates a key or value in the registry
; Syntax.........: _HKCU_Write($sKey [, $sValue, $sType, $vData])
; Parameters ....: $sKey - see RegWrite function for details (no 'HKCU' required)
;                  $sValue - [optional] see RegWrite function for details
;                  $sType - [optional] see RegWrite function for details
;                  $vData - [optional] see RegWrite function for details
; Requirement(s).:
; Return values .: Returns an array where:
;                  Column 0 - User account name
;                  Column 1 - RegWrite function return value
;                  Column 2 - RegWrite function @error macro
; Author ........: engine
; Modified.......:
; Remarks .......: It is possible to access remote registries by using $sKey in the form "\\\computername\keyname"
;                  It is possible to access a specific user account by using $sKey in the form "\\username\keyname"
;                  It is possible to access both a remote registry and a specific user account by using $sKey in the form
;                  "\\\computername\\username\keyname"
; Related .......:
; Link ..........;
; Examples ......;  _HKCU_Write("Software\7-Zip", "Path", "REG_SZ", @ProgramFilesDir & "\7-Zip")
;                   _HKCU_Write("\\\computername\Software\7-Zip", "Path", "REG_SZ", @ProgramFilesDir & "\7-Zip")
;                   _HKCU_Write("\\username\Software\7-Zip", "Path", "REG_SZ", @ProgramFilesDir & "\7-Zip")
;                   _HKCU_Write("\\\computername\\username\Software\7-Zip", "Path", "REG_SZ", @ProgramFilesDir & "\7-Zip")
; ===============================================================================================================================================

Func _HKCU_Write($sKey, $sValue = "", $sType = "REG_SZ", $vData = "")
	Local $asSplit = Split_sKey($sKey)
	Local $avProfile = GetProfile($asSplit[1], $asSplit[0])
	Local $avArray[$avProfile[0][0] + 1][3], $iLoaded
	$avArray[0][0] = $avProfile[0][0]
	For $i = 1 To $avProfile[0][0]
		If $avProfile[$i][3] = 0 Then
			$iLoaded = _RegLoadHive($avProfile[$i][1] & "\NTUSER.DAT", $avProfile[$i][2])
		EndIf
		$avArray[$i][0] = $avProfile[$i][0]
		$avArray[$i][1] = RegWrite($avProfile[$i][2] & "\" & $asSplit[2], $sValue, $sType, $vData)
		$avArray[$i][2] = @error
		If $iLoaded Then _RegUnloadHive($avProfile[$i][2])
	Next
	Return $avArray
EndFunc ;==> _HKCU_Write

; #INTERNAL_USE_ONLY#============================================================================================================================
; Name...........: GetProfile
; Description ...: Determine each user's Profile folder, the user's SID and if the profile is loaded to the registry
; Syntax.........: GetProfile([$sAccount, $sComputer])
; Parameters ....: $sAccount - User account name, defaults to all users
;                  $sComputer - Computer name, the local computer is default
; Requirement(s).: Service 'RemoteRegistry' running on the target computer
;                  When the target computer is the local computer, the 'RemoteRegistry' service isn't required
; Return values .: An array containing the path to each user's profile folder, the user's SID
;                  The array returned is two-dimensional and is made up as follows:
;                  $array[0][0] = Number of profiles
;                  $array[1][0] = 1st user name
;                  $array[1][1] = Path to 1st user profile
;                  $array[1][2] = 1st user registry hive
;                  $array[1][3] = 1 if 1st user profile is loaded to the registry, 0 if not
;                  $array[2][0] = 2nd user name
;                  $array[2][1] = Path to 2nd user profile
;                  $array[2][2] = 2nd user registry hive
;                  $array[2][3] = 1 if 2nd user profile is loaded to the registry, 0 if not
;                  ...
;                  $array[n][0] = nth user name
;                  $array[n][1] = Path to nth user profile
;                  $array[n][2] = nth user registry hive
;                  $array[n][3] = 1 if nth user profile is loaded to the registry, 0 if not
; Author ........: engine
; Modified.......: AdamUL
; Remarks .......: For internal use only
; Related .......:
; Link ..........;
; Example .......; GetProfile("Default User") to get Default User's profile data on the local computer
; ===============================================================================================================================================

Func GetProfile($sAccount = "", $sComputer = @ComputerName)
	Local $avArray[1][4], $sDefaultUser, $sEnv
	Local Const $sProfileListKey = "\\" & $sComputer & "\HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
	Local Const $sRootKey = "\\" & $sComputer & "\HKEY_USERS\"
	Local Const $sDefaultUser1 = RegRead($sProfileListKey, "DefaultUserProfile")
	Local Const $iDefaultUser1Error = @error
	Local Const $sDefaultUser2 = RegRead($sProfileListKey, "Default")
	Local Const $iDefaultUser2Error = @error
	If $iDefaultUser1Error And $iDefaultUser2Error Then
		$avArray[0][0] = 0
		Return $avArray
	EndIf
	If $iDefaultUser1Error Then
		$sDefaultUser = "Default"
	Else
		$sDefaultUser = $sDefaultUser1
	EndIf

	If $sAccount = "" Or $sAccount = $sDefaultUser Then
		Local $iInstance, $sSID
		While 1
			$iInstance += 1
			$sSID = RegEnumKey($sProfileListKey, $iInstance)
			If @error Then ExitLoop
			If StringLen($sSID) > 8 Then ProfileAdd($avArray, $sSID, $sProfileListKey, $sRootKey)
		WEnd
		Local $u = UBound($avArray), $iSum
		For $k = 1 To $u - 1
			$iSum += $avArray[$k][3]
		Next
		ReDim $avArray[$u + 1][4]
		$avArray[$u][0] = $sDefaultUser
		$avArray[$u][1] = RegRead($sProfileListKey, "ProfilesDirectory") & "\" & $sDefaultUser
		If $iSum = 0 Then
			$avArray[$u][2] = "\\" & $sComputer & "\HKEY_CURRENT_USER"
			$avArray[$u][3] = 1
		Else
			Local $avDomain, $iN = 998, $sDSID, $avDU
			$avDomain = _Security__LookupAccountName($sComputer, $sComputer)
			Do
				$iN += 1
				$sDSID = $avDomain[0] & "-" & $iN
				$avDU = _Security__LookupAccountSid($sDSID, $sComputer)
			Until $avDU = 0
			$avArray[$u][2] = $sRootKey & $sDSID
			$avArray[$u][3] = 0
		EndIf
		If $sAccount = $sDefaultUser Then
			Local $avNew[2][4] = [["", "", "", ""], [$avArray[$u][0], $avArray[$u][1], $avArray[$u][2], $avArray[$u][3]]]
			$avArray = $avNew
		EndIf
	Else
		Local $avSID = _Security__LookupAccountName($sAccount, $sComputer)
		If $avSID = 0 Then
			$avArray[0][0] = 0
			Return $avArray
		Else
			ProfileAdd($avArray, $avSID[0], $sProfileListKey, $sRootKey)
		EndIf
	EndIf
	$avArray[0][0] = UBound($avArray) - 1
	For $j = 1 To $avArray[0][0]
		$sEnv = StringRegExp($avArray[$j][1], "\x25\S{1,128}\x25", 1)
		If Not @error Then $avArray[$j][1] = StringReplace( $avArray[$j][1], $sEnv[0], EnvGet( StringReplace($sEnv[0], "%", "") ) )
	Next
	Return $avArray
EndFunc ;==> GetProfile

; #INTERNAL_USE_ONLY#============================================================================================================================
; Name...........: ProfileAdd
; Description ...: Add profile data to an array that will be returned by GetProfile function
; Syntax.........: ProfileAdd($avArray, $sSID, $sProfileListKey, $sRootKey)
; Parameters ....: $avArray - Array
;                  $sSID - Account SID
;                  $sProfileListKey - Constant defined inside GetProfile function
;                  $sRootKey - Constant defined inside GetProfile function
; Requirement(s).:
; Return values .:
; Author ........: engine
; Modified.......: AdamUL
; Remarks .......: For internal use only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================================

Func ProfileAdd(ByRef $avArray, $sSID, Const $sProfileListKey, Const $sRootKey)
	Local $sPath, $i
	Local $asSplit = Split_sKey("\" & $sProfileListKey)
	Local $avUser = _Security__LookupAccountSid($sSID, $asSplit[0])
	If Not @error And $avUser <> 0 Then
		If $avUser[2] = 1 Then
			$sPath = RegRead($sProfileListKey & "\" & $sSID, "ProfileImagePath")
			If Not @error Then
				$i = UBound($avArray)
				ReDim $avArray[$i + 1][4]
				$avArray[$i][0] = $avUser[0]
				$avArray[$i][1] = $sPath
				$avArray[$i][2] = $sRootKey & $sSID
				RegEnumKey($sRootKey & $sSID, 1)
				If @error Then
					$avArray[$i][3] = 0
				Else
					$avArray[$i][3] = 1
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc ;==> ProfileAdd

; #INTERNAL_USE_ONLY#============================================================================================================================
; Name...........: Split_sKey
; Description ...: Splits $sKey between computername, username and keyname
; Syntax.........: Split_sKey($sKey)
; Parameters ....: $sKey - Reg function main key
; Requirement(s).:
; Return values .:
; Author ........: engine
; Modified.......:
; Remarks .......: For internal use only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================================

Func Split_sKey($sKey)
	Local $asArray[3]
	If StringInStr($sKey, "\\\") = 1 Then
		Local $asComputer = StringRegExp($sKey, "\\\\\\[^\\]*\\", 1)
		If Not @error Then
			$asArray[0] = StringTrimRight( StringTrimLeft($asComputer[0], 3), 1 )
			$sKey = StringReplace($sKey, $asComputer[0], "\", 1)
			If Not StringInStr($sKey, "\\") = 1 Then $sKey = StringTrimLeft($sKey, 1)
		EndIf
	EndIf
	If $asArray[0] = "" Then $asArray[0] = @ComputerName
	If StringInStr($sKey, "\\") = 1 And Not StringInStr($sKey, "\\\") = 1 Then
		Local $asUser = StringRegExp($sKey, "\\\\[^\\]*\\", 1)
		If Not @error Then
			$asArray[1] = StringTrimRight( StringTrimLeft($asUser[0], 2), 1 )
			$sKey = StringReplace($sKey, $asUser[0], "", 1)
		EndIf
	EndIf
	If Not ( StringInStr($sKey, "\") = 1 Or StringInStr($sKey, "\", 0, -1) = StringLen($sKey) Or StringInStr($sKey, "\\") ) Then
		$asArray[2] = $sKey
	EndIf
	Return $asArray
EndFunc ;==> Split_sKey
