#Requires AutoHotkey v2.0
#Include FindText.ahk
#Include TDSmacro.ahk
SendMode "Event"
SetDefaultMouseSpeed 4

; Configuration Variables
killswitch := "F3"
start := "F1"
calibratecam := "F2"

TDSmacro.goal := "Triumph"
TDSmacro.modifiersarrayinput := ["Hidden", "Glass", "Explod", "Limit", "Com", "Fog"]
TDSmacro.map := "Blac"
TDSmacro.survivalmode := "Easy"
;TDSmacro.debug := true
TDSmacro.patience := 180
gscoutloc := [
    [1072,534]
]

leftelectroloc := [
    [596,646]
]
rightelectroloc := [
    [1342,646]
]
electroloc := []
F4::{
    TDSmacro.logTodc("Hello world!")
}
F5::{
    TDSmacro.logScreenshot("Print screenshot!")
}
Loop 4 {
    gscoutloc.Push([gscoutloc[gscoutloc.length][1]-52,gscoutloc[gscoutloc.length][2]])
}

gscoutsecondbatch := []
refrence := gscoutloc.Clone()
its := 1
loop 2 {
    for i,v in refrence {
        gscoutsecondbatch.Push([v[1],v[2]+(52*its)])
    }
    its+=1
}
refrence := leftelectroloc.Clone()
its := 1
loop 2 {
    for i,v in refrence {
        leftelectroloc.Push([v[1]+(3*its),v[2]-(52*its)])
    }
    its+=1
}
refrence := rightelectroloc.Clone()
its := 1
loop 2 {
    for i,v in refrence {
        rightelectroloc.Push([v[1]-(3*its),v[2]-(52*its)])
    }
    its+=1
}
loop rightelectroloc.Length {
    electroloc.Push([leftelectroloc[A_Index][1],leftelectroloc[A_Index][2]])
    electroloc.Push([rightelectroloc[A_Index][1],rightelectroloc[A_Index][2]])
}

; Coordinate Modes Setup for AHK v2
CoordMode("Mouse", "Window")

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

UpgradeBatches(targetLevel) {
    for batch in [gscoutloc, gscoutsecondbatch] {
        for i, v in batch {
            TDSmacro.selecttower(v[1], v[2])
            TDSmacro.upgradeuntil(targetLevel)
        }
    }
}

StartLabel(HotkeyName) {
    while (true) {
        ;TDSmacro.autoskip := true
        TDSmacro.lost := false
        TDSmacro.clickready()
        Sleep(20)
        for i,v in gscoutloc {
            TDSmacro.canplace(v[1],v[2],"1")
        }
        Sleep(200)
        for i,v in gscoutloc {
            TDSmacro.selecttower(v[1],v[2])
            TDSmacro.upgradeuntil(2)
        }
        for i,v in electroloc {
            TDSmacro.canplace(v[1],v[2],"2")
            TDSmacro.upgradeuntil(2)
        }
        for i,v in gscoutsecondbatch {
            TDSmacro.canplace(v[1],v[2],"1")
            TDSmacro.upgradeuntil(2)
        }
        Sleep(200)
        ;TDSmacro.autoskip := false
        UpgradeBatches(3)
        UpgradeBatches(4)
        Sleep(50)        
        ; 5. Handle Game Over state and loops back
        TDSmacro.restartonlost()
    }
}