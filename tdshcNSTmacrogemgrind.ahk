#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\dependencies\TDSmacro.ahk
SendMode "Event"
SetDefaultMouseSpeed 4

; Configuration Variables
killswitch := "F3"
start := "F1"
calibratecam := "F2"
TDSmacro.patience := 600
TDSmacro.gamemode := "Hardcore"

pyroloc := [807, 34]
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
    MouseMove(A_ScreenWidth // 2, 100, 5)
    Sleep(100)
    Click("Right Down")
    MouseMove(A_ScreenWidth // 2, (A_ScreenHeight * 3) // 4, 8)
    Sleep(200)
    Click("Right Up")
    Sleep(150)
    Send("{WheelDown 50}")
}

StartLabel(HotkeyName) {
    while (true) {
        TDSmacro.lost := false
        TDSmacro.clickready()
        Sleep(20)
        TDSmacro.canplace(pyroloc[1],pyroloc[2],"1",900)
        Sleep(200)
        TDSmacro.upgradeuntil(3)
        Sleep(50)
        for i, v in sniperlocations {
            TDSmacro.canplace(v[1], v[2], "2",450)
            TDSmacro.upgradeuntil(3)
        }
        TDSmacro.canplace(evolvedtowerlocation[1], evolvedtowerlocation[2], "3")
        TDSmacro.upgradeuntil(4)
        TDSmacro.restartonlost()
    }
}