#Requires Autohotkey v2.0 ; Display an error and quit if this version requirement is not met.
#SingleInstance force     ; Allow only a single instance of the script to run.
#Warn                     ; Enable warnings to assist with detecting common errors.

; Whether unzoom is currently toggled on or off
g_bUnzoomToggle := false

Init()

; Produce a system beep to help knowing whether unzoom was toggled on or off and whether soft or fast unzoom mode was switched to
Beep(p_iFrequency, p_bDoubleBeep)
{
	if (g_bSoundBeep)
	{
		; Single beep when toggled on
		SoundBeep(p_iFrequency, 100)
		if (p_bDoubleBeep)
			; Double beep when toggled off
			SoundBeep(p_iFrequency, 100)
	}
}

; Disable unzoom when manually zooming in/out
CancelUnzoom(*)
{
	if (g_bDisableUnzoomOnManualZoom && g_bUnzoomToggle)
	{
		ShowTooltip("Manually zooming, disabling automatic unzoom")
		DisableToggle()
	}
}

DisableToggle()
{
	global g_bUnzoomToggle := false

	if (g_bUseSoftUnzoom)
		Send("{Blind}{" g_sUnzoomKey " up}")
	else
		SetTimer(Unzoom, 0)
}

Init()
{
	; Window group for Dungeon Siege
	GroupAdd("DungeonSiege", "ahk_exe DSLOA.exe")
	GroupAdd("DungeonSiege", "ahk_exe DSLOAMod.exe")
	GroupAdd("DungeonSiege", "ahk_exe DSMod.exe")
	GroupAdd("DungeonSiege", "ahk_exe DungeonSiege.exe")

	ReadConfigFile()
	RegisterHotkeys()

	; Set an event hook to detect when the game window loses focus
	DllCall("user32\SetWinEventHook",
			"Int", 0x0003, ; EVENT_SYSTEM_FOREGROUND
			"Int", 0x0003,
			"Ptr", 0,
			"Ptr", CallbackCreate(OnFocusChanged, "F"),
			"Int", 0,
			"Int", 0,
			"Int", 0)
}

; Check if the active window is in fullscreen mode (only works on the primary monitor for now)
IsFullscreen()
{
	/*
		l_sWinExStyle := WinGetExStyle("A")
		l_sWinStyle := WinGetStyle("A")
	*/

	WinGetPos(&l_iWinX, &l_iWinY, &l_iWinW, &l_iWinH, "A")
	return (l_iWinX = 0 && l_iWinY = 0 && l_iWinW = A_ScreenWidth && l_iWinH = A_ScreenHeight)
}

; Disable unzoom when the game window loses focus
OnFocusChanged(hWinEventHook, vEvent, hWnd)
{
	if !WinActive("ahk_group DungeonSiege")
		DisableToggle()
}

IniReadInt(p_sFile, p_sSection, p_sKey, p_sDefault)
{
	l_sValue := IniRead(p_sFile, p_sSection, p_sKey, p_sDefault)

	try
	{
		l_nValue := l_sValue + 0
		return l_nValue
	}
	catch TypeError ; not an integer
	{
		return p_sDefault
	}
}

