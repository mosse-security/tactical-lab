#include <Array.au3>
Global $fwMgr, $profile

; ===========================================================================================================================
; Title .........: Windows Firewall UDF
; AutoIt Version : 3.3.10.0
; UDF Version ...: 2.0.22
; Language ......: English
; Description ...: Functions for manipulating the Windows Firewall
; OS Support.....: 32-bit and 64-bit support for XP, Windows 7 and Windows 8.1
; Author.........: JLogan3o13
;
; Function List:
; ==================
; _AddAuthorizedApp
; _AddPort
; _AllowExceptions
; _ClosePort
; _DeleteAuthorizedApp
; _DeleteOpenPort
; _DenyExceptions
; _DisableFirewall
; _DisableNotifications
; _EnableFirewall
; _EnableNotifications
; _ListAuthorizedApps
; _ListAuthorizedPorts
; _ListFirewallProperties
; _OpenPort
; _RestoreDefault
;============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........:  _AddAuthorizedApp
; Description ...:  Adds an Application to the Windows Firewall Exception List
; Syntax.........:  _AddAuthorizedApp($Name, $FilePath, $IPVer = 2, $Scope = 0, $Enabled = False)
; Parameters.....:  $Name - Friendly name for the application.
;      			    $FilePath - Path to executable.
;      			    $IPVer -  IP Version (usually 2)
;      			    $Scope - The scope of computers for which this executable is allowed. Options are:
;     			   	   0 - Any (default)
;     				   1 - My network (subnet) only
;     				   2 - Custom list
;      			    $Enabled - Create the application as initially disabled or enabled. Default is disabled
; Return values...: Success: Adds an Application to the Firewall Exception List.
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;					   3 = Failed to create the Authorized Application object
;                      4 = Failed to create a list of Authorized Applications
;                      5 = Application already Exists in Exceptions List
;					   6 = $FilePath cannot be resolved
;  					   7 = Failed to add $authApp to Firewall Profile
; XP Example........: _AddAuthorizedApp("Movie Maker", @ProgramFilesDir & "\Movie Maker\moviemk.exe", 2, 0, True)
; WIN7/8 Example....: _AddAuthorizedApp("WinMail", @ProgramFilesDir & "\Windows Mail\wab.exe", 2, 1, Default)
; ===============================================================================================================================
Func _AddAuthorizedApp($Name, $FilePath, $IPVer = 2, $Scope = 0, $Enabled = False)
	_createFWMgrObject()

	Local $authApp = ObjCreate("HNetCfg.FwAuthorizedApplication")
		If Not IsObj($authApp) Or @error <> 0 Then
			Return SetError(1, 3, "")
		Else
			Local $aApps = $profile.AuthorizedApplications
				If @error Then Return SetError(1, 4, "")
			Local $appCount = $aApps.Count
			Local $appsArray[$aApps.Count][6]
			Local $iIndex = 0

			For $app In $aApps
				If $app.Name = $Name Then Return SetError(1, 5, "")
			Next

			$authApp.Name = $Name
			$authApp.IpVersion = $IPVer
			$authApp.ProcessImageFileName = $FilePath
				If @error Then Return SetError(1, 6, "")
			$authApp.Scope = $Scope
			$authApp.Enabled = $Enabled
			$profile.AuthorizedApplications.Add($authApp)
				If @error <> 0 Then Return SetError(1, 7, "")
		EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name............: _AddPort
