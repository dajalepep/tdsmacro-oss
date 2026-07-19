#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\dependencies\TDSmacro.ahk
SendMode "Event"
SetDefaultMouseSpeed 4

; Configuration Variables
killswitch := "F3"
start := "F1"
calibratecam := "F2"
TDSmacro.patience := 600
TDSmacro.gamemode := "Hardcore"

pyroloc := [812, 52]
sniperlocations := [
    [620, 753]
]
loop 2 {
    sniperlocations.Push([sniperlocations[1][1]+(52*A_Index),sniperlocations[1][2]])
}
evolvedtowerlocation := [955, 308]
; Coordinate Modes Setup for AHK v2
CoordMode("Mouse", "Window")

; Bind Hotkeys dynamically
Hotkey(killswitch, ExitLabel)
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
        TDSmacro.StartMatch()
        Sleep(20)
        TDSmacro.PlaceTower(pyroloc[1],pyroloc[2],"1")
        Sleep(200)
        TDSmacro.UpgradeUntilLevel(3)
        Sleep(50)
        for i, v in sniperlocations {
            TDSmacro.PlaceTower(v[1], v[2], "2",450)
            TDSmacro.UpgradeUntilLevel(3)
        }
        TDSmacro.PlaceTower(evolvedtowerlocation[1], evolvedtowerlocation[2], "3")
        TDSmacro.UpgradeUntilLevel(4)
        TDSmacro.RestartMatch()
    }
}