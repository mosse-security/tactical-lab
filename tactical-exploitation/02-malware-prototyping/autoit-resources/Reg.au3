#include-once
#include <SecurityConstants.au3>
#include ".\SecurityEx.au3"

; #INDEX# =======================================================================================================================================
; Title .........: Reg
; AutoIt Version : 3.2.10++
; Language ......: English
; Description ...: Perform operations with registry files
; ===============================================================================================================================================

; #CURRENT# =====================================================================================================================================
;_RegLoadHive
;_RegRestoreHive
;_RegSaveHive
;_RegUnloadHive
; ===============================================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================================
;RegCloseKey
;RegConnectRegistry
;RegCreateKeyEx
;RegOpenKeyEx
;Split_sRootKey
; ===============================================================================================================================================

Global Const $KEY_READ = 0x20019
Global Const $KEY_WRITE = 0x20006

; #FUNCTION# ====================================================================================================================================
; Name...........: _RegLoadHive
; Description ...: Loads a file as a registry hive
; Syntax.........: _RegLoadHive($sFile, $sKey)
; Parameters ....: $sFile - Full path to the file to be loaded
;                  $sKey - Registry key to load the file to
;                          Must start with HKEY_LOCAL_MACHINE or HKEY_USERS
; Requirement(s).: None
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......: It is possible to access remote registries by using $sRootKey in the form "\\computername\keyname"
;                  If a remote computer is specified than $sFile is relative to that computer
;                  You can only load registry hives to a subkey immediately below HKEY_LOCAL_MACHINE or HKEY_USERS
; Related .......:
; Link ..........;
; Examples ......;  _RegLoadHive("C:\Documents and Settings\Guest\ntuser.dat", "HKU\TempHive")
;                   _RegLoadHive("C:\Documents and Settings\Guest\ntuser.dat", "HKLM\TempHive")
;                   _RegLoadHive("C:\Documents and Settings\Administrator\ntuser.dat", "\\computername\HKU\S-1-5-21-domain-500")
;                   _RegLoadHive("C:\Documents and Settings\Guest\ntuser.dat", "\\computername\HKEY_USERS\S-1-5-21-domain-501")
; ===============================================================================================================================================

Func _RegLoadHive($sFile, $sKey)
	Local $avArray = Split_sRootKey($sKey)
	Local $hKey = RegConnectRegistry($avArray[0], $avArray[1])
	Local $avCurr[2][2] = [[$SE_RESTORE_NAME, $SE_PRIVILEGE_ENABLED], [$SE_BACKUP_NAME, $SE_PRIVILEGE_ENABLED]]
	Local $avPrev = _SetPrivilege($avCurr)
	Local $avRLH = DllCall("Advapi32.dll", "long", "RegLoadKey", "hwnd", $hKey, "str", $avArray[2], "str", $sFile)
	_SetPrivilege($avPrev)
	RegCloseKey($hKey)
	Return SetError( $avRLH[0], 0, Number($avRLH[0] = 0) )
EndFunc ;==> _RegLoadHive

; #FUNCTION# ====================================================================================================================================
; Name...........: _RegRestoreHive
; Description ...: Reads the registry information in a specified file and copies it over the specified key
; Syntax.........: _RegRestoreHive($sFile, $sKey)
; Parameters ....: $sFile - The name of the file with the registry information
;                  $sKey - Registry key
; Requirement(s).: None
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......: It is possible to access remote registries by using $sKey in the form "\\computername\keyname"
;                  If a remote computer is specified than $sFile is relative to that computer
; Related .......:
; Link ..........;
; Example .......;  _RegRestoreHive("HKCU.dat", "\\" & @ComputerName & "\HKCU")
; ===============================================================================================================================================

Func _RegRestoreHive($sFile, $sKey)
	Local Const $REG_FORCE_RESTORE = 0x00000008
	Local $avArray = Split_sRootKey($sKey)
	Local $hRoot = RegConnectRegistry($avArray[0], $avArray[1])
	Local $hKey = RegCreateKeyEx( $hRoot, $avArray[2], BitOR($KEY_READ, $KEY_WRITE) )
	RegCloseKey($hRoot)
	Local $avCurr[2][2] = [[$SE_RESTORE_NAME, $SE_PRIVILEGE_ENABLED], [$SE_BACKUP_NAME, $SE_PRIVILEGE_ENABLED]]
	Local $avPrev = _SetPrivilege($avCurr)
	Local $avRRK = DllCall("Advapi32.dll", "long", "RegRestoreKey", "hwnd", $hKey, "str", $sFile, "dword", $REG_FORCE_RESTORE)
	_SetPrivilege($avPrev)
	RegCloseKey($hKey)
	Return SetError( $avRRK[0], 0, Number($avRRK[0] = 0) )
EndFunc ;==> _RegRestoreHive