; Description ....: Adds a Custom Port to the Windows Firewall Exception List
; Syntax..........: _AddPort($Name, $PortNumber, $Scope, $Protocol = 6, $Enabled = False)
; Parameters .....: $Name - Friendly Name for the Port.
;      			    $PortNumber - Number for the Port.
;      			    $Scope - The scope of computers for which this port is allowed. Options are:
;     			       0 - Any
;     				   1 - My network (subnet) only
;     				   2 - Custom list
;      			    $Protocol - TCP (6)[default] or UDP (17)
;      			    $Enabled - Create the port as initially disabled (default) or enabled. You MUST surround this in quotes for Win7
; Return values...: Success: Adds a Custom Port to the Windows Firewall Exception List
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = The specified Port Number Already Exists and is Enabled
;					   4 = The specified Port Number Already Exists but is Disabled
;					   5 = Failed to create the Firewall Open Port object
;                      6 = Failed to create the Port
; Example........: _AddPort("MyTestPort", 9999, 0, 6, "True")
; ===============================================================================================================================
Func _AddPort($Name, $PortNumber, $Scope, $Protocol = 6, $Enabled = "False")
	_createFWMgrObject()

	Local $aPorts = $profile.GloballyOpenPorts
	Local $PortNum = $aPorts.Item($PortNumber,$Protocol)
		If IsObj($PortNum) Then
			If $PortNum.Enabled = True Then
				Return SetError(1, 3, "")
			ElseIf $PortNum.Enabled = False Then
				Return SetError(1, 4, "")
			EndIf
		Else
			$port = ObjCreate("HNetCfg.FWOpenPort")
				If Not IsObj($port) Then Return SetError(1, 5, "")
			$port.Name = $Name
			$port.Port = $PortNumber
			$port.Scope = $Scope
			$port.Protocol = $Protocol
			$port.Enabled = $Enabled
			$profile.GloballyOpenPorts.Add($port)
				If @error <> 0 Then Return SetError(1, 6, "")
		EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _AllowExceptions
; Description ...: Enable the Firewall Exceptions List
; Syntax.........: _AllowExceptions()
; Parameters ....: None.
; Return values...: Success: Enables Exceptions in the current Firewall Profile.
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = Exceptions are Already Allowed
;                      4 = Failed to enable Exceptions
; Example........: _AllowExceptions()
; ===============================================================================================================================
Func _AllowExceptions()
	_createFWMgrObject()

	If $profile.ExceptionsNotAllowed = False Then
		Return SetError(1, 3, "")
	Else
		$profile.ExceptionsNotAllowed = False
			If @error <> 0 Then Return SetError(1, 4, "")
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _ClosePort
; Description ...: Closes an Existing, Enabled Port.
; Syntax.........: _ClosePort($PortNumber,$Protocol)
; Parameters ....: $PortNumber - Number for the Port.
;                  $Protocol - TCP (6)[default] or UDP (17)
; Return values...: Success: Closes an Open Port:
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = No Ports are currently specified in the Exceptions List
;					   4 = The specified Port Number or Protocol is incorrect
;					   5 = The Specified Port Number is already Closed
; Example........: _ClosePort(9999,6)
; ===============================================================================================================================
Func _ClosePort($PortNumber, $Protocol)
	_createFWMgrObject()

 	$aPorts = $profile.GloballyOpenPorts
		If $aPorts.Count = 0 Then Return SetError(1, 3, "")

	$PortNum = $aPorts.Item($PortNumber,$Protocol)
		If Not IsObj($PortNum) Then
			Return SetError(1, 4, "")
		Else
			If $PortNum.Enabled = True Then
				$PortNum.Enabled = "False"
			Else
				Return SetError(1, 5, "")
			EndIf
		EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........:  _DeleteAuthorizedApp
; Description ...:  Deletes an Authorized Application from the Exceptions List.
; Syntax.........:  _DeleteAuthorizedApp($Path)
; Parameters ....:  $Path - Path to Executable for Authorized Application.
; Return values...: Success: Deletes a previoussly Authorized Application from the Firewall Exceptions List.
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = Failed to create a list of Authorized Applications
;                      4 = Incorrect $Path, or Application not found in Authorized Applications list.
;					   5 = Failed to Remove Application from list of Authorized Applications
; Example........: _DeleteAuthorizedApp(@ProgramFilesDir & "\Movie Maker\moviemk.exe")
; ===============================================================================================================================
Func _DeleteAuthorizedApp($Path)
	_createFWMgrObject()

	Local $success = 0
	Local $aApps = $profile.AuthorizedApplications
		If @error <> 0 Then
			Return SetError(1, 3, "")
		Else
			For $app In $aApps
				If $app.ProcessImageFileName = $Path Then
					$success = 1
					ExitLoop
				EndIf
			Next
		EndIf

		If $success <> 1 Then
			Return SetError(1, 4, "")
		Else
			$aApps.Remove($Path)
				If @error <> 0 Then Return SetError(1, 5, "")
		EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _DeletePort
