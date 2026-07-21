#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\dependencies\TDSmacro.ahk
#SingleInstance Force
SendMode "Event"
SetDefaultMouseSpeed 4
;===============================================================
;BRAWLER NO VIP NEEDED COIN GRIND ON WINTER BRIDGES
;MAKE SURE TO BRING BRAWLER IN 1ST SLOT AND THEN DJ IN 2ND SLOT
;MAKE SURE YOU HAVE GOOD SKILL TREEE
;MADE BY ANONE
;ts like require max range skill tree 😭
;===============================================================


; Configuration Variables
killswitch := "F3"
start := "F1"
calibratecam := "F2"

TDSmacro.goal := "Lose"
TDSmacro.map := "Winter Bridges"
TDSmacro.survivalmode := "Frost"

; Coordinate Modes Setup for AHK v2
CoordMode("Mouse", "Window")

FrontBrawlers := []
FrontUpBrawlers := [
[1375, 197],
[1346, 161]
]
FrontBotBrawlers := [
[1366,283],
[1326,276]
]
Loop 2 {
FrontBrawlers.Push(FrontBotBrawlers[A_Index])
FrontBrawlers.Push(FrontUpBrawlers[A_Index])
}
MidBrawlers := [
[1200,157]
]
DjLoc := [1245,270]
Loop 5 {
X_Index := (A_Index < 4)?40*(Floor(A_Index/2)):-40
Y_Index := 40*(Mod(A_Index, 2))
MidBrawlers.Push([MidBrawlers[1][1] + X_Index, MidBrawlers[1][2] + Y_Index])
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
Select(x, y) {
    TDSmacro.TowerSelect(x + 5,y - 8)
}
StartLabel(HotkeyName) {
    while (true) {
        TDSmacro.lost := false
        TDSmacro.autoskip := true
        TDSmacro.StartMatch()
        ;PLACE 3 BRAWLERS IN FRONT
        for i,v in FrontBrawlers {
            if (i <= 3) {
            TDSmacro.PlaceTower(v[1],v[2],"1",0)
            } else {
                break
            }
        }
        ;UPGRADE 3 BRAWLERS IN FRONT
        for i,v in FrontBrawlers {
            if (i <= 3) {
            Select(v[1],v[2])
            TDSmacro.UpgradeUntilLevel(1)
            } else {
                break
            }
        }
        ;PLACE 3 BRAWLERS IN MID
        Loop 3 {
            TDSmacro.PlaceTower(MidBrawlers[A_Index][1],MidBrawlers[A_Index][2],"1",300)
        }
        ;UPGRADE 3 BRAWLERS IN MID TO LV 1
        Loop 3 {
            Select(MidBrawlers[A_Index][1],MidBrawlers[A_Index][2])
            TDSmacro.UpgradeUntilLevel(1)
        }
        ;UPGRADE 2 BRAWLERS IN MID TO LV 2, PLACE DJ, AND UPGRADE THIRD BRAWLER TO LV 2
        Loop 3 {
            Select(MidBrawlers[A_Index][1],MidBrawlers[A_Index][2])
            TDSmacro.UpgradeUntilLevel(2)
            if (A_Index == 2) {
                TDSmacro.PlaceTower(DjLoc[1],DjLoc[2],"2",850)
            }
        }
        ;UPGRADE 3 BRAWLERS IN FRONT TO LV 2
        Loop 3 {
            Select(FrontBrawlers[A_Index][1], FrontBrawlers[A_Index][2])
            TDSmacro.UpgradeUntilLevel(2)
        }
        ;PLACE 1 BRAWLER IN FRONT AND UPGRADE IT TO LV 2
        TDSmacro.PlaceTower(FrontBrawlers[4][1],FrontBrawlers[4][2],"1",300)
        TDSmacro.UpgradeUntilLevel(2)
        ;UPGRADE 3 BRAWLERS IN MID TO LV 3
        Loop 3 {
            Select(MidBrawlers[A_Index][1], MidBrawlers[A_Index][2])
            TDSmacro.UpgradeUntilLevel(3)
        }
        ;PLACE 3 MORE BRAWLERS LV 3 IN MID
        Loop 3 {
            Index := A_index + 3
            TDSmacro.PlaceTower(MidBrawlers[Index][1],MidBrawlers[Index][2],"1",300)
            TDSmacro.UpgradeUntilLevel(3)
        }
        ;UPGRADE ALL BRAWLER IN FRONT TO LV 3
        for i, v in FrontBrawlers {
            Select(v[1], v[2])
            TDSmacro.UpgradeUntilLevel(3)
        }
        ;UPGRADE ALL BRAWLERS IN MID TO LV 4
        for i, v in MidBrawlers {
            Select(v[1], v[2])
            TDSmacro.UpgradeUntilLevel(4)
        }
        ;UPGRADE ALL BRAWLERS IN FRONT TO LV 4
        for i, v in FrontBrawlers {
            Select(v[1], v[2])
            TDSmacro.UpgradeUntilLevel(4)
        }
        ;UPGRADE ALL BRAWERS IN MID TO MAX, STARTING FROM THE 3RD BRAWLER
        Loop MidBrawlers.length {
            Index := Mod((A_Index + 1), 6) + 1
            Select(MidBrawlers[Index][1], MidBrawlers[Index][2])
            TDSmacro.UpgradeUntilLevel(5)
        }
        ;UPGRADE ALL BRAWLER IN FRONT TO MAX, PROB USELESS CUZ YOU WILL LOSE BEFORE THIS
        for i, v in FrontBrawlers {
            Select(v[1], v[2])
            TDSmacro.UpgradeUntilLevel(5)
        }
        TDSmacro.RestartMatch()
    }
}