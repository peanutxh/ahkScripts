SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; https://www.autohotkey.com/docs/KeyList.htm

; left Alt + mouseWheelUp, prev Virtual Desktop
!WheelUp::
Send, #^{Left}
return
; left Alt + mouseWheelDown, next Virtual Desktop
!WheelDown::
Send, #^{Right}
return
; left Alt + Q, previous Virtual Desktop
!q::
Send, #^{Left}
return
; left Alt + W, next Virtual Desktop
!w::
Send, #^{Right}
return

; left Window key + W
<#w::
run cmd.exe /c start firefox.exe -p Work,,hide
sleep 330
return
; left Window key + Q
<#q::
run cmd.exe /c start firefox.exe -p Pers,,hide
sleep 330
return

; Vol & brightness offset - usage and examples: https://redd.it/owgn3j
DetectHiddenWindows On
#PgDn::Brightness(-1)
#PgUp::Brightness(+1)
Volume_Up::  Volume(+1)
Volume_Down::Volume(-1)

Volume(offset)
{
    hWnd := DllCall("User32\FindWindow", "Str","NativeHWNDHost", "Ptr",0)
    PostMessage 0xC028, 0x0C, 0xA0000,, % "ahk_id" hWnd
    SoundSet % Format("{:+d}", offset)
    ; Sleep 25 ; For smoother change
}

Brightness(Offset)
{
	static wmi, last := -1, brightness := Brightness_Init(wmi)

	hWnd := DllCall("User32\FindWindow", "Str","NativeHWNDHost", "Ptr",0)
	PostMessage 0xC028, 0x037,,, % "ahk_id" hWnd
	brightness += Offset
	brightness := Min(100, Max(0, brightness))
	if (last = brightness)
		return
	last := brightness
	for method in wmi.ExecQuery("SELECT * FROM WmiMonitorBrightnessMethods")
		method.WmiSetBrightness(0, brightness)
}

Brightness_Init(ByRef WmiObj)
{
	WmiObj := ComObjGet("winmgmts:\\.\root\WMI")
	for monitor in WmiObj.ExecQuery("SELECT * FROM WmiMonitorBrightness")
		return monitor.CurrentBrightness
}