ReadConfigFile()
{
	global

	local l_sConfigFile := "DungeonSiegeUnzoom.ini"

	; General
	g_bDisableUnzoomOnManualZoom := IniRead(l_sConfigFile, "General", "bDisableUnzoomOnManualZoom", true) == true
	g_bShowTooltip := IniRead(l_sConfigFile, "General", "bShowTooltip", true) == true
	g_bSoundBeep := IniRead(l_sConfigFile, "General", "bSoundBeep", true) == true
	g_bUseSoftUnzoom := IniRead(l_sConfigFile, "General", "bUseSoftUnzoom", false) == true
	g_iSpamCount := IniReadInt(l_sConfigFile, "General", "iSpamCount", 10)
	g_iTimerInterval := IniReadInt(l_sConfigFile, "General", "iTimerInterval", 100)
	g_iTooltipDuration := IniReadInt(l_sConfigFile, "General", "iTooltipDuration", 1500)

	; Keys
	g_sUnzoomButton := IniRead(l_sConfigFile, "Keys", "sUnzoomButton", "WheelDown")
	g_sUnzoomKey := IniRead(l_sConfigFile, "Keys", "sUnzoomKey", "-")
	g_sUnzoomSwitchKey := IniRead(l_sConfigFile, "Keys", "sUnzoomSwitchKey", "XButton2")
	g_sUnzoomToggleKey := IniRead(l_sConfigFile, "Keys", "sUnzoomToggleKey", "XButton1")
	g_sZoomButton := IniRead(l_sConfigFile, "Keys", "sZoomButton", "WheelUp")
	g_sZoomKey := IniRead(l_sConfigFile, "Keys", "sZoomKey", "=")

	; Prevent some variables from being negative or set to 0, otherwise loops/timers won't work
	g_iSpamCount := Max(g_iSpamCount, 1)
	g_iTimerInterval := Max(g_iTimerInterval, 1)
	g_iTooltipDuration := Max(g_iTooltipDuration, 1)
}

RegisterHotkeys()
{
	; Hotkeys are fired only when Dungeon Siege is the active window
	HotIfWinActive("ahk_group DungeonSiege")
	Hotkey("*$" g_sUnzoomSwitchKey, SwitchUnzoomMode, "On")
	Hotkey("*$" g_sUnzoomToggleKey, UnzoomToggle, "On")
	Hotkey("~*$" g_sUnzoomButton, CancelUnzoom, "On")
	Hotkey("~*$" g_sUnzoomKey, CancelUnzoom, "On")
	Hotkey("~*$" g_sZoomButton, CancelUnzoom, "On")
	Hotkey("~*$" g_sZoomKey, CancelUnzoom, "On")
	HotIfWinActive()
}

ShowTooltip(p_sText)
{
	; Showing tooltips causes issues in fullscreen mode since they're designed to be always on top
	if (g_bShowTooltip && !IsFullscreen())
	{
		ToolTip(p_sText)
		SetTimer(() => ToolTip(), -g_iTooltipDuration)
	}
}

; Toggle between soft and fast unzoom
SwitchUnzoomMode(*)
{
	DisableToggle()
	global g_bUseSoftUnzoom := !g_bUseSoftUnzoom
	ShowTooltip("Switched to " (g_bUseSoftUnzoom ? "soft" : "fast") " unzoom mode")
	Beep(500, !g_bUseSoftUnzoom)
	KeyWait(g_sUnzoomSwitchKey)
}

; Spam a mouse button to unzoom quickly
Unzoom()
{
	if WinActive("ahk_group DungeonSiege")
	{
		loop g_iSpamCount
		{
			; Avoid sending mouse input to other windows if the cursor is not over the game window
			MouseGetPos(,, &l_iWinID)
			if InStr(WinGetClass("ahk_id " l_iWinID), "gpgwndclass_")
			{
				; Stop the loop if the toggle has been turned off
				if (!g_bUnzoomToggle)
					break

				Send("{Blind}{" g_sUnzoomButton "}")
				Sleep(10)
			}
		}
	}
}

; Toggle unzoom on and off
UnzoomToggle(*)
{
	global g_bUnzoomToggle := !g_bUnzoomToggle

	ShowTooltip((g_bUseSoftUnzoom ? "Soft" : "Fast") " unzoom toggled " (g_bUnzoomToggle ? "ON" : "OFF"))

	if (g_bUseSoftUnzoom)
		Send("{Blind}{" g_sUnzoomKey " " (g_bUnzoomToggle ? "down" : "up") "}")
	else
		SetTimer(Unzoom, g_bUnzoomToggle * g_iTimerInterval)

	Beep(1000, !g_bUnzoomToggle)
	KeyWait(g_sUnzoomToggleKey)
}

#SuspendExempt
; Exit script
*^!F10::ExitApp() ; CTRL+ALT+F10

; Reload script
*^!F11::Reload() ; CTRL+ALT+F11

; Suspend script (useful in menus)
*^!F12:: ; CTRL+ALT+F12
{
	Suspend()
	Beep(1000, !A_IsSuspended)
}
#SuspendExempt False