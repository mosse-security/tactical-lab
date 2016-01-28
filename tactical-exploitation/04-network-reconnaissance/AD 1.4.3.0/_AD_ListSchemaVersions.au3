#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; *****************************************************************************
; Example 1
; Returns information about the AD Schema versions
; *****************************************************************************
#include <AD.au3>

Global $aSchema_AD[5][2] = [[13, "Windows 2000 Server"],[30, "Windows Server 2003 RTM / Service Pack 1 / Service Pack 2"],[31, "Windows Server 2003 R2"], _
		[44, "Windows Server 2008 RTM"],[47, "Windows Server 2008 R2"]]
Global $aSchema_Ex[10][2] = [[4397, "Exchange Server 2000 RTM"],[4406, "Exchange Server 2000 With Service Pack 3"],[6870, "Exchange Server 2003 RTM"], _
		[6936, "Exchange Server 2003 With Service Pack 3"],[10628, "Exchange Server 2007"],[11116, "Exchange 2007 With Service Pack 1"], _
		[14622, "Exchange 2007 With Service Pack 2, Exchange 2010 RTM"],[14625, "Exchange 2007 SP3"],[14720, "Exchange 2010 SP1 (beta)"], _
		[14726, "Exchange 2010 SP1"]]
Global $aSchema_ExAD[1][2] = [[4197, "Exchange Server 2000 RTM"]]
Global $aSchema_OCS[4][2] = [[1006, "LCS 2005 SP1"],[1007, "OCS 2007"],[1008, "OCS 2007 R2"],[1100, "Lync Server 2010"]]

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; Get a list of versions for the Schemas and Schema extensions in the AD
Global $aSchemaVersion[5][3] = [[""],["Active Directory Schema version"],["Exchange Schema version"],["Exchange 2000 Active Directory Connector version"],["Office Communications Server Schema version"]]
Global $aTemp = _AD_ListSchemaVersions()
Global $iCount
For $iCount = 1 To $aTemp[0]
	$aSchemaVersion[$iCount][1] = $aTemp[$iCount]
Next
$aSchemaVersion[0][0] = $aTemp[0]

; AD Schema - add description
For $iCount = 0 To UBound($aSchema_AD, 1) - 1
	If $aSchema_AD[$iCount][0] = $aSchemaVersion[1][1] Then $aSchemaVersion[1][2] = $aSchema_AD[$iCount][1]
Next
; Exchange Schema - add description
For $iCount = 0 To UBound($aSchema_Ex, 1) - 1
	If $aSchema_Ex[$iCount][0] = $aSchemaVersion[2][1] Then $aSchemaVersion[2][2] = $aSchema_Ex[$iCount][1]
Next
; Exchange 2000 Active Directory Connector - add description
For $iCount = 0 To UBound($aSchema_ExAD, 1) - 1
	If $aSchema_ExAD[$iCount][0] = $aSchemaVersion[3][1] Then $aSchemaVersion[3][2] = $aSchema_ExAD[$iCount][1]
Next
; Office Communications Server Schema - add description
For $iCount = 0 To UBound($aSchema_OCS, 1) - 1
	If $aSchema_OCS[$iCount][0] = $aSchemaVersion[4][1] Then $aSchemaVersion[4][2] = $aSchema_OCS[$iCount][1]
Next

_ArrayDisplay($aSchemaVersion, "Active Directory Functions - Example 1", -1, 0, "<")

; Close Connection to the Active Directory
_AD_Close()