﻿
#Requires Autohotkey v2
;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

if A_LineFile = A_ScriptFullPath && !A_IsCompiled
{
	myGui := Constructor()
	myGui.Show("w1181 h621")
}

Constructor()
{	
	myGui := Gui()
	ButtonCreateprojectbe := myGui.Add("Button", "x32 y24 w151 h58", "Create project be")
	ButtonCreateprojectbe.OnEvent("Click", OnEventHandler)
	myGui.OnEvent('Close', (*) => OnEventCloseHandler())
	myGui.Title := "My Tool"
	
	OnEventHandler(*)
	{
		ToolTip("Tao project be" ButtonCreateprojectbe.Text "`n", 77, 277)
		; RunWait "C:/Program Files/AutoHotkey/v2/AutoHotkey64.exe /force create-project-be.ahk"
		Run "create-project-be.ahk"
		SetTimer () => Send("^k"), -1000
		SetTimer () => ToolTip(), -3000 ; tooltip timer
	}


	OnEventCloseHandler(*)
	{
		ExitApp()
	}	
	return myGui
}