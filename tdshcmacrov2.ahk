#Requires AutoHotkey v2.0
#Include FindText.ahk
#Include TDSmacro.ahk
SendMode "Event"
SetDefaultMouseSpeed 4

; Configuration Variables
killswitch := "F3"
start := "F1"
calibratecam := "F2"
TDSmacro.patience := 600
TDSmacro.debug := true

pyroloc := [807, 34]
engineerlocations := [
    [952, 172],
    [980, 206],
    [1011, 246]
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
        
        ; 1. Wait and click ready button
        TDSmacro.clickready()
        
        ; 2. Place Pyro and upgrade it to Level 3
        Send("1")
        Sleep(20)
        ;Click(pyroloc[1], pyroloc[2])
        TDSmacro.canplace(pyroloc[1],pyroloc[2],"1")
        Sleep(200)
        TDSmacro.upgradeuntil(3) ; target level 3 index
        Sleep(50)
        
        ; 3. Place Engineers and upgrade them to Level 3
        for i, v in engineerlocations {
            TDSmacro.canplace(v[1], v[2], "2")
            TDSmacro.upgradeuntil(3) ; level 3 index
        }
        
        ; 4. Place Minis and upgrade them to Level 2
        for i, v in minilocations {
            TDSmacro.canplace(v[1], v[2], "3")
            TDSmacro.upgradeuntil(4) ; level 2 index
        }
        
        ; 5. Handle Game Over state and loops back
        TDSmacro.restartonlost()
    }
}