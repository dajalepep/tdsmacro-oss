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
engineerlocations := [
    [952, 172+15],
    [980, 206+15],
    [1011, 246+15]
]
minilocations := [
    [955, 308]
]

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
        TDSmacro.PlaceTower(pyroloc[1],pyroloc[2],"1")
        TDSmacro.UpgradeUntilLevel(3)
        for i, v in engineerlocations {
            TDSmacro.PlaceTower(v[1], v[2], "2",600)
            TDSmacro.UpgradeUntilLevel(3)
        }
        for i, v in minilocations {
            TDSmacro.PlaceTower(v[1], v[2], "3")
            TDSmacro.UpgradeUntilLevel(4)
        }
        TDSmacro.RestartMatch()
    }
}