; #FUNCTION# ====================================================================================================================================
; Name...........: _RegSaveHive
; Description ...: Saves the specified key and all of its subkeys and values to a new file, in the standard format
; Syntax.........: _RegSaveHive($sFile, $sKey)
; Parameters ....: $sFile - The name of the file in which the specified key and subkeys are to be saved
;                  $sKey - Registry key
; Requirement(s).: None
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......: It is possible to access remote registries by using $sKey in the form "\\computername\keyname"
; Related .......:
; Link ..........;
; Example .......;  _RegSaveHive("HKCU.dat", "\\" & @ComputerName & "\HKCU")
; ===============================================================================================================================================

Func _RegSaveHive($sFile, $sKey)
	Local $avArray = Split_sRootKey($sKey)
	Local $hRoot = RegConnectRegistry($avArray[0], $avArray[1])
	Local $hKey = RegOpenKeyEx($hRoot, $avArray[2], $KEY_READ)
	RegCloseKey($hRoot)
	Local $avCurr[2] = [$SE_BACKUP_NAME, $SE_PRIVILEGE_ENABLED]
	Local $avPrev = _SetPrivilege($avCurr)
	Local $avRSK = DllCall("Advapi32.dll", "long", "RegSaveKey", "hwnd", $hKey, "str", $sFile, "ptr", 0)
	_SetPrivilege($avPrev)
	RegCloseKey($hKey)
	Return SetError( $avRSK[0], 0, Number($avRSK[0] = 0) )
EndFunc ;==> _RegSaveHive

; #FUNCTION# ====================================================================================================================================
; Name...........: _RegUnloadHive
; Description ...: Unloads a registry hive
; Syntax.........: _RegUnloadHive($sKey)
; Parameters ....: $sKey - Registry key to unload the hive from
; Requirement(s).: None
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......: It is possible to access remote registries by using $sKey in the form "\\computername\keyname"
; Related .......:
; Link ..........;
; Examples ......;  _RegUnloadHive("HKU\TempHive")
;                   _RegUnloadHive("HKLM\TempHive")
;                   _RegUnloadHive("\\computername\HKU\S-1-5-21-domain-500")
;                   _RegUnloadHive("\\computername\HKEY_USERS\S-1-5-21-domain-501")
; ===============================================================================================================================================

Func _RegUnloadHive($sKey)
	Local $avArray = Split_sRootKey($sKey)
	Local $hKey = RegConnectRegistry($avArray[0], $avArray[1])
	Local $avCurr[2][2] = [[$SE_RESTORE_NAME, $SE_PRIVILEGE_ENABLED], [$SE_BACKUP_NAME, $SE_PRIVILEGE_ENABLED]]
	Local $avPrev = _SetPrivilege($avCurr)
	Local $avRUH = DllCall("Advapi32.dll", "long", "RegUnLoadKey", "hwnd", $hKey, "str", $avArray[2])
	_SetPrivilege($avPrev)
	RegCloseKey($hKey)
	Return SetError( $avRUH[0], 0, Number($avRUH[0] = 0) )
EndFunc ;==> _RegUnloadHive

; #INTERNAL_USE_ONLY#============================================================================================================================
; Name...........: RegCloseKey
; Description ...: Closes a handle to the specified registry key
; Syntax.........: RegCloseKey($hKey)
; Parameters ....: $hKey - Registry key handle to close
; Requirement(s).: None
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......: For internal use only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================================

Func RegCloseKey($hKey)
	Local $avRCK = DllCall("Advapi32.dll", "long", "RegCloseKey", "hwnd", $hKey)
	Return SetError( $avRCK[0], 0, Number($avRCK[0] = 0) )
EndFunc ;==> RegCloseKey

; #INTERNAL_USE_ONLY#============================================================================================================================
; Name...........: RegConnectRegistry
; Description ...: Establishes a connection to a predefined registry key on another computer
; Syntax.........: RegConnectRegistry($sComputer, $hKey)
; Parameters ....: $sComputer - Computer name in the form '\\computername'
;                  $hKey - Predefined registry key handle
; Requirement(s).: Service 'RemoteRegistry' running on the target computer
;                  When the target computer is the local computer, the 'RemoteRegistry' service isn't required
; Return values .: Success - Registry key handle
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......: For internal use only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================================

Func RegConnectRegistry($sComputer, $hKey)
	Local $avRCR = DllCall( "Advapi32.dll", "long", "RegConnectRegistry", _
		"str", $sComputer, _
		"hwnd", $hKey, _
		"hwnd*", 0 )
	Return SetError($avRCR[0], 0, $avRCR[3])
EndFunc ;==> RegConnectRegistry