; Description ...: Deletes a Port from the Exceptions List
; Syntax.........: _DeletePort($PortNumber, $Protocol = 6)
; Parameters ....: $PortNumber - The port number to be deleted.
;      			   $Protocol - TCP (6)[default] or UDP (17)
; Return values...: Success: Deletes a Port from the Exceptions List:
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = No Ports are currently specified in the Exceptions List
;					   4 = The specified Port Number Does Not Exist in the Exceptions List
;					   5 = The Specified Protocol is Incorrect
; Example........: _DeletePort(9999, 6)
; ===============================================================================================================================
Func _DeletePort($PortNumber, $Protocol = 6)
	_createFWMgrObject()

	Local $success = 0
	Local $aPorts = $profile.GloballyOpenPorts
		If $aPorts.Count = 0 Then Return SetError(1, 3, "")

	For $ports In $aPorts
		If $ports.Port = $PortNumber Then
			$success = 1
			ExitLoop
		EndIf
	Next

	If $success <> 1 Then
		Return SetError(1, 4, "")
	Else
		Local $PortNum = $aPorts.Item($PortNumber,$Protocol)
			If Not IsObj($PortNum) Then
				Return SetError(1, 5, "")
			Else
				$aApps = $profile.GloballyOpenPorts
				$aApps.Remove($PortNumber, $Protocol)
			EndIf
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _DenyExceptions
; Description ...: Disable the Firewall Exceptions List
; Syntax.........: _DenyExceptions()
; Parameters ....: None.
; Return values...: Success: Disables Exceptions in the current Firewall Profile.
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = Exceptions are Already Denied
;                      4 = Failed to Deny Exceptions
; Example........: _DenyExceptions()
; ===============================================================================================================================
Func _DenyExceptions()
	_createFWMgrObject()

	If $profile.ExceptionsNotAllowed = True Then
		Return SetError(1, 3, "")
	Else
		$profile.ExceptionsNotAllowed = True
			If @error <> 0 Then Return SetError(1, 4, "")
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _DisableFirewall
; Description ...: Disables the Windows Firewall
; Syntax.........: _DisableFirewall()
; Parameters ....: None
; Return values...: Success: Disables the Windows Firewall.
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = Firewall is Already Disabled
;                      4 = Failed to Disable Firewall
; Example........: _DisableFirewall()
; ===============================================================================================================================
Func _DisableFirewall()
	If @OSVersion = "WIN_XP" Then
		_createFWMgrObject()
			If $profile.FirewallEnabled = False Then
				Return SetError(1, 3, "")
			Else
				$profile.FirewallEnabled = False
					If @error <> 0 Then Return SetError(1, 4, "")
			EndIf
	Else
		$fwMgr = ObjCreate("HNetCfg.FwPolicy2")
			If @error <> 0 Then Return SetError(1, 1, "")
		$profile = $fwMgr.CurrentProfileTypes
			If @error <> 0 Then Return SetError(1, 2, "")

		If $fwMgr.FirewallEnabled($profile) = False Then
			Return SetError(1,3, "")
		Else
			$fwMgr.FirewallEnabled($profile) = False
				If @error <> 0 Then Return SetError(1, 4, "")
		EndIf
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _DisableNotifications
; Description ...: Disables Notification when Windows Firewall Blocks a Program
; Syntax.........: _DisableNotifications()
; Parameters ....: None
; Return values...: Success: Disables Notifications in the current Firewall Profile.
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = Notifications are Already Disabled
;                      4 = Failed to Disable Notifications
; Example........: _DisableNotifications()
; ===============================================================================================================================
Func _DisableNotifications()
	_createFWMgrObject()

	If $profile.NotificationsDisabled = True Then
		Return SetError(1, 3, "")
	Else
		$profile.NotificationsDisabled = True
			If @error <> 0 Then Return SetError(1, 4, "")
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _EnableFirewall
; Description ...: Enables the Windows Firewall
; Syntax.........: _EnableFirewall()
; Parameters ....: None
; Return values...: Success: Enables the Windows Firewall.
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = Firewall is Already Enabled
;                      4 = Failed to Enable Firewall
; Example........: _EnableFirewall()
; ===============================================================================================================================
Func _EnableFirewall()
	If @OSVersion = "WIN_XP" Then
		_createFWMgrObject()
			If $profile.FirewallEnabled = True Then
				Return SetError(1, 3, "")
			Else
				$profile.FirewallEnabled = True
					If @error <> 0 Then Return SetError(1, 4, "")
			EndIf
	Else
		$fwMgr = ObjCreate("HNetCfg.FwPolicy2")
			If @error <> 0 Then Return SetError(1, 1, "")
		$profile = $fwMgr.CurrentProfileTypes
			If @error <> 0 Then Return SetError(1, 2, "")

		If $fwMgr.FirewallEnabled($profile) = True Then
			Return SetError(1,3, "")
		Else
			$fwMgr.FirewallEnabled($profile) = True
				If @error <> 0 Then Return SetError(1, 4, "")
		EndIf
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _EnableNotifications
; Description ...: Enables Notification when Windows Firewall Blocks a Program
; Syntax.........: _EnableNotifications()
; Parameters ....: None
; Return values...: Success: Enables Notifications in the current Firewall Profile.
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = Notifications are Already Enabled
;                      4 = Failed to Enable Notifications
; Example........: _EnableNotifications()
; ===============================================================================================================================
Func _EnableNotifications()
	_createFWMgrObject()

	If $profile.NotificationsDisabled = False Then
		Return SetError(1, 3, "")
	Else
		$profile.NotificationsDisabled = False
			If @error <> 0 Then Return SetError(1, 4, "")
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _ListAuthorizedApps
; Description ...: List Properties of Applications in the Exceptions List
; Syntax.........: _ListAuthorizedApps()
; Parameters ....: None
; Return values..: Success: Returns and Array Showing the Currently Authorized Applications in the Firewall Exceptions List.
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = Failed to create a list of Authorized Applications
;					   4 = No Applications Found in Exceptions List
; Example........: _ListAuthorizedApps()
; ===============================================================================================================================
Func _ListAuthorizedApps()
	_createFWMgrObject()

	Local $aApps = $profile.AuthorizedApplications
		If @error <> 0 Then Return SetError(1, 3, "")
	Local $appCount = $aApps.Count
		If $appCount < 1 Then Return SetError(1, 4, "")
	Local $appsArray[$aApps.Count][6]
	Local $iIndex = 0

		For $app In $aApps
			$appsArray[$iIndex][0] = $app.Name
			$appsArray[$iIndex][1] = $app.Enabled
			$appsArray[$iIndex][2] = $app.IPVersion
			$appsArray[$iIndex][3] = $app.ProcessImageFileName
			$appsArray[$iIndex][4] = $app.RemoteAddresses
			$appsArray[$iIndex][5] = $app.Scope
			$iIndex = $iIndex + 1
		Next

	_ArrayDisplay($appsArray, "All Authorized Applications", Default, Default, Default, "Application Name|Enabled - True or False|IP Version|File Name|Remote Addresses|Scope", Default)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _ListAuthorizedPorts
