#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
#include <AD.au3>

; Open Connection to the Active Directory
_AD_Open()
If @error Then Exit MsgBox(16, "Active Directory Example Skript", "Function _AD_Open encountered a problem. @error = " & @error & ", @extended = " & @extended)

; *****************************************************************************
; Example 1
; Set the debugging options to MsgBox.
; *****************************************************************************
_AD_ErrorNotify(2)
If @error Then MsgBox(16, "Active Directory Example Skript", "Function _AD_ErrorNotify encountered a problem. @error = " & @error & ", @extended = " & @extended)
; Provoke a COM error
_AD_GetObjectAttribute(@UserName, "xyz")

; *****************************************************************************
; Example 2
; Set the debugging option to file and set the filename.
; Query the debugging options and display the resulting array.
; *****************************************************************************
; Set the debugging options
_AD_ErrorNotify(3, "C:\temp\AD_Loggin.txt")
If @error Then MsgBox(16, "Active Directory Example Skript", "Function _AD_ErrorNotify encountered a problem. @error = " & @error & ", @extended = " & @extended)
; Query the debugging options
Global $aResult = _AD_ErrorNotify(-1)
If @error Then MsgBox(16, "Active Directory Example Skript", "Function _AD_ErrorNotify encountered a problem. @error = " & @error & ", @extended = " & @extended)
_ArrayDisplay($aResult)

; Close Connection to the Active Directory
_AD_Close()