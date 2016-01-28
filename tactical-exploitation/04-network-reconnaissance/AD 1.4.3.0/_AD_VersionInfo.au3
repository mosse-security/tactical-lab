#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y

#include <AD.au3>

;------------------------------------------------------------------------------------------------------------------------------------------------
; Example 1 - Display the version info for this UDF
;------------------------------------------------------------------------------------------------------------------------------------------------
Global $aVersionInfo = _AD_VersionInfo()
Global $aResult[9][2] = [[8,2],["Release type", $aVersionInfo[1]],["Major version", $aVersionInfo[2]],["Minor version", $aVersionInfo[3]], _
	["Sub version", $aVersionInfo[4]],["Release date", $aVersionInfo[5]],["AutoIt version required", $aVersionInfo[6]],["Authors", $aVersionInfo[7]], _
	["Contributors", $aVersionInfo[8]]]
_ArrayDisplay($aResult, "Active Directory Functions - Version Info for the UDF")