; Description ...: List Properties of Ports in the Exceptions List
; Syntax.........: _ListAuthorizedPorts()
; Return values...: Success: Closes an Open Port:
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = No Ports are currently specified in the Exceptions List
; Example........: _ListAuthorizedPorts()
; ===============================================================================================================================
Func _ListAuthorizedPorts()
	_createFWMgrObject()

	Local $err = 0
	$aPorts = $profile.GloballyOpenPorts
	$portCount = $aPorts.Count
		If $portCount < 1 Then Return SetError(1, 3, "")

	Local $aArray[$portCount][8]
	Local $iIndex = 0
		For $port In $aPorts
			$aArray[$iIndex][0] = $port.Name
			$aArray[$iIndex][1] = $port.Port
			$aArray[$iIndex][2] = $port.IPVersion
			$aArray[$iIndex][3] = $port.Protocol
			$aArray[$iIndex][4] = $port.RemoteAddresses
			$aArray[$iIndex][5] = $port.Scope
			$aArray[$iIndex][6] = $port.Enabled
			$aArray[$iIndex][7] = $port.Builtin
			$iIndex = $iIndex + 1
		Next

	_ArrayDisplay($aArray, "All Authorized Ports", Default, Default, Default, "Port Name|Port Number|IP Version|Protocol TCP(6) or UDP(17)" & _
  "|Remote Addresses|Scope|Enabled|Builtin", Default)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _ListFirewallProperties
