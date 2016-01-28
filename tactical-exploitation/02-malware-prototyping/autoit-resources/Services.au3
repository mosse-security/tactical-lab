;created By arcker, for autoit community
#include-once
;#include "Log.au3"
#include "WinAPI.au3"
#include "ServicesConstants.au3"
;~ Dim $bMainStopped = False
;~ Dim $gServiceStateRunning = False
Dim $bAU3ServiceDebug = false
Dim $hAdvapi32_DLL = DllOpen("Advapi32.dll")
Dim $hKernel32_DLL = DllOpen("kernel32.dll")
;~ Dim $gdwCheckPoint = 1
Dim $sServiceName = "Autoit_Service"
Dim  $bServiceRunning = False, $iServiceCounter = 1
; const

; Globals for Au3@service routines
Dim $tServiceName,$tServiceCtrl,$tServiceMain;,$service_debug_mode = False
Dim $tService_Status = DllStructCreate("dword dwServiceType;" & _
		"dword dwCurrentState;dword dwControlsAccepted;dword dwWin32ExitCode;" & _
		"dword dwServiceSpecificExitCode;dword dwCheckPoint;dword dwWaitHint")
Dim $hService_Status_handle
;~ Dim Const $NTSL_LOOP_WAIT = -1
;~ Dim $service_type
;~ Dim $service_stop_event
;~ Dim $NTSL_ERROR_SERVICE_STATUS = 2
;~ Dim Const $WAIT_OBJECT_0 = 0x0

; #INDEX# ==========================================================================================================================================================
; Title .........: Services
; AutoIt Version : 3.2.10++
; Language ......: English
; Description ...: Windows service management for AutoIt, with AutoIt-as-service functionality.
; Authors .......: Engine, Arcker
; ...............: Shminkyboy, udgeen
; ==================================================================================================================================================================



; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Create
; Description ...: Creates a service.
; Syntax.........: _Service_Create($sServiceName, $sDisplayName, $iServiceType, $iStartType, $iErrorControl, $sBinaryPath _
;                  [, $sLoadOrderGroup, $fTagId, $vDependencies, $sServiceUser, $sPassword, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sDisplayName - The display name to be used by user interface programs to identify the service. The maximum string length is 256 characters.
;                                  The service control manager database preserves the case of the characters,
;                                  but service name comparisons are always case insensitive.
;                                  Forward-slash (/) and back-slash (\) are invalid service name characters.
;                  $iServiceType - The type of service. Specify one of the following service types:
;                                  $SERVICE_KERNEL_DRIVER - Driver service.
;                                  $SERVICE_FILE_SYSTEM_DRIVER - File system driver service.
;                                  $SERVICE_WIN32_OWN_PROCESS - Service that runs in its own process.
;                                  $SERVICE_WIN32_SHARE_PROCESS - Service that shares a process with other services.
;                                  If you specify either $SERVICE_WIN32_OWN_PROCESS or $SERVICE_WIN32_SHARE_PROCESS,
;                                  and the service is running in the context of the LocalSystem account, you can also specify the following type:
;                                  $SERVICE_INTERACTIVE_PROCESS - The service can interact with the desktop.
;                  $iStartType - The service start options. Specify one of the following start types:
;                                $SERVICE_BOOT_START - A device driver started by the system loader. This value is valid only for driver services.
;                                $SERVICE_SYSTEM_START - A device driver started by the IoInitSystem function. This value is valid only for driver services.
;                                $SERVICE_AUTO_START - A service started automatically by the service control manager during system startup.
;                                $SERVICE_DEMAND_START - A service started by the service control manager when a process calls the StartService function.
;                                $SERVICE_DISABLED - A service that cannot be started.
;                  $iErrorControl - The severity of the error, and action taken, if this service fails to start. Specify one of the following values:
;                                   $SERVICE_ERROR_IGNORE - The startup program ignores the error and continues the startup operation.
;                                   $SERVICE_ERROR_NORMAL - The startup program logs the error in the event log but continues the startup operation.
;                                   $SERVICE_ERROR_SEVERE - The startup program logs the error in the event log.
;                                                           If the last-known-good configuration is being started, the startup operation continues.
;                                                           Otherwise, the system is restarted with the last-known-good configuration.
;                                   $SERVICE_ERROR_CRITICAL - The startup program logs the error in the event log, if possible.
;                                                             If the last-known-good configuration is being started, the startup operation fails.
;                                                             Otherwise, the system is restarted with the last-known good configuration.
;                  $sBinaryPath - The fully-qualified path to the service binary file. If the path contains a space,
;                                 it must be quoted so that it is correctly interpreted.
;                                 For example, "d:\\my share\\myservice.exe" should be specified as "\"d:\\my share\\myservice.exe\"".
;                                 The path can also include arguments for an auto-start service. For example, "d:\\myshare\\myservice.exe arg1 arg2".
;                                 These arguments are passed to the service entry point (typically the main function).
;                  $sLoadOrderGroup - [Optional] The name of the load ordering group of which this service is a member.
;                                     Specify "Default" or an empty string if the service does not belong to a group.
;                  $fTagId - [Optional] Specify "True" if you desire a tag value that is unique in the group specified in the $sLoadOrderGroup parameter.
;                            Specify "False" or "Default" if you do not desire a tag value.
;                            The tag value is stored in @extended macro.
;                            You can use a tag for ordering service startup within a load ordering group by specifying a tag order vector in the
;                            GroupOrderList value of the following registry key:
;                            HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control
;                            Tags are only evaluated for driver services that have $SERVICE_BOOT_START or $SERVICE_SYSTEM_START start types.
;                  $vDependencies - [Optional] An array of services or load ordering groups that the system must start before this service can be started.
;                                   (Dependency on a group means that this service can run if at least one member of the group is running after an attempt to
;                                   start all members of the group.) Specify "Default" or an empty string if the service has no dependencies.
;                                   You must prefix group names with a plus sign ("+") so that they can be distinguished from a service name,
;                                   because services and service groups share the same name space.
;                  $sServiceUser - [Optional] The name of the account under which the service should run.
;                                  If the service type is $SERVICE_WIN32_OWN_PROCESS, use an account name in the form DomainName\UserName.
;                                  The service process will be logged on as this user. If the account belongs to the built-in domain,
;                                  you can specify .\UserName . A shared process can run as any user.
;                                  If the service type is $SERVICE_KERNEL_DRIVER or $SERVICE_FILE_SYSTEM_DRIVER,
;                                  the name is the driver object name that the system uses to load the device driver.
;                                  Specify "Default" if the driver is to use a default object name created by the I/O system.
;                  $sPassword - [Optional] The password to the account name specified by the $sServiceUser parameter.
;                               Specify "Default" or an empty string if the account has no password or if the service runs in the LocalService, NetworkService,
;                               or LocalSystem account. Passwords are ignored for driver services.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Create($sServiceName, _
		$sDisplayName, _
		$iServiceType, _
		$iStartType, _
		$iErrorControl, _
		$sBinaryPath, _
		$sLoadOrderGroup = Default, _
		$fTagId = Default, _
		$vDependencies = Default, _
		$sServiceUser = Default, _
		$sPassword = Default, _
		$sComputerName = "")
	Local $tLoadOrderGroup, $tTagId, $tDepend, $tServiceUser, $tPassword, $hSC, $avSC, $iSC
	$tLoadOrderGroup = DllStructCreate("wchar[" & Number($sLoadOrderGroup <> Default) * (StringLen($sLoadOrderGroup) + 1) & "]")
	DllStructSetData($tLoadOrderGroup, 1, $sLoadOrderGroup)
	$tTagId = DllStructCreate("dword[" & Number($fTagId) & "]")
	If IsArray($vDependencies) Then
		Local $iDepend, $tagDepend
		$iDepend = UBound($vDependencies) - 1
		For $i = 0 To $iDepend
			$tagDepend &= "wchar[" & StringLen($vDependencies[$i]) + 1 & "];"
		Next
		$tDepend = DllStructCreate(StringTrimRight($tagDepend, 1))
		For $i = 0 To $iDepend
			DllStructSetData($tDepend, $i + 1, $vDependencies[$i])
		Next
	Else
		$tDepend = DllStructCreate("wchar[" & Number($vDependencies <> Default) * (StringLen($vDependencies) + 1) & "]")
		DllStructSetData($tDepend, 1, $vDependencies)
	EndIf
	$tServiceUser = DllStructCreate("wchar[" & Number($sServiceUser <> Default) * (StringLen($sServiceUser) + 1) & "]")
	DllStructSetData($tServiceUser, 1, $sServiceUser)
	$tPassword = DllStructCreate("wchar[" & Number($sPassword <> Default) * (StringLen($sPassword) + 1) & "]")
	DllStructSetData($tPassword, 1, $sPassword)
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CREATE_SERVICE)
	$avSC = DllCall($hAdvapi32_DLL, "ptr", "CreateServiceW", _
			"ptr", $hSC, _
			"wstr", $sServiceName, _
			"wstr", $sDisplayName, _
			"dword", $SERVICE_ALL_ACCESS, _
			"dword", $iServiceType, _
			"dword", $iStartType, _
			"dword", $iErrorControl, _
			"wstr", $sBinaryPath, _
			"ptr", DllStructGetPtr($tLoadOrderGroup), _
			"ptr", DllStructGetPtr($tTagId), _
			"ptr", DllStructGetPtr($tDepend), _
			"ptr", DllStructGetPtr($tServiceUser), _
			"ptr", DllStructGetPtr($tPassword))
	If $avSC[0] = 0 Then
		$iSC = _WinAPI_GetLastError()
	Else
		CloseServiceHandle($avSC[0])
	EndIf
	CloseServiceHandle($hSC)
	Return SetError($iSC, DllStructGetData($tTagId, 1), Number($avSC[0] <> 0))
EndFunc   ;==>_Service_Create



; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Delete
; Description ...: Deletes a service.
; Syntax.........: _Service_Delete($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Delete($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avDS, $iDS
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $DELETE)
	$avDS = DllCall($hAdvapi32_DLL, "int", "DeleteService", _
			"ptr", $hService)
	If $avDS[0] = 0 Then $iDS = _WinAPI_GetLastError()
	CloseServiceHandle($hService)
	CloseServiceHandle($hSC)
	Return SetError($iDS, 0, $avDS[0])
EndFunc   ;==>_Service_Delete



; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Exists
; Description ...: Checks if a service exists.
; Syntax.........: _Service_Exists($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - 1
;                  Failure - 0
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Exists($sServiceName, $sComputerName = "")
	Local $hSC, $hService
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_INTERROGATE)
	CloseServiceHandle($hService)
	CloseServiceHandle($hSC)
	Return Number($hService <> 0)
EndFunc   ;==>_Service_Exists



; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_QueryType
; Description ...: Retrieves a service's type.
; Syntax.........: _Service_QueryType($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: None.
; Return values .: Success - Returns the type of service. Can be one of the following values:
;                            $SERVICE_KERNEL_DRIVER - The service is a device driver.
;                            $SERVICE_FILE_SYSTEM_DRIVER - The service is a file system driver.
;                            $SERVICE_WIN32_OWN_PROCESS - The service runs in its own process.
;                            $SERVICE_WIN32_SHARE_PROCESS - The service shares a process with other services.
;                            BitOR($SERVICE_WIN32_OWN_PROCESS, $SERVICE_INTERACTIVE_PROCESS) - The service runs in its own process
;                                                                                              and can interact with the desktop.
;                            BitOR($SERVICE_WIN32_SHARE_PROCESS, $SERVICE_INTERACTIVE_PROCESS) - The service shares a process with other services
;                                                                                                and can interact with the desktop.
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_QueryType($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avQA, $tQB, $avQB, $iQE, $tQC
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_QUERY_CONFIG)

	; Determine needed size of the struct in bytes
	$avQA = QueryServiceConfig($hService, 0, 0)

	; Get Service data
	$tQB = DllStructCreate("ubyte[" & $avQA[4] & "]")
	$avQB = QueryServiceConfig($hService, DllStructGetPtr($tQB), DllStructGetSize($tQB))

	; Get last error and close service handle
	If $avQB[0] = 0 Then $iQE = _WinAPI_GetLastError()
	CloseServiceHandle($hService)
	CloseServiceHandle($hSC)

	; Decode the ubyte structure
	$tQC = DllStructCreate("dword[3];uint_ptr[2];dword;uint_ptr[3]", $avQB[2])

	Return SetError($iQE, 0, DllStructGetData($tQC, 1, 1))
EndFunc   ;==>_Service_QueryType



; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Start
; Description ...: Starts a service.
; Syntax.........: _Service_Start($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Start($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $avSS, $iSS
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_START)
	$avSS = DllCall($hAdvapi32_DLL, "int", "StartServiceW", _
			"ptr", $hService, _
			"dword", 0, _
			"ptr", 0)
	If $avSS[0] = 0 Then $iSS = _WinAPI_GetLastError()
	CloseServiceHandle($hService)
	CloseServiceHandle($hSC)
	Return SetError($iSS, 0, $avSS[0])
EndFunc   ;==>_Service_Start



; #FUNCTION# =======================================================================================================================================================
; Name...........: _Service_Stop
; Description ...: Stops a service.
; Syntax.........: _Service_Stop($sServiceName [, $sComputerName])
; Parameters ....: $sServiceName - Name of the service.
;                  $sComputerName - [Optional] The name of the target computer. The local computer is default.
; Requirement(s).: Administrative rights on the target computer.
; Return values .: Success - 1
;                  Failure - 0
;                            Sets @error
; Author ........: engine
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ==================================================================================================================================================================

Func _Service_Stop($sServiceName, $sComputerName = "")
	Local $hSC, $hService, $iCSS, $iCSSE
	$hSC = OpenSCManager($sComputerName, $SC_MANAGER_CONNECT)
	$hService = OpenService($hSC, $sServiceName, $SERVICE_STOP)
	$iCSS = ControlService($hService, $SERVICE_CONTROL_STOP)
	If $iCSS = 0 Then $iCSSE = _WinAPI_GetLastError()
	CloseServiceHandle($hService)
	CloseServiceHandle($hSC)
	Return SetError($iCSSE, 0, $iCSS)
EndFunc   ;==>_Service_Stop



Func CloseServiceHandle($hSCObject)
	Local $avCSH = DllCall($hAdvapi32_DLL, "int", "CloseServiceHandle", _
			"ptr", $hSCObject)
	If @error Then Return SetError(@error, 0, 0)
	Return $avCSH[0]
EndFunc   ;==>CloseServiceHandle



Func ControlService($hService, $iControl)
	Local $avCS = DllCall($hAdvapi32_DLL, "int", "ControlService", _
			"ptr", $hService, _
			"dword", $iControl, _
			"ptr*", 0)
	If @error Then Return SetError(@error, 0, 0)
	Return $avCS[0]
EndFunc   ;==>ControlService



Func OpenSCManager($sComputerName, $iAccess)
	Local $avOSCM = DllCall($hAdvapi32_DLL, "ptr", "OpenSCManagerW", _
			"wstr", $sComputerName, _
			"wstr", $SERVICES_ACTIVE_DATABASE, _
			"dword", $iAccess)
	If @error Then Return SetError(@error, 0, 0)
	Return $avOSCM[0]
EndFunc   ;==>OpenSCManager



Func OpenService($hSC, $sServiceName, $iAccess)
	Local $avOS = DllCall($hAdvapi32_DLL, "ptr", "OpenServiceW", _
			"ptr", $hSC, _
			"wstr", $sServiceName, _
			"dword", $iAccess)
	If @error Then Return SetError(@error, 0, 0)
	Return $avOS[0]
EndFunc   ;==>OpenService



Func QueryServiceConfig($hService, $pServiceConfig, $iBufSize)
	Local $avQSC = DllCall($hAdvapi32_DLL, "int", "QueryServiceConfigW", _
			"ptr", $hService, _
			"ptr", $pServiceConfig, _
			"dword", $iBufSize, _
			"dword*", 0)
	Return $avQSC
EndFunc   ;==>QueryServiceConfig



;~ Au3@Service routines by 'Arcker'. Modified by ShminkyBoy to include support for interactive services

Func _Service_Init($sServiceName)
	If $bAU3ServiceDebug Then logprint("_Service_Init(" & $sServiceName & ")")
;~ 	$service_type = _Service_QueryType($sServiceName)
	$tServiceCtrl = DllCallbackRegister("_Service_Ctrl", "dword", "dword;dword;ptr;ptr") ; handlerex function
;~ 	$tServiceCtrl = DllCallbackRegister("_Service_Ctrl", "none", "dword") ; handler ( simple )
	$tServiceMain = DllCallbackRegister("_Service_ServiceMain", "none", "dword;ptr")
;~ 	$tServiceMain = DllCallbackRegister("_Main", "none", "dword;ptr")
;~ 	Local $tdispatchTable = DllStructCreate("ptr[2];ptr[2]")
;~ 	$tServiceName = DllStructCreate("char["&StringLen($sServiceName)&"]")
;~ 	DllStructSetData($tServiceName, 1, $sServiceName)
;~ 	DllStructSetData($tdispatchTable, 1, DllStructGetPtr($tServiceName), 1)
;~ 	DllStructSetData($tdispatchTable, 1, DllCallbackGetPtr($tServiceMain), 2)



	;v4 :
	Local $tagSERVICE_TABLE_ENTRY = "STRUCT;ptr lpServiceName;ptr lpServiceProc;ENDSTRUCT"
;~ 	logprint($tSERVICE_TABLE_ENTRY & ";" & $tSERVICE_TABLE_ENTRY)
	Local $tdispatchTable = DllStructCreate($tagSERVICE_TABLE_ENTRY & ";" & $tagSERVICE_TABLE_ENTRY)
;~ 	If @error Then
;~ 	logprint("erreur de structure " & @error & @crlf)
;~ 	Exit
;~ 	EndIf
	$tServiceName = DllStructCreate("char["&StringLen($sServiceName)&"]")
;~ 	DllStructSetData($tServiceName, 1, $sServiceName)
	DllStructSetData($tdispatchTable, 1, DllStructGetPtr($tServiceName))
	DllStructSetData($tdispatchTable, 2, DllCallbackGetPtr($tServiceMain))

	;**********
;~ 	DllStructSetData($tdispatchTable, 2, 0, 1) ; v4 not needed since NULL
;~ 	DllStructSetData($tdispatchTable, 2, 0, 2) ; v4 not needed since NULL
	; here when we call this, the _service_ctrl callback is reported to the SCM
	DllCall($hAdvapi32_DLL, "int", "StartServiceCtrlDispatcher", "ptr", DllStructGetPtr($tdispatchTable))
	;cleanup a little
	$tServiceName =0
	$tdispatchTable = 0
	; cleanup callback resources
;~ 	DllCallbackFree($tServiceMain)
;~ 	DllCallbackFree($tServiceCtrl)
EndFunc   ;==>_Service_init



Func _Service_ServiceMain($iArg, $pArgs)
;~ 	Local $ret = DllCall($hAdvapi32_DLL, "ptr", "RegisterServiceCtrlHandlerExW", "ptr", DllStructGetPtr($tServiceName), "ptr", DllCallbackGetPtr($tServiceCtrl), "ptr", 0) ;register service
;~ 	If @error Or ($ret[0] = 0) Then Exit
;~ 	$hService_Status_handle = $ret[0]
;~ 	If Not $hService_Status_handle Then
;~ 		_Service_Cleanup()
;~ 		Return
;~ 	EndIf

;~ 	DllStructSetData($tService_Status, "dwServiceType", $service_type)
;~ 	DllStructSetData($tService_Status, "dwServiceSpecificExitCode", 0)

	; report the status to the service control manager.
;~ 	If Not (_Service_ReportStatus($SERVICE_START_PENDING, $NO_ERROR, 3000)) Then
;~ 		_Service_Cleanup()
;~ 		Return
;~ 	EndIf
;~ 	_Service_Startup($iArg, $pArgs)
;~ 	_Main()
	if $bAU3ServiceDebug then logprint("RegisterServiceCtrlHandlerEx")

	Local $ret = DllCall($hAdvapi32_DLL, "ptr", "RegisterServiceCtrlHandlerEx", "ptr", DllStructGetPtr($tServiceName), "ptr", DllCallbackGetPtr($tServiceCtrl),"ptr",0) ;register service
;~ 	Local $ret = DllCall($hAdvapi32_DLL, "handle", "RegisterServiceCtrlHandler", "ptr", DllStructGetPtr($tServiceName), "ptr", DllCallbackGetPtr($tServiceCtrl)) ;register service
	If $ret[0] = 0 Then
		if $bAU3ServiceDebug then logprint("Error in registering service" & _WinAPI_GetLastError())
		_Service_ReportStatus($SERVICE_STOPPED, _WinAPI_GetLastError(), 0)
;~ 		Return
		Exit
	EndIf
	$hService_Status_handle = $ret[0]
	If Not $hService_Status_handle Then
		_Service_Cleanup()
		Return
	EndIf

	;goto cleanup;
	DllStructSetData($tService_Status, "dwServiceType", _Service_QueryType($sServiceName))
	DllStructSetData($tService_Status, "dwServiceSpecificExitCode", 0);

	; report the status to the service control manager.
	If Not _Service_ReportStatus($SERVICE_START_PENDING, $NO_ERROR, 0) Then
		;goto cleanup;
		_Service_ReportStatus($SERVICE_STOPPED, _WinAPI_GetLastError(), 0)
		if $bAU3ServiceDebug then logprint("***** & error reporting Service_ReportStatus *******" & @CRLF)
		_Service_Cleanup()
		Return
	EndIf
;~ 	$service_stop_event = _WinAPI_CreateEvent(0, True, False, "") <= wonder if necessary, disabled in V3
#cs
	If Not _Service_ReportStatus($SERVICE_RUNNING, $NO_ERROR, 0) Then
		if $bAU3ServiceDebug then logprint("Erreur sending running status, exiting")
		_Service_ReportStatus($SERVICE_STOPPED, _WinAPI_GetLastError(), 0)
		Return
	EndIf


#ce	$bServiceRunning = True ; REQUIRED
	If $bAU3ServiceDebug Then logprint("main start")
	_Main($iArg, $pArgs)
	#region -- service stopping
	;~ 	_service_cleanup()
;~ 	_Service_ReportStatus($SERVICE_STOP_PENDING, $NO_ERROR, 1000);

	If $bAU3ServiceDebug Then logprint("main stopped. Cleanup.")
	#endregion -- service stopping
	#region - STOP STOP STOP Service Stopped, don't change it or you will have stoping status
;~ 	_Service_ReportStatus($SERVICE_STOPPED, $NO_ERROR, 0) ; That all! Our AutoIt Service stops just there! 0 timeout meens "Now"
;~ Exit ;Bug here. In race conditions it's not executed.
;~ 	ProcessClose(@AutoItPID) <= disabled in V3, seems to works well.
;~ 	sleep(1000)
;~ 	Return
	#endregion - Service Stopped, don't change it or you will have stoping status
EndFunc   ;==>_Service_ServiceMain



Func _Service_Cleanup()
	If $hService_Status_handle Then _Service_ReportStatus($SERVICE_STOPPED, $NO_ERROR, 0)
EndFunc   ;==>_Service_Cleanup



;/*------------------------------[ service_ctrl ]------------------------------
; *  Called by the SCM whenever ControlService() is called for this service
; *
; *  Parameters:
; *		ctrlCode - type of control requested
; *
; *  Return value:
; *		none
; *----------------------------------------------------------------------------*/
Func _Service_Ctrl($dwControl, $dwEventType, $lpEventData, $lpContext) ;handler ex
;~ Func _Service_Ctrl($dwControl)
	;#forceref $dwEventType, $lpEventData, $lpContext
;~ 	Sleep(1000)
;~ 	Local $return = $NO_ERROR
;~ 	WriteLog("_Service_Ctrl entered")
;~ 	If $bAU3ServiceDebug Then logprint("** SCM command received => " & $dwControl)
	Switch $dwControl
		Case $SERVICE_CONTROL_STOP,$SERVICE_ACCEPT_SHUTDOWN ; new in v4, stop when system shutdown ( better mmm ? )
;~ 			If $bAU3ServiceDebug Then logprint("Received stop command for service")
			;stop the service.
			;
			;SERVICE_STOP_PENDING should be reported before
			;setting the Stop Event - hServerStopEvent - in
			;service_stop().  This avoids a race condition
			;which may result in a 1053 - The Service did not respond...
			;error.
;~ 			DllStructSetData($tService_Status, "dwCurrentState", $SERVICE_STOP_PENDING)
;~ 			_Service_ReportStatus($SERVICE_STOP_PENDING, $NO_ERROR, 0)
			$bServiceRunning = False
;~ 			_Service_SetStopEvent()
;~ 			While $bMainStopped = False
;~ 				If $bAU3ServiceDebug Then logprint("Main is still active")
;~ 				Sleep(1000)
;~ 			WEnd
;~ 			If $bAU3ServiceDebug Then logprint("Main is still active")
;~ 			_Service_ReportStatus($SERVICE_STOPPED, $NO_ERROR, 0)
;~ 			Exit
;~ 			_Service_ReportStatus(DllStructGetData($tService_Status,"dwCurrentState"), _WinAPI_GetLastError(), 0)
;~ 			_Service_SetStopEvent()
			; call _Service_Cleanup() from _Svc_Main() immediately before exiting
			Return $NO_ERROR
		Case $SERVICE_CONTROL_PAUSE
			DllStructSetData($tService_Status, "dwCurrentState", $SERVICE_PAUSED)
		Case $SERVICE_CONTROL_CONTINUE
			DllStructSetData($tService_Status, "dwCurrentState", $SERVICE_RUNNING)
		Case $SERVICE_CONTROL_INTERROGATE
			Return $NO_ERROR
;~ 			_Service_ReportStatus(DllStructGetData($tService_Status, "dwCurrentState"), $NO_ERROR, 0)
			; report the service status
		Case $SERVICE_CONTROL_SESSIONCHANGE
			; Extracting SessionID & cbSize
;~ 			Local $WTSSESSION_NOTIFICATION  = DllStructCreate("dword cbsize; dword dwSessionId", $lpEventData)
;~ 			Local $cbSize = DllStructGetData($WTSSESSION_NOTIFICATION, "cbSize")
;~ 			Local $dwSessionId = DllStructGetData($WTSSESSION_NOTIFICATION, "dwSessionId")
;~ 			WriteLog("cbSize = " & $cbSize & " ,dwSessionId = " & $dwSessionId)

			;Trapping events
;~ 			Switch $dwEventType
;~ 				Case $WTS_CONSOLE_CONNECT
;~ 					WriteLog("Console session connected", 0, 2)
;~ 				Case $WTS_CONSOLE_DISCONNECT
;~ 					WriteLog("Console session disconnected", 0, 2)
;~ 				Case $WTS_REMOTE_CONNECT
;~ 					WriteLog("Remote session connected", 0, 2)
;~ 				Case $WTS_REMOTE_DISCONNECT
;~ 					WriteLog("Remote session disconnected", 0, 2)
;~ 				Case $WTS_SESSION_LOGON
;~ 					WriteLog("Session logged on", 0, 2)
;~ 				Case $WTS_SESSION_LOGOFF
;~ 					WriteLog("Session logged off", 0, 2)
;~ 				Case $WTS_SESSION_LOCK
;~ 					WriteLog("Session locked", 0, 2)
;~ 				Case $WTS_SESSION_UNLOCK
;~ 					WriteLog("Session unlocked", 0, 2)
;~ 				Case $WTS_SESSION_REMOTE_CONTROL
;~ 					WriteLog("Session remote control", 0, 2)
;~ 			EndSwitch
		Case 128 To 255 ; custom messages
			; handle custom messages
		Case Else
			; invalid or unhandled control code
;~ 			$return = $ERROR_CALL_NOT_IMPLEMENTED
	EndSwitch
;~ 	_Service_ReportStatus(DllStructGetData($tService_Status, "dwCurrentState"), $NO_ERROR, 0)
	Return $NO_ERROR
EndFunc   ;==>_Service_Ctrl



;/*--------------------------[ _Service_ReportStatus ]--------------------------
; *  Sets the current status and reports it to the Service Control Manager
; *
; *  Parameters:
; *		currentState	-  the state of the service
; *		exitCode		-  error code to report
; *		waitHint		-  worst case estimate to next checkpoint
; *
; *  Return value:
; *		true			-  success
; *		false			-  failure
; *----------------------------------------------------------------------------*/
Func _Service_ReportStatus($currentState, $exitCode, $waitHint)
	Static $gdwCheckPoint = 1
	If $bAU3ServiceDebug Then logprint("Report Status received with = " & $currentState )
;~ 	Local $rc = True
;~ 	If Not $service_debug_mode Then ;when debugging we don't report to the SCM
		If ($currentState = $SERVICE_START_PENDING) Then
			DllStructSetData($tService_Status, "dwControlsAccepted", 0)
		Else
;~ 			WriteLog("_Service_ReportStatus entered")
;~ 			DllStructSetData($tService_Status, "dwControlsAccepted", BitOR($SERVICE_ACCEPT_STOP, $SERVICE_ACCEPT_SESSIONCHANGE))
			DllStructSetData($tService_Status, "dwControlsAccepted", BitOR($SERVICE_ACCEPT_STOP, $SERVICE_ACCEPT_SHUTDOWN))
		EndIf

		DllStructSetData($tService_Status, "dwCurrentState", $currentState)
		DllStructSetData($tService_Status, "dwWin32ExitCode", $exitCode)
		DllStructSetData($tService_Status, "dwWaitHint", $waitHint)
		If ($currentState = $SERVICE_RUNNING) Or ($currentState = $SERVICE_STOPPED) Then
			DllStructSetData($tService_Status, "dwCheckPoint", 0)
		Else
			$gdwCheckPoint += 1
			If $bAU3ServiceDebug Then logprint("dwCheckPoint => " & $gdwCheckPoint & @crlf)
			DllStructSetData($tService_Status, "dwCheckPoint", $gdwCheckPoint)
		EndIf
		; report the status of the service to the service control manager.
;~ 		$rc =
;~ 	EndIf
	Return _Service_SetServiceStatus($hService_Status_handle, DllStructGetPtr($tService_Status))
EndFunc   ;==>_Service_ReportStatus



Func _Service_SetServiceStatus($hServiceStatus, $lpServiceStatus)
	Local $ret = DllCall($hAdvapi32_DLL, "int", "SetServiceStatus", "handle", $hServiceStatus, "ptr", $lpServiceStatus)
	If $ret[0] = 0 Then
		If $bAU3ServiceDebug Then
			logprint("SetServiceStatus Error" & _WinAPI_GetLastError())
		EndIf
	EndIf

	If @error Or Not $ret[0] Then Return 0
	Return $ret[0]
EndFunc   ;==>_Service_SetServiceStatus



;/*------------------------------[ service_start ]------------------------------
; * Starts and runs the service
; *----------------------------------------------------------------------------*/

Func _Service_Startup($argc, $argv)
	; report the status to the service control manager.
	If Not _Service_ReportStatus($SERVICE_START_PENDING, $NO_ERROR, 3000) Then Return
	; create the event object. The control handler function signals
	; this event when it receives the "stop" control code.
;~ 	$gServiceStateRunning = True
;~ 	$service_stop_event = _WinAPI_CreateEvent(0, True, False, "")
	; report the status to the service control manager.
	Return _Service_ReportStatus($SERVICE_RUNNING, $NO_ERROR, 0)
EndFunc   ;==>_Service_Startup



;/*------------------------------[ service_stop ]------------------------------
; * Stops the service.
; *
; * NOTE: If this service will take longer than 3 seconds,
; * spawn a thread to execute the stop code and return.
; * Otherwise the SCM will think the service has stopped responding.
; *----------------------------------------------------------------------------*/

Func _Service_SetStopEvent()
;~ 	$gServiceStateRunning = 0
	$bServiceRunning = 0
;~ 	If $service_stop_event Then _WinAPI_SetEvent($service_stop_event)
EndFunc   ;==>_Service_SetStopEvent