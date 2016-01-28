#include-once

; #FUNCTION# ====================================================================================================================================
; Name...........: _SetPrivilege
; Description ...: Enables or disables special privileges as required by some DllCalls
; Syntax.........: _SetPrivilege($avPrivilege)
; Parameters ....: $avPrivilege - An array of privileges and respective attributes
;                                 $SE_PRIVILEGE_ENABLED - The function enables the privilege
;                                 $SE_PRIVILEGE_REMOVED - The privilege is removed from the list of privileges in the token
;                                 0 - The function disables the privilege
; Requirement(s).: None
; Return values .: Success - An array of modified privileges and their respective previous attribute state
;                  Failure - An empty array
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================================

Func _SetPrivilege($avPrivilege)
	Local $iDim = UBound($avPrivilege, 0), $avPrevState[1][2]
	If Not ( $iDim <= 2 And UBound($avPrivilege, $iDim) = 2 ) Then Return SetError(1300, 0, $avPrevState)
	If $iDim = 1 Then
		Local $avTemp[1][2]
		$avTemp[0][0] = $avPrivilege[0]
		$avTemp[0][1] = $avPrivilege[1]
		$avPrivilege = $avTemp
		$avTemp = 0
	EndIf
	Local $k, $tagTP = "dword", $iTokens = UBound($avPrivilege, 1)
	Do
		$k += 1
		$tagTP &= ";dword;long;dword"
	Until $k = $iTokens
	Local $tCurrState, $tPrevState, $pPrevState, $tLUID, $hAdvapi32, $hKernel32, $ahGCP, $avOPT, $aiGLE
	$tCurrState = DLLStructCreate($tagTP)
	$tPrevState = DllStructCreate($tagTP)
	$pPrevState = DllStructGetPtr($tPrevState)
	$tLUID = DllStructCreate("dword;long")
	DLLStructSetData($tCurrState, 1, $iTokens)
	$hAdvapi32 = DllOpen("Advapi32.dll")
	For $i = 0 To $iTokens - 1
		DllCall( $hAdvapi32, "int", "LookupPrivilegeValue", _
			"str", "", _
			"str", $avPrivilege[$i][0], _
			"ptr", DllStructGetPtr($tLUID) )
		DLLStructSetData( $tCurrState, 3 * $i + 2, DllStructGetData($tLUID, 1) )
		DLLStructSetData( $tCurrState, 3 * $i + 3, DllStructGetData($tLUID, 2) )
		DLLStructSetData( $tCurrState, 3 * $i + 4, $avPrivilege[$i][1] )
	Next
	$hKernel32 = DllOpen("Kernel32.dll")
	$ahGCP = DllCall($hKernel32, "hwnd", "GetCurrentProcess")
	$avOPT = DllCall( $hAdvapi32, "int", "OpenProcessToken", _
		"hwnd", $ahGCP[0], _
		"dword", BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY), _
		"hwnd*", 0 )
	DllCall( $hAdvapi32, "int", "AdjustTokenPrivileges", _
		"hwnd", $avOPT[3], _
		"int", False, _
		"ptr", DllStructGetPtr($tCurrState), _
		"dword", DllStructGetSize($tCurrState), _
		"ptr", $pPrevState, _
		"dword*", 0 )
	$aiGLE = DllCall($hKernel32, "dword", "GetLastError")
	DllCall($hKernel32, "int", "CloseHandle", "hwnd", $avOPT[3])
	DllClose($hKernel32)
	Local $iCount = DllStructGetData($tPrevState, 1)
	If $iCount > 0 Then
		Local $pLUID, $avLPN, $tName, $avPrevState[$iCount][2]
		For $i = 0 To $iCount - 1
			$pLUID = $pPrevState + 12 * $i + 4
			$avLPN = DllCall( $hAdvapi32, "int", "LookupPrivilegeName", _
				"str", "", _
				"ptr", $pLUID, _
				"ptr", 0, _
				"dword*", 0 )
			$tName = DllStructCreate("char[" & $avLPN[4] & "]")
			DllCall( $hAdvapi32, "int", "LookupPrivilegeName", _
				"str", "", _
				"ptr", $pLUID, _
				"ptr", DllStructGetPtr($tName), _
				"dword*", DllStructGetSize($tName) )
			$avPrevState[$i][0] = DllStructGetData($tName, 1)
			$avPrevState[$i][1] = DllStructGetData($tPrevState, 3 * $i + 4)
		Next
	EndIf
	DllClose($hAdvapi32)
	Return SetError($aiGLE[0], 0, $avPrevState)
EndFunc ;==> _SetPrivilege
