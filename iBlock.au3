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
#pragma compile(LegalCopyright, Written by TheWalkingGeek)
#pragma compile(Comments, http://www.thewalkingeek.com)

If _Singleton("iBlock", 1) = 0 Then
	MsgBox($MB_APPLMODAL, "Whoops!", "iBlock is already running.")
	Exit
EndIf

;Opt("GUIOnEventMode", 1)
;Opt("GUIEventOptions", 0)
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)


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

Func Startup()
		If _StartupFolder_Exists() = 1 Then
			_StartupFolder_Uninstall()
			TrayItemSetState($idStart, $TRAY_UNCHECKED)

		Else
			_StartupFolder_Install()
			TrayItemSetState($idStart, $TRAY_CHECKED)
		EndIf
EndFunc

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

Func About()

Local $hHBITMAP = _Resource_GetAsBitmap('PIC1', $RT_BITMAP)

#Region ### START Koda GUI section ### Form=C:\Users\Jon\Desktop\Form1.kxf
$Form1 = GUICreate("About", 606, 500, -1, -1)
GUISetBkColor(0xB9D1EA)
$Label1 = GUICtrlCreateLabel("iBlock is freeware designed to prevent accidental input from unwanted hands (or paws).", 8, 8, 570, 21)
GUICtrlSetFont(-1, 11, 400, 0, "Arial")
$Label2 = GUICtrlCreateLabel("To lock the PC: Right click on the system tray icon and click Lock Input.", 8, 48, 465, 21)
GUICtrlSetFont(-1, 11, 400, 0, "Arial")
$Label3 = GUICtrlCreateLabel("To unlock the PC: Enter the random 4 digit password displayed on screen. ", 8, 72, 489, 21)
GUICtrlSetFont(-1, 11, 400, 0, "Arial")
$Pic1 = GUICtrlCreatePic("", 177, 176, 250, 269)
_Resource_SetBitmapToCtrlID($Pic1, $hHBITMAP)
$Label4 = GUICtrlCreateLabel("For: My Son ... ( literally )", 216, 464, 164, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
$Label5 = GUICtrlCreateLabel("Written By: TheWalkingGeek", 8, 112, 191, 21)
GUICtrlSetFont(-1, 11, 400, 0, "Arial")
$Label6 = GUICtrlCreateLabel("http://www.thewalkingeek.com", 192, 144, 211, 22)
GUICtrlSetFont(-1, 12, 400, 4, "Arial")
GUICtrlSetColor(-1, 0x0000FF)
GUISetState(@SW_SHOW, $Form1)
#EndRegion ### END Koda GUI section ###

While 1
GUICtrlSetCursor($Label6, 0)
$nMsg = GUIGetMsg()
Switch $nMsg
    Case $GUI_EVENT_CLOSE
        GUIDelete()
	ExitLoop

    Case $GUI_EVENT_MINIMIZE
        GUIDelete()
	ExitLoop

    Case $Label6
	ShellExecute ("http://www.thewalkingeek.com",1)
EndSwitch
WEnd


;	While 1
;		GUISetOnEvent($GUI_EVENT_CLOSE, CloseWin)
;		GUISetOnEvent($GUI_EVENT_MINIMIZE, CloseWin)
;		GUISetOnEvent($Label6, ShellExecute("http://www.funk.eu"))
;		ExitLoop
;		sleep(100)
;	WEnd

EndFunc

Func CloseWin()
	GUIDelete()
EndFunc