; #INTERNAL_USE_ONLY#============================================================================================================================
; Name...........: RegCreateKeyEx
; Description ...: Creates the specified registry key
; Syntax.........: RegCreateKeyEx($kKey, $sSubKey, $iAccess)
; Parameters ....: $hKey - Predefined registry key handle
;                  $sSubKey - The name of the registry subkey to be created
;                  $iAccess - A mask that specifies the desired access rights to the key
; Requirement(s).: None
; Return values .: Success - Registry key handle
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......: For internal use only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================================

Func RegCreateKeyEx($kKey, $sSubKey, $iAccess)
	Local Const $REG_OPTION_NON_VOLATILE = 0x00000000
	Local $avRCKE = DllCall( "Advapi32.dll", "long", "RegCreateKeyEx", _
		"hwnd", $kKey, _
		"str", $sSubKey, _
		"dword", 0, _
		"ptr", 0, _
		"dword", $REG_OPTION_NON_VOLATILE, _
		"dword", $iAccess, _
		"ptr", 0, _
		"hwnd*", 0, _
		"ptr", 0 )
	Return SetError($avRCKE[0], 0, $avRCKE[8])
EndFunc ;==> RegCreateKeyEx

; #INTERNAL_USE_ONLY#============================================================================================================================
; Name...........: RegOpenKeyEx
; Description ...: Opens the specified registry key
; Syntax.........: RegOpenKeyEx($hKey, $sSubKey, $iAccess)
; Parameters ....: $hKey - Predefined registry key handle
;                  $sSubKey - The name of the registry subkey to be opened
;                  $iAccess - A mask that specifies the desired access rights to the key
; Requirement(s).: None
; Return values .: Success - Registry key handle
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......: For internal use only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================================

Func RegOpenKeyEx($hKey, $sSubKey, $iAccess)
	Local $avROKE = DllCall( "Advapi32.dll", "long", "RegOpenKeyEx", _
		"hwnd", $hKey, _
		"str", $sSubKey, _
		"dword", 0, _
		"dword", $iAccess, _
		"hwnd*", 0 )
	Return SetError($avROKE[0], 0, $avROKE[5])
EndFunc ;==> RegOpenKeyEx

; #INTERNAL_USE_ONLY#============================================================================================================================
; Name...........: Split_sRootKey
; Description ...: Splits $sRootKey between computer name, predefined registry key handle and subkey
; Syntax.........: Split_sRootKey($sRootKey)
; Parameters ....: $sRootKey - Reg function main key
; Requirement(s).: None
; Return values .: Returns an array where:
;                  $array[0] = \\computername
;                  $array[1] = Predefined registry key handle
;                  $array[2] = Subkey
; Author ........: engine
; Modified.......:
; Remarks .......: For internal use only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================================

Func Split_sRootKey($sRootKey)
	Local Const $HKEY_CLASSES_ROOT = 0x80000000
	Local Const $HKEY_CURRENT_USER = 0x80000001
	Local Const $HKEY_LOCAL_MACHINE = 0x80000002
	Local Const $HKEY_USERS = 0x80000003
	Local Const $HKEY_CURRENT_CONFIG = 0x80000005
	Local $avHKEY[5][3] = [["HKCR", "HKEY_CLASSES_ROOT", $HKEY_CLASSES_ROOT], _
	["HKCU", "HKEY_CURRENT_USER", $HKEY_CURRENT_USER], _
	["HKLM", "HKEY_LOCAL_MACHINE", $HKEY_LOCAL_MACHINE], _
	["HKU", "HKEY_USERS", $HKEY_USERS], _
	["HKCC", "HKEY_CURRENT_CONFIG", $HKEY_CURRENT_CONFIG]]
	Local $avArray[3]
	If StringInStr($sRootKey, "\\") = 1 Then
		Local $asComputer = StringRegExp($sRootKey, "\\\\[^\\]*\\", 1)
		If Not @error Then
			$avArray[0] = StringTrimRight($asComputer[0], 1)
			$sRootKey = StringReplace($sRootKey, $asComputer[0], "", 1)
		EndIf
	EndIf
	If StringInStr($sRootKey, "\") = 1 Or StringInStr($sRootKey, "\", 0, -1) = StringLen($sRootKey) Or StringInStr($sRootKey, "\\") Then
		$avArray[0] = ""
		Return $avArray
	Else
		Local $asSplit = StringSplit($sRootKey, "\")
		For $i = 0 To UBound($avHKEY) - 1
			If $asSplit[1] = $avHKEY[$i][0] Or $asSplit[1] = $avHKEY[$i][1] Then
				$avArray[1] = $avHKEY[$i][2]
				ExitLoop
			EndIf
		Next
		If $avArray[1] = "" Then
			$avArray[0] = ""
			Return $avArray
		EndIf
		For $i = 2 To $asSplit[0] - 1
			$avArray[2] &= $asSplit[$i] & "\"
		Next
		If $asSplit[0] > 1 Then $avArray[2] &= $asSplit[ $asSplit[0] ]
	EndIf
	Return $avArray
EndFunc ;==> Split_sRootKey
