#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\dependencies\TDSmacro.ahk
SendMode "Event"
SetDefaultMouseSpeed 4

; Configuration Variables
killswitch := "F3"
start := "F1"
calibratecam := "F2"

TDSmacro.goal := "Triumph"
TDSmacro.modifiersarrayinput := ["Hidden", "Glass", "Explod", "Limit", "Com", "Fog", "Fly"]
TDSmacro.map := "Dead Ahead"
TDSmacro.survivalmode := "Easy"


; Coordinate Modes Setup for AHK v2
CoordMode("Mouse", "Window")

leftsoldiers := [[890,130]]
rightsoldiers := [[975,130]]
soldiers := []

loop 4 {
    leftsoldiers.Push([leftsoldiers[1][1]-(2*A_Index),leftsoldiers[1][2]+(48*A_Index)])
    rightsoldiers.Push([rightsoldiers[1][1],rightsoldiers[1][2]+(48*A_Index)])
}

for i,v in leftsoldiers.Clone() {
    leftsoldiers.Push([v[1]-48,v[2]])
}
for i,v in rightsoldiers.Clone() {
    rightsoldiers.Push([v[1]+48,v[2]])
}

loop leftsoldiers.Length {
    soldiers.Push(leftsoldiers[A_Index])
    soldiers.Push(rightsoldiers[A_Index])
}

; Bind Hotkeys dynamically
Hotkey("$" . killswitch, ExitLabel)
Hotkey(start, StartLabel)
Hotkey(calibratecam, CalibrateLabel)
return

ExitLabel(HotkeyName) {
    ExitApp()
}

CalibrateLabel(HotkeyName) {
    TDSmacro.CalibrateCam()
}

F4::{
    MouseGetPos(&mx,&my)
    TDSmacro.canplace(mx,my,"1",450)
}

StartLabel(HotkeyName) {
    while (true) {
        TDSmacro.lost := false
        TDSmacro.autoskip := true
        TDSmacro.clickready()
        early := 0
        for i,v in soldiers {
            placeprice := 450
            if early < 2 {
                placeprice := 0
                early+=1
            }
            TDSmacro.canplace(v[1],v[2],"1",placeprice)
            TDSmacro.upgradeuntil(2)
        }
        TDSmacro.autoskip:=false
        for i,v in soldiers {
            TDSmacro.selecttower(v[1],v[2])
            TDSmacro.upgradeuntil(3)
        }

        TDSmacro.restartonlost()
    }
}