; Description ...: List Properties of the Windows Firewall
; Syntax.........: _ListFirewallProperties()
; Parameters ....: None
; Return values...: Success: Lists Properties Associated with the Current Firewall Profile
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = Failed to return Firewall Properties
; Example........: _ListFirewallProperties()
; ===============================================================================================================================
Func _ListFirewallProperties()
	_createFWMgrObject()

	MsgBox(0, "Firewall Properties", "Current profile type: " & $fwMgr.CurrentProfileType & @CRLF & @CRLF & _
   "Firewall enabled: " & $profile.FirewallEnabled & @CRLF & @CRLF & _
   "Exceptions not allowed: " & $profile.ExceptionsNotAllowed & @CRLF & @CRLF & _
   "Notifications disabled: " & $profile.NotificationsDisabled & @CRLF & @CRLF & _
   "Unicast responses to multicast broadcast disabled: " & $profile.UnicastResponsestoMulticastBroadcastDisabled)
		If @error <> 0 Then Return SetError(1, 3, "")
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _OpenPort
; Description ...: Opens an Existing, Disabled port.
; Syntax.........: _OpenPort($PortNumber,$Protocol)
; Parameters ....: $PortNumber - Number for the port.
;      			   $Protocol - TCP (6)[default] or UDP (17)
; Return values...: Success: Opens a Closed Port:
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = No Ports are currently specified in the Exceptions List
;					   4 = The specified Port Number or Protocol is incorrect
;					   5 = The Specified Port Number is already open
; Example........: _OpenPort(9999,6)
; ===============================================================================================================================
Func _OpenPort($PortNumber, $Protocol)
	_createFWMgrObject()

	$aPorts = $profile.GloballyOpenPorts
		If $aPorts.Count = 0 Then Return SetError(1, 3, "")

	$PortNum = $aPorts.Item($PortNumber,$Protocol)
		If Not IsObj($PortNum) Then
			Return SetError(1, 4, "")
		Else
			If $PortNum.Enabled = False Then
				$PortNum.Enabled = "True"
			Else
				Return SetError(1, 5, "")
			EndIf
		EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _RestoreDefault
; Description ...: Restores the Default Windows Firewall Configuration.
; Syntax.........: _RestoreDefault()
; Parameters ....: None
; Return values...: Success: Resets Firewall Properties to Default Settings
;					Failure: @error set to 1 with a null string. @extended set to the following:
;                      1 = Failed to create Firewall Manager object
;                      2 = Failed to bind to Local Firewall Policy
;                      3 = Failed to reset Firewall Properties
; Example........: _RestoreDefault()
; ===============================================================================================================================
Func _RestoreDefault()
 _createFWMgrObject()

 $fwMgr.RestoreDefaults()
	If @error <> 0 Then Return SetError(1, 3, "")
EndFunc

; #Internal Use Only#============================================================================================================
; #FUNCTION# ====================================================================================================================
; Name...........: _RestoreDefault
; Description ...: Restores the default Windows Firewall configuration.
; Syntax.........: _RestoreDefault()
; Parameters ....: None
; ===============================================================================================================================
Func _createFWMgrObject()
	$fwMgr = ObjCreate("HNetCfg.FwMgr")
		If Not IsObj($fwMgr) Or @error <> 0 Then Return SetError(1, 1, 0)

	$profile = $fwMgr.LocalPolicy.CurrentProfile
		If @error <> 0 Then Return SetError(1, 2, "")
EndFunc
