#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\dependencies\TDSmacro.ahk
SendMode "Event"
SetDefaultMouseSpeed 4

; Configuration Variables
killswitch := "F3"
start := "F1"
calibratecam := "F2"

TDSmacro.goal := "Triumph"
TDSmacro.modifiersInput := ["Hidden", "Glass", "Explod", "Limit", "Com", "Fly"]
TDSmacro.map := "Dead Ahead"
TDSmacro.survivalmode := "Easy"


; Coordinate Modes Setup for AHK v2
CoordMode("Mouse", "Window")

leftmilitants := [[889,165]]
rightmilitants := [[975,165]]
militants := []

loop 4 {
    leftmilitants.Push([leftmilitants[1][1]-(2*A_Index),leftmilitants[1][2]+(48*A_Index)])
    rightmilitants.Push([rightmilitants[1][1],rightmilitants[1][2]+(48*A_Index)])
}

for i,v in leftmilitants.Clone() {
    leftmilitants.Push([v[1]-48,v[2]])
}
for i,v in rightmilitants.Clone() {
    rightmilitants.Push([v[1]+48,v[2]])
}

loop leftmilitants.Length {
    militants.Push(leftmilitants[A_Index])
    militants.Push(rightmilitants[A_Index])
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
    TDSmacro.CalibrateCamera()
}

StartLabel(HotkeyName) {
    while (true) {
        TDSmacro.lost := false
        TDSmacro.autoskip := true
        TDSmacro.StartMatch()
        early := 0
        for i,v in militants {
            placeprice := 600
            if early < 2 {
                placeprice := 0
                early+=1
            }
            TDSmacro.PlaceTower(v[1],v[2],"1",placeprice)
            TDSmacro.UpgradeUntilLevel(1)
        }
        TDSmacro.autoskip:=false
        index := 2
        loop 3 {
            for i,v in militants {
                TDSmacro.TowerSelect(v[1],v[2])
                TDSmacro.UpgradeUntilLevel(index)
            }
            index+=1
        }

        TDSmacro.RestartMatch()
    }
}