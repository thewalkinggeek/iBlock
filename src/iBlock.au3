#AutoIt3Wrapper_Res_File_Add=pic.bmp, RT_BITMAP, PIC1, 0

#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>
#include <Misc.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <BlockInputEx.au3>
#include '_Startup.au3'
#include 'ResourcesEx.au3'

#pragma compile(FileDescription, iBlock - Keyboard and Mouse locking utility)
#pragma compile(ProductName, iBlock)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.0)
#pragma compile(LegalCopyright, Written by Jon Schoenberger)
#pragma compile(Comments, https://github.com/thewalkinggeek/iBlock)

Global $hGUI
Global $Pic_1, $Dedicate, $Description, $Instructions, $Instructions2, $Author

; Check If program is already running
If _Singleton("iBlock", 1) = 0 Then
	MsgBox($MB_APPLMODAL, "Whoops!", "iBlock is already running.")
	Exit
EndIf

;Opt("GUIOnEventMode", 1)
;Opt("GUIEventOptions", 0)
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)


; Create Tray
$idStart = TrayCreateItem("Lock Input")
TrayItemSetOnEvent(-1, "Lock")


TrayCreateItem("")
$idStart = TrayCreateItem("Start on Boot")
	If _StartupFolder_Exists() = 1 Then
		TrayItemSetState(-1, $TRAY_CHECKED)
	Else
		TrayItemSetState(-1, $TRAY_UNCHECKED)
	EndIf
TrayItemSetOnEvent(-1, "Startup")

TrayCreateItem("")

TrayCreateItem("About")
TrayItemSetOnEvent(-1, "About")

TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "Terminate")

TraySetState($TRAY_ICONSTATE_SHOW)
TraySetToolTip("iBlock - Keyboard and Mouse locking utility")

TraySetState($TRAY_ICONSTATE_SHOW)
TraySetIcon("shell32.dll", 48)

While 1
		Sleep(100)
WEnd

; Create Startup Function
Func Startup()
		If _StartupFolder_Exists() = 1 Then
			_StartupFolder_Uninstall()
			TrayItemSetState($idStart, $TRAY_UNCHECKED)

		Else
			_StartupFolder_Install()
			TrayItemSetState($idStart, $TRAY_CHECKED)
		EndIf
EndFunc

; Create Lock Function
Func Lock()

$pwd = ""
Dim $aSpace[2]
$digits = 4
For $i = 1 To $digits
    $aSpace[0] = Chr(Random(65, 90, 1)) ;A-Z
;    $aSpace[1] = Chr(Random(97, 122, 1)) ;a-z
    $aSpace[1] = Chr(Random(48, 57, 1)) ;0-9
    $pwd &= $aSpace[Random(0, 2)]
Next

_BlockInputEx(1, "[:ALPHA:]|[:NUMBER:]|{ENTER}|{ALT}|{TAB}|{BACKSPACE}")

; Locked Code
While 1
	TraySetIcon("shell32.dll", 45)
	$sPasss = InputBox("Computer is locked", "Please type " & $pwd &  " to unlock this computer:", "", "*")

	If $sPasss = $pwd Then ;we exit also on Cancel, to prevent complete block for this specific example
		_BlockInputEx(0)
		TraySetIcon("shell32.dll", 48)
		ExitLoop
	Else
		MsgBox(48, "Error", "Wrong password.")
	EndIf
WEnd
EndFunc

Func Terminate()
    Exit 0
EndFunc

; Create About Window
Func About()
	$hGUI = GUICreate("About", 600, 500, 210, 0)
	
	$Pic_1 = GUICtrlCreatePic("", 175, 160, 250, 269)
	GUICtrlSetImage(-1, "pic.bmp")
	$Dedicate = GUICtrlCreateLabel("For: My Son ... ( literally )", 210, 465, 176, 21)
	GUICtrlSetFont(-1, 12)
	$Description = GUICtrlCreateLabel("iBlock is freeware designed to prevent accidental input from unwanted hands (or paws).", 10, 10, 576, 16)
	GUICtrlSetFont(-1, 11)
	$Instructions = GUICtrlCreateLabel("To lock the PC: Right click on the system tray icon and click Lock Input.", 10, 50, 576, 21)
	GUICtrlSetFont(-1, 11)
	$Instructions2 = GUICtrlCreateLabel("To unlock the PC: Enter the random 4 digit password displayed on screen.", 10, 75, 576, 21)
	GUICtrlSetFont(-1, 11)
	$Author = GUICtrlCreateLabel("Written By: Jon Schoenberger", 205, 435, 181, 16)
	GUICtrlSetFont(-1, 10)
	GUISetState(@SW_SHOWNORMAL)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
			    CloseWin()
				ExitLoop
			Case Else
				;
		EndSwitch
	WEnd
EndFunc

; Delete GUI Function
Func CloseWin()
	GUIDelete()
EndFunc

