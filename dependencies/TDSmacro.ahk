; TDSmacro.ahk
; Copyright (c) 2026 dajalepep
; Licensed under the MIT License. See LICENSE file for details.
; requires FindText.ahk for ahkv2
; what should i do next? man im lazy af
class TDSmacro {
    static lost := false
    static pixelConfidence := 0.05 
    static colorConfidence := 0.05 
    static noisestrength := 8
    static autoskip := true
    static goallist := ["Triumph","Lose"]
    static goal := "Lose"
    
    static readybuttonimg := "|<>*79$74.Ds3zs3kDs3kDDzvzzXzDzzzDzzzzztznzzzzzk0w06MCk0Q7Uw0701g1g031kT00k0P0P00MACkMA7zk3kM203A711zs0w7Uk1n1kE0y4D1sC0Mk0A0D11kS3UCA0303k0Q7Uw3301kTs031sD1Uk0Q0600k07kMA4701U0401g631Uk0ET100v1UkM4047s00wkMDzzzzz7zzyDy3zzzzzlzzy1zUU"
    static levels := [
        "|<>*120$48.DzzzzwzkDzzzzwzkDyzzxwzwDsAwkQnwDnaRbAnwDnaNbAzwDk7PUAzwDnz3bwzw0FD3WQnw0MDbkQnwU", ; level 1
        "|<>*105$52.DzzzzwzwAzzzzznz0HzDTiTDytDsAwkQnzYzCNqQnDyHwtaNnDznDU7N0AzyQzDwCTnznk4HksbAy10MDbkQnk2", ; level 2
        "|<>*114$52.Dzzzzwzs4zzzzznzUHzjzzTDznDsAwkQnyQzCNqQnDsnwtaNnDzVDU7P0AzzUzDwCTnzz04HksbAw10MDbkQnsC", ; level 3
        "|<>*114$53.DzzzzwzzaTzzzztzyQzvzzrnzstz1ba3aTnnwtbNnAzBbtnAnaTwtDU7P0Azs0Tby7Dtzk014wC9nDz831wy3aTyM", ; level 4
        "|<>*113$52.Dzzzzwzs4zzzzznzUHzjzjTDyTDsAwkQntwzCNqQnDUnwtaNnDy1DU7P0AzzkzDwCTnzz04HksbAw10MDbkQnsC", ; level 5
        "|<>*124$52.Dzzzzwzy4zzzzznzk3zjzzTDyTDsAwkQntwzCNqQnDUHwtaNnDy8Dk7PUAztszDwCTnzbU4HksbAyA0MDbkQnw6", ; level 6
        "|<>*122$52.Dzzzzwzs0zzzzznz03zjzzTDwwDsAwkQnzYzCNqQnDyHwtaNnDznDk7PUAzzAzDwCTnztk4HksbAzb0MDbkQnwy"  ; level 7
    ]
    static skipbutton := "|<>*65$28.000C0001g0004M000Uk0041U00U31k60A9Uk11260884k11US0AA0k1UE00A0U01U10080201004080081U00kA000VU001A0003002"
    static leveltext := "|<>*108$40.DzzzzwwzzzzznnzDTiTDDsAwkQkzCNqQn3wtaNnDDU7P0AwzDwCTnk4HksbA0MDbkQm"
    static youlosttext := "|<>*67$123.01zzy01zzU0Tzk003zs000Dzzk0Dzs03zzw00Dz0001zzy00zz00zzzw01zs000Dzzs03zk07wzzk0Dz0001zzz00Ds00zVzy01zs000000w00000Ds0zU0Tz0000007U00003z00003zs000000y00000Tk0000Tz0000007s00007y00007zs000000zU0001zU0001zz0000007y0000Tw0000Dzs000000zs000DzU0007zz0000007zk003zz0001zzs000000zzU03zzz000zzz00zzzzzzzs7zzzzs3zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw"
    static triumphtext := "|<>*136$43.00000C00000070000003U000001k000000s000000Q000000C00000070Dz00zzU7zU0Tzk3zk0Dzs1zs07zw0zw03zy0Ty01zz0Dz00zzU7zU0Tzk3zk0Dzs1zs07zw0zw03zy0Ty01zz0Dz00zzU7zU0Tzk3zk0Dzs1zs07zw0zw03zy0Ty01zz0DzU0zzU7zk0Tzk3zs0Dzs1zw07zw0zy03zy0Tz01zz0DzU0zzU7zk0Tzk2"
    static playtext := "|<>*166$55.07szzky7w00wTzsTXy00CDzs7ky8y77zw3wS4TVXzy8y76DklzyATV77sMzz67s3XsQTz7Xw3k0CDzXkz1s0D7zU0TVw0TXzk0DsyDzlzk03wT7zs08zlyDXzw04TsT7lzy00TyDXw"
    static corneredAtext := "|<>*127$14.3w7ztzyTDjnzsTyrz0xriTzbzsDkU"
    static closemark := "|<>*175$24.xzzjszz7kTy3UDw107s0U3k1k1U3s007w00Dy00Tz00zzU1zzU1zz00zy00Tw00Ds007k1U3U3k107s0UDw1kTy3szz7xzzjU"
    static giveUpTolerance := 2
    static loses := 0
    static rejoining := false
    static UseOCR := true
    static loginRewardsImg := "|<>*110$37.0000C000CDjk0yTzzw0zzzTC0RyD73UQT71MkCDFgiS73gq7D3VqP03lks000ts0000Ds00007s00003w00001i00000r00000P00000BU00007k00023s00070w03s7UT03y7kC"
    static inventoryimg := "|<>*137$22.0sQ07zs0TzU1zy0Dnw0jDE6wxUPzq1Dz84QsUE02300AQ00tk03b00CSQtttzbjbyTyQtxxnjXzzw7zzW" ;to check if player is on the uhh vote for a map type shi
    static solotext := "|<>*142$66.zzzzzzw3zzzy0Dzzzw3zzzs03zzzw3zzzU03zzzw3zzzU03zzzw3zzz003zzzw3zzz0zbz0Dw3y0T0zzw03w7s070Tzs01w7k0303zk00w7U01U0DU60w70A1k03UT0Q70y0s01UTUQ70z0z01UTUQ70z0zw1UTUQ70z0zy0UTUQ70z0bz1UT0Q70y0Uy1k60w7UA1001k00w7U01003s01w7k03007w03w7s07k0Tz0Dw7y0TU"
    static disconnectedtext := "|<>*147$115.zzbzzzzzzzzzzzzzzzy0TXzzzzzzzzzzzzbzzz03tzzzzzzzzzzzznzzzVkzzzzzzzzzzzzztzzzkyDzzzzzzzzzzzzwzzzsT6D3wDVsVsVy3w83Uy4DX60s30Q0Q0S0s01UC07tX6sP766C6CCMPbXa63wlXwTXn7b7bDYTnnt7VwMsSTnsXnXnU2Tts0XkyAS3DtwFtltk1Dww0FsTCDtXwSMwswtzXySTswC76QkyCASQSQSkz77gQ07X0Q1UCDCDD0Q1Uk700DlkT1sD7b7bsT1sS7kY"
    static maps := [
        "Abandoned City", "Abyssal Trench", "Autumn Falling", "Black Spot Exchange", "Candy Valley",
        "Cataclysm", "Chess Board", "Construction Crazy", "Coral Deep", "Crossroads",
        "Crystal Cave", "Cyber City", "Dead Ahead", "Deserted Village", "Dusty Bridges",
        "Farm Lands", "Forest Camp", "Forgetten Docks", "Four Seasons", "Fungi Island",
        "Gilded Path", "Grass Isle", "Harbor", "Hot Spot", "Iceville",
        "Infernal Abyss", "Lay By", "Lighthaos", "Marshlands", "Mason Arch",
        "Medieval Times", "Meltdown", "Midnight Issue", "Moon Base", "Nether",
        "Necropolis", "Night Station", "Northern Lights", "Pier Pressure", "Portland",
        "Retro Crossroads", "Retro Lighthouse", "Retro Rocket Arena", "Retro Stained Temple", "Retro The Heights",
        "Retro Zone", "Rocket Arena", "Ruby Escort", "Sacred Mountains", "Simplicity",
        "Sky Islands", "Space City", "Spring Fever", "Stained Temple", "Sugar Rush",
        "Summer Castle", "The Heights", "Toyboard", "Tropical Industries", "Tropical Isles",
        "U-Turn", "Winter Abyss", "Winter Bridges", "Winter Stronghold", "Wrecked Battlefield",
        "Wrecked Battlefield II",
    ]
    static modifiers := [
        "Hidden Enemies", "Glass", "Exploding Enemies", "Limitation",
        "Committed", "Healthy Enemies", "Speedy Enemies", "Quarantine",
         "Fog", "Flying Enemies", "Broke", "Jailed", 
         "Inflation"
    ]
    static debug := false
    static patience := 180 ;if a loop is more than that long it will try to rejoin
    static gamesorigin := [500,550]
    static lastTowerCord := [100,100]
    static gamemodes := ["Hardcore", "PVP", "Survival", "Special Modes", "Sandbox"]
    static gamemode := "Survival"
    static survivalmodes := ["Easy", "Casual", "Intermediate", "Molten", "Fallen", "Frost"]
    static map := "U-Turn"
    static iterativeReads := 5
    static modifiersInput := []
    static survivalmode := "Frost"
    static starttime := A_TickCount
    static webhookUrl := ""
    static UseTimescale := false
    static timescaleUntil:= 1
    static lastupgardecost := 0
    static selectingTower := false
    static useRapidOCR := true
    static privateServerLink := ""
    static hModule := 0
    static whr := ComObject("WinHttp.WinHttpRequest.5.1")
    static __New() {
        SplitPath(A_LineFile, , &moduleDir)
        if FileExist(A_ScriptDir "\config.ini") {
            iniPath := A_ScriptDir "\config.ini"
        } else if FileExist(moduleDir "\..\config.ini") {
            iniPath := moduleDir "\..\config.ini"
        } else {
            iniPath := A_ScriptDir "\config.ini"
        }

        ; 1. Read webhook URL (default to empty string if missing)
        this.webhookUrl := IniRead(iniPath, "Settings", "DiscordWebhook", "")
        this.privateServerLink := IniRead(iniPath, "Settings", "PrivateServerLink", "")
        if RegExMatch(this.privateServerLink, "code=([^&]+)", &match) {
            this.privateServerLink := "roblox://navigation/share_links?code=" . match[1] . "&type=Server"
        } else {
            this.privateServerLink := ""
        }

        ; 2. Read debug mode (default to false, and parse string safely to boolean)
        debugVal := IniRead(iniPath, "Settings", "Debug", "false")
        this.debug := (debugVal = "true" || debugVal = "1")

        UseOCRVal := IniRead(iniPath, "Settings", "UseOCR", "true")
        this.UseOCR := (UseOCRVal = "true" || UseOCRVal = "1")

        UseTimescale := IniRead(iniPath, "Settings", "UseTimescale", "false")
        this.UseTimescale := (UseTimescale = "true" || UseTimescale = "1")

        useRapidOCR := IniRead(iniPath, "Settings", "UseRapidOCR", "true")
        this.useRapidOCR := (useRapidOCR = "true" || useRapidOCR = "1")

        if (this.useRapidOCR==true) {
            DllCall("SetDllDirectory", "Str", moduleDir "\bin")
            this.hModule := DllCall("LoadLibrary", "Str", moduleDir "\bin\libRapidOCR_v6.dll", "Ptr")
            if (!this.hModule) {
                this.useRapidOCR := false
                if (this.debug) {
                    Webhook.Send("Failed to load libRapidOCR_v6.dll during initialization. Falling back to standard OCR. Error: " A_LastError)
                }
            }
        }

            ; 3. Read default patience (default to 150, and convert to integer safely)
        try {
            this.patience := Max(60,Integer(IniRead(iniPath, "Settings", "DefaultPatience", "150")))
        } catch {
            this.patience := 150
        }
        try {
            this.giveUpTolerance := Max(1,Integer(IniRead(iniPath, "Settings", "giveUpTolerance", "2")))
        } catch {
            this.giveUpTolerance := 2
        }
        try {
            this.iterativeReads := Max(1,Integer(IniRead(iniPath, "Settings", "iterativeReads", "5")))
        } catch {
            this.iterativeReads := 5
        }
        try {
            this.timescaleUntil := Max(1,Integer(IniRead(iniPath, "Settings", "timescaleUntil", "1")))
        } catch {
            this.timescaleUntil := 1
        }
        try {
            this.pixelConfidence := this.Clamp(Number(IniRead(iniPath, "Settings", "pixelConfidence", "0.05")),0,1)
        } catch {
            this.pixelConfidence := 0.05
        }
        try {
            this.colorConfidence := this.Clamp(Number(IniRead(iniPath, "Settings", "colorConfidence", "0.05")),0,1)
        } catch {
            this.colorConfidence := 0.05
        }

        APPBARDATA := Buffer(A_PtrSize == 8 ? 48 : 36, 0)
        NumPut("UInt", APPBARDATA.Size, APPBARDATA, 0)
        state := DllCall("Shell32\SHAppBarMessage", "UInt", 4, "Ptr", APPBARDATA, "UInt")

        warnings := []

        if (A_ScreenHeight != 1080) {
            warnings.Push("Your screen height is NOT 1080, please change it on your settings.")
        }
        if (A_ScreenWidth != 1920) {
            warnings.Push("Your screen width is NOT 1920, please change it on your settings.")
        }
        if (A_ScreenDPI != 96) {
            warnings.Push("Your DPI scale is NOT 100%, please change it on your settings.")
        }
        if (state & 1) {
            warnings.Push("You've enabled Taskbar Auto-Hide, please disable it on your settings.")
        }
        robloxTitle := "ahk_exe RobloxPlayerBeta.exe"
        if WinExist(robloxTitle) {
            isMaximized := (WinGetMinMax(robloxTitle) == 1)
            WinGetPos(,, &winW, &winH, robloxTitle)

            if (!isMaximized || winH >= A_ScreenHeight) {
                warnings.Push("Your current Roblox session isn't in Maximized Window mode (it may be in Fullscreen or normal Windowed mode).")
            }
        } else {
            warnings.Push("You did not open Roblox, please ensure you're playing on Maximized Window Mode.")
        }

        if (warnings.Length!=0) {
            tempstr := " You had " warnings.Length " warnings: `n`n"
            for i,v in warnings {
                tempstr:=tempstr i ". " v
                if (i!=warnings.Length) {
                    tempstr:=tempstr "`n"
                }
            }
            SoundPlay("*16")
            MsgBox(tempstr)
        }

        try {
            if (this.debug == true) {
                if (state & 1) {
                    Webhook.Send("TDSmacro v1.2 Snapshot Taskbar Auto-Hide = true DPI:" A_ScreenDPI " Resolution: " A_ScreenWidth "x" A_ScreenHeight)
                } else {
                    Webhook.Send("TDSmacro v1.2 Snapshot Auto-Hide = false DPI:" A_ScreenDPI " Resolution: " A_ScreenWidth "x" A_ScreenHeight)
                }
            }
        }
    }
    static modifierorigin := [790,380]
    static Clamp(Value, MinVal, MaxVal) {
        return Min(Max(Value, MinVal), MaxVal)
    }
;=================================================================
;Find Static image using strings
;img is for the image variable or if you're a psychopath, copy the string
;err1_mod is pixelConfidence
;err2_mod is colorConfidence
;fromX and fromY is the first location
;toX and toY is the second location
;Its for determining the width and height of the search field
    static Find(img, err1_mod:=0, err2_mod:=0, fromX:=0, fromY:= 0, toX:= A_ScreenWidth, toY:= A_ScreenHeight) {
        ; FindText V2 returns an array of objects if found, or false if not
        if (this.debug == true) {
            try {
                w := Abs(toX - fromX)
                h := Abs(toY - fromY)
                startX := Min(toX, fromX)
                startY := Min(toY, fromY)
                DebugGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
                DebugGui.BackColor := "0000FF"
                WinSetTransColor("EEAA99", DebugGui) 
                DebugGui.MarginX := 0
                DebugGui.MarginY := 0
                DebugGui.Add("Text", "x2 y2 w" (w-4) " h" (h-4) " BackgroundEEAA99") 
                DebugGui.Show("x" startX " y" startY " w" w " h" h " NoActivate")
                SetTimer(() => DebugGui.Destroy(), -1000)
            }
        }
        if (ok := FindText(&locX, &locY, fromX, fromY, toX, toY, this.pixelConfidence + err1_mod, this.colorConfidence + err2_mod, img)) {
            return {x: locX, y: locY}
        }
        return false
    }
;=================================================================
;Find dynamic image using your screen
;x1 and y1 is the first location
;x2 and y2 is the second location
;Its for determining the width and height of the search field
;gray is for turning the search field color into gray
;Scale is for scaling the search field
;process is to change the OCR process
    static OcrWindowRead(x1:=0,y1:=0,x2:=A_ScreenWidth,y2:=A_ScreenHeight,Scale:=1,gray:=0,process:=unset) {
        ; 1. Pre-calculate structural dimensions
        w := Abs(x2 - x1)
        h := Abs(y2 - y1)
        startX := Min(x1, x2)
        startY := Min(y1, y2)
    
        ; 2. Find target window and convert Client coordinates to true Screen coordinates
        targetWin := (IsSet(process) && process != "") ? process : "A"
        hwnd := WinExist(targetWin)
        if !hwnd {
            hwnd := WinExist("A")
        } 
        pt := Buffer(8, 0)
        NumPut("int", startX, pt, 0)
        NumPut("int", startY, pt, 4)
    
        ; Map the internal Client coordinate to the exact pixel location on your Monitor
        DllCall("User32.dll\ClientToScreen", "Ptr", hwnd, "Ptr", pt)
        screenX := NumGet(pt, 0, "int")
        screenY := NumGet(pt, 4, "int")

        ; 3. Handle Debug Box Presentation
        if (this.debug == true) {
            DebugGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20") ; E0x20 makes it click-through
            DebugGui.BackColor := "FF0000" ; Red color
        
            ; Inner cutout to make it a hollow border instead of a solid block
            WinSetTransColor("EEAA99", DebugGui) 
            DebugGui.MarginX := 0
            DebugGui.MarginY := 0
        
            ; Draw a thick red outline (using a placeholder background element)
            DebugGui.Add("Text", "x2 y2 w" (w-4) " h" (h-4) " BackgroundEEAA99") 
        
            ; Show the box, wait 1 second, then destroy it automatically
            DebugGui.Show("x" screenX " y" screenY " w" w " h" h " NoActivate")
            SetTimer(() => DebugGui.Destroy(), -1000) ; Negative time means run once
        }

        ; 4. Route to the chosen OCR Method
        if (this.useRapidOCR == false) {
            gray := gray ? 1 : 0
            if (IsSet(process) == 0) {
                try {
                    process := "ahk_exe " WinGetProcessName("A")
                } catch {
                    process := "ahk_exe RobloxPlayerBeta.exe"
                } 
            }
            ; Native Behavior: Uses window-relative client coordinates
            return OCR.FromWindow(process, {x: startX, y: startY, w: w, h: h, scale: Scale, grayscale: gray})
        } else {
            try {
                ; Native Behavior: Uses absolute screen coordinates calculated above
                buf := ImagePutBuffer({
                    image: [screenX, screenY, w, h],
                    scale: Scale
                })
    
                if (!buf) {
                    Throw Error("Failed to capture region using ImagePutBuffer")
                }
            
                SplitPath(A_LineFile, , &moduleDir)
                optionsJson := '{'
                . '"det_model_path": "' EscapePath(moduleDir "\models\ch_PP-OCRv6_det_small_infer.onnx") '",'
                . '"rec_model_path": "' EscapePath(moduleDir "\models\ch_PP-OCRv6_rec_small_infer.onnx") '",'
                . '"cls_model_path": "' EscapePath(moduleDir "\models\ch_ppocr_mobile_v2.0_cls_infer.onnx") '",'
                . '"only_text": true,'
                . '"use_cls": false,'
                . '"limit_type": "max"'
                . '}'
    
                ; Call the zero-copy DLL function
                pStr := DllCall("libRapidOCR_v6\RapidOcrFromRawPixels", 
                "ptr", buf.ptr, 
                "int", buf.width, 
                "int", buf.height, 
                "int", 4,          ; 4 bytes per pixel (BGRA)
                "int", buf.stride, ; Pitch
                "AStr", optionsJson, 
                "ptr")
    
                if (pStr) {
                    extractedText := StrGet(pStr, "utf-8")
                    return {Text: extractedText}
                }
                return {Text: ""}
            } catch Error as err {
                MsgBox(err.Message)
                return {Text: ""}
            }
        }
    }
    ;OCRawaitmoney 
    static AwaitMoney(n := 0) {
        if (this.CheckLost() == true) {
            return
        }
        if (Type(n) != "Integer") {
            n := 0
        }
        Webhook.SendDebugLog("Awaiting for money to be $" n)
        if (n == 0) {
            return
        }
        loopStartedAt := A_TickCount
        while (true) {
            if (this.CheckLost() == true) {
                break
            }
            this.LoopTimeout(loopStartedAt)
            this.CheckSkip()
            findresult := this.OcrWindowRead(1210,930,1330,960,1)
            try {
                currentmoney := Integer(RegExReplace(findresult.Text, "[^\d]"))
                if (this.debug == true) {
                    ToolTip("Currentmoney: " currentmoney " Saving for $" n)
                }
                if (currentmoney >= n) {
                    break
                }
            }
            Sleep(50)
        }
    }
    ;OCRgetupgradeprice
    static GetUpgradePrice() {
        result := this.OcrWindowRead(1030,630,1180,845,1)
        tablefromresult := StrSplit(RegExReplace(result.Text, "[^\w!@#$%^&*()$+= \-}{\]\[|\\:;.\x22'?><,/]"), " ")
    
        if (!result || !result.Text)
        return 0

        price := 0 
        if RegExMatch(result.Text, "\$(\d+[\d,.]*)", &match) {
            try {
                cleanPrice := RegExReplace(match[1], "[^\d]")
                cache := Integer(cleanPrice)
            
                if (this.debug == true) { 
                    ToolTip("Price found at: " cache) 
                }
            
                if (cache != 0) {
                    price := cache
                }
            } catch {
                price := 0
            }
        }
    
        if (price != 0) { 
            this.lastupgardecost := price 
            Webhook.SendDebugLog("Upgrade Price found at $" price) 
        }
        return price 
    }

    static Timescale() {
        if (this.CheckLost() == true) {
            return
        }
        Webhook.SendDebugLog("Attempting to use timescale ticket")
        xconstant := 660
        if (this.gamemode == this.gamemodes[1]) { ; cuz hardcore cant use consumeable so we have to shift it by a bit
            xconstant := 730
        }
        Click(xconstant,1000)
        Sleep(50)
        ticketsleft := 0
        loopStartedAt := A_TickCount
        while (true) {
            this.LoopTimeout(loopStartedAt)
            if (this.CheckLost() == true) {
                break
            }
            Sleep(50)
            result := this.OcrWindowRead(820,410,1110,700)
            pos := InStr(result.Text, "You have ")
            if (pos != 0) {
                try {
                    cache := StrReplace(StrReplace(StrReplace(SubStr(result.Text,pos+9,4), "O", "0"), "I", "1"), "S", "5")
                    ticketsleft := (RegExReplace(cache, "[^\d]")="") ? -1 : Number(RegExReplace(cache, "[^\d]"))
                }
            }
            if (ticketsleft > this.timescaleUntil) {
                Click(970,630)
                Sleep(500)
                Click(xconstant,1000)
                Sleep(500)
                Click(xconstant,1000)
                break
            } else {
                if (ticketsleft <= this.timescaleUntil && ticketsleft != 0) {
                    this.UseTimescale := false
                    Webhook.SendScreenshot("Saving timescale tickets, disabling timescale and runs macro as usual")
                    Sleep(2000)
                    Click(970,700)
                    break
                }
            }
        }
    }

    static PositiveSquash(n) {
        return (2 / (1 + 2 ** (-n / 2)) - 1)
    }
    ;insanitycheck
    static LoopTimeout(t) {
        if ((A_TickCount - t)/1000 > this.patience) {
            this.lost := true
            this.loses := 0
            Webhook.SendScreenshot("A loop has gone " this.patience "s we will try to rejoin")
            this.Rejoin()
            t := A_TickCount
            return true
        }
        return false
    }

    static CheckLost() {
        if (this.lost == true) {
            return true
        }
        if (this.Find(this.youlosttext,0,0,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/2)) {
            this.lost := true
            this.loses+=1
            elapsedtime := A_TickCount - this.starttime
            Webhook.SendScreenshot("Lost, already lost " this.loses "x, took " Floor(ElapsedTime / 60000) "m " Floor(Mod(ElapsedTime, 60000) / 1000) "s ")
        }
        if (this.Find(this.triumphtext,0,0,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/2)) {
            this.lost := true
            this.loses := 0
            elapsedtime := A_TickCount - this.starttime
            Webhook.SendScreenshot("Triumph, took " Floor(ElapsedTime / 60000) "m " Floor(Mod(ElapsedTime, 60000) / 1000) "s ")
        }
        if (this.loses >= this.giveUpTolerance AND this.goal == this.goallist[1]) {
            this.lost := true
            this.loses := 0
            Webhook.Send("bro loses hope maybe i hallucinate map, imma rejoin rq")
            this.Rejoin()
        }
        if (this.Find(this.disconnectedtext,0,0,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/2)) {
            this.lost := true
            this.loses := 0
            Webhook.SendScreenshot("bro got disconnected get a better wifi")
            this.Rejoin()
        }
        return this.lost
    }
    ;skipable
    static CheckSkip(ontower := false) {
        if (this.autoskip == false) {
            return
        }
        if (pos := this.Find(this.skipbutton, 0.15, 0.05,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/3)) {
            MouseGetPos(&savedX, &savedY)
            ;MouseMove(pos.x, pos.y, 10)
            Sleep(50)
            ;FindText().Click(pos.x, pos.y, "L")
            Click(1023,217)
            Sleep(50)
            MouseMove(savedX, savedY)
            try {
                if (ontower == true && InStr(this.OcrWindowRead(665,780,755,820,1).Text,"Level:") == 0) {
                    this.SelectTower(this.lastTowerCord[1],this.lastTowerCord[2])
                }
            }
        }
    }

    static ParseLevel(text) {
        if RegExMatch(text, "i)Level:\s*([0-5OISois])", &match) {
            val := match[1]
            if (val = "O" || val = "o") {
                return 0
            }
            if (val = "I" || val = "i") {
                return 1
            }
            if (val = "S" || val = "s") {
                return 5
            }
            return Number(val)
        }
    return -1
    }

    static UpgradeUntilLevel(Level) {
        if (this.CheckLost() == true) {
            return
        }
        Webhook.SendDebugLog("Attempting to upgrade until lvl " Level)
        MouseMove(100, 100, 0)
        if (this.UseOCR == true) {
            res := -1
            loop this.iterativeReads {
                if (res==-1) {
                    result := this.OcrWindowRead(665,780,755,820,1)
                    res := this.ParseLevel(result.Text)
                    Sleep(50)
                }
            }

            if (res!=-1) {
                Webhook.SendDebugLog("This tower is level: " res)
            }

            if (res != -1 && res >= Level) {
                return
            }

            if (res != -1 && Level-res > 1) {
                loop (Level-res) {
                    this.UpgradeUntilLevel(res+A_Index)
                    if (this.CheckLost() == false) {
                        ucache := this.lastupgardecost
                        loop this.iterativeReads {
                            seconducache := this.GetUpgradePrice()
                            if (seconducache!=ucache && seconducache!=0) {
                                break
                            }
                            Sleep(50)
                        }
                    }
                }
                return
            }
            upgradeprice := 0
            loop this.iterativeReads {
                cache := this.GetUpgradePrice()
                if (cache != 0) {
                    upgradeprice := cache
                    break
                }
                Sleep(50)
            }
            if (upgradeprice != 0) {
                this.AwaitMoney(upgradeprice)
            }
        }
        loopStartedAt := A_TickCount
        while (true) {
            found := false
            loop this.iterativeReads {
                if (found == false) {
                    if (this.UseOCR == true) {
                        result := this.OcrWindowRead(665,780,755,820,1)
                        reslevel := this.ParseLevel(result.Text)
                        if (reslevel >= Level) {
                            found := true
                        }
                    } else {
                        if (this.Find(this.levels[Level],0,0,A_ScreenWidth/4,A_ScreenHeight/2,A_ScreenWidth*3/4,A_ScreenHeight)) {
                            found := true
                        }
                    }
                }
            }
            if (found == true) {
                break
            }
            Sleep(50)
            Send("e")
            this.CheckSkip(true)
            this.LoopTimeout(loopStartedAt)
            if (this.CheckLost() == true) {
                break
            }
        }
    }
;=================================================================
;Place your tower at desired location
;locationX and locationY is the location
;Keybind is your keybind
;Price is the price of the tower. The default is zero and is optional if you want to fill it or no
    static PlaceTower(locationX, locationY, Keybind, Price := 0) {
        if (this.CheckLost() == true) {
            return
        }
        Webhook.SendDebugLog("Attempting to place key " Keybind " tower at X=" locationX " Y=" locationY)
        this.selectingTower := false
        it := 0
        if (this.UseOCR == true && Price!=0) {
            Webhook.SendDebugLog("Awaiting for money by the assumed placement cost: " Price)
            this.AwaitMoney(Price)
        }
        loopStartedAt := A_TickCount
        while (true) {
            Send(Keybind)
            offsetX := Random(-(this.noisestrength / 2), (this.noisestrength / 2))
            offsetY := Random(-(this.noisestrength / 2), (this.noisestrength / 2))
        
            targetX := this.Clamp(locationX + offsetX*this.PositiveSquash(it), 8, 1927)
            targetY := this.Clamp(locationY + offsetY*this.PositiveSquash(it), 32, 1032)
            
            MouseMove(targetX,targetY,2)
            Sleep(50)
            Click(targetX, targetY)
            Sleep(200)
            MouseGetPos(&mx,&my)
            rescr := this.OcrWindowRead(mx+5,my-85,mx+245,my-60)
            if (InStr(rescr.Text,"Tower")) {
                Send("q")
                this.SelectTower(locationX,locationY)
                return
            }
            OCRplaced := false
            if (this.UseOCR == true) {
                loop this.iterativeReads {
                    if (OCRplaced == false) {
                        MouseGetPos(&mx,&my)
                        res := this.OcrWindowRead(mx+10,my+25,mx+100,my+55,1)
                        if (InStr(res.Text,"Rotate")!=0) {
                            OCRplaced := true
                            break
                        }
                        result := this.OcrWindowRead(665,780,755,820,1)
                        pos:=InStr(result.Text, "Level:")
                        if (pos != 0) {
                            OCRplaced := true
                            break
                        }
                        Sleep(50)
                    }
                }
            } else {
                Sleep(50*this.iterativeReads)
            }
            ;Click(targetX,targetY)
            mult := 3
            if (OCRplaced == false) {
                Sleep(1300 - 50*this.iterativeReads)
                mult := 1
            }

            found := false
            loop this.iterativeReads*mult {
                if (found == false) {
                    if (this.UseOCR == true) {
                        result := this.OcrWindowRead(665,780,755,820,1)
                        level := -1
                        pos:=InStr(result.Text, "Level:")
                        if (pos != 0) {
                            found := true
                        }
                    } else {
                        if (this.Find(this.leveltext,0,0,A_ScreenWidth/4,A_ScreenHeight/2,A_ScreenWidth*3/4,A_ScreenHeight)) {
                            found := true
                        }
                    }
                    Sleep(50)
                }
            }
            if (found == true) {
                break
            }

            this.CheckSkip()
            this.LoopTimeout(loopStartedAt)
            if (this.CheckLost() == true) {
                break
            }
            it:=it+1
        }
        this.lastTowerCord := [locationX,locationY]
        this.selectingTower := true
    }
    static StartMatch() {
        this.lost := false
        this.lastupgardecost := 0
        this.selectingTower := false
        this.lastTowerCord := [100, 100]
        if (this.UseTimescale == true) {
            this.Timescale()
        }
        loopStartedAt := A_TickCount
        while (true) {
            Sleep(20)
            if (this.LoopTimeout(loopStartedAt) == true) {
                this.lost := false
                loopStartedAt := A_TickCount
            }
            if (pos := this.Find(this.readybuttonimg, 0.1, 0.05,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/3)) {
                MouseMove(pos.x, pos.y)
                Sleep(150)
                FindText().Click(pos.x, pos.y, "L")
                Sleep(150)
                break
            }
        }
        this.starttime := A_TickCount
        Webhook.SendDebugLog("Ready Found, Assigning starttime as " this.starttime)
    }

    static RestartMatch() {
        Webhook.SendDebugLog("Awaiting for end/" this.goal)
        if (this.Find(this.readybuttonimg, 0.1, 0.05,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/3)) {
            return
        }
        loopStartedAt := A_TickCount
        while (true) {
            Sleep(20)
            this.CheckSkip()
            this.LoopTimeout(loopStartedAt)
            if (this.CheckLost() == true) {
                this.lost := false
                break
            }
        }
        Webhook.SendDebugLog("Done awaiting button restart match/play again is clicked")
    
        Sleep(300)

        cache:=this.ArrayAutoCorrectSearch(this.goal,this.goallist)
        if (cache[2] = True AND this.rejoining == false) {
            if (cache[1] == this.goallist[1] AND this.map != "" AND this.loses == 0) { ; bassically if it wins
                if (this.privateServerLink!="") {
                    this.Rejoin()
                    return
                }
                this.NewGameSetUp(true)
                this.rejoining := false
                MouseMove(100,100,0)
                return
            }
        }
        ;so below if just if it loses i think
        this.rejoining := false
        loopStartedAt := A_TickCount
        MouseMove(100, 100, 0)
        while (true) {
            Sleep(80)
            if (this.LoopTimeout(loopStartedAt) == true) {
                break
            }
            if (this.Find(this.readybuttonimg, 0.1, 0.05,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/3)) {
                break
            }
            Click(830, 800)
            Sleep(50)
            Click(830, 880)
        }
    }
;Its for selectiong your tower at designated location.
;Do i have to explain more?
    static TowerSelect(locationX,locationY) { ; selecttower( -- legacy mark so i can just ctrl+f it
        if (this.CheckLost() == true) {
            return
        }
        Webhook.SendDebugLog("Attempt to select a tower at X=" locationX " Y=" locationY)
        MouseMove(100,100,0)
        this.selectingTower := false
        it:=0
        Sleep(50)
        loopStartedAt := A_TickCount
        while (true) {
            offsetX := Random(-(this.noisestrength / 2), (this.noisestrength / 2)) + Ceil((locationX/(A_ScreenWidth/2)-1)*15)
            offsetY := Random(-(this.noisestrength / 2), (this.noisestrength / 2)) + Ceil((locationY/(A_ScreenHeight/2)-1)*15)
        
            targetX := this.Clamp(locationX + offsetX*this.PositiveSquash(it), 8, 1927)
            targetY := this.Clamp(locationY + offsetY*this.PositiveSquash(it), 32, 1032)
            this.CheckSkip()
            this.LoopTimeout(loopStartedAt)
            if (this.CheckLost() == true) {
                break
            }
            MouseMove(targetX, targetY,2)
            Sleep(50)
            Click(targetX, targetY)
            Sleep(150)
            loop this.iterativeReads*2 {
                if (this.UseOCR == true) {
                    result := this.OcrWindowRead(665,720,755,850,1)
                    level := -1
                    pos:=InStr(result.Text, "Level:")
                    if (pos != 0) {
                        this.lastTowerCord := [locationX,locationY]
                        this.selectingTower := true
                        return
                    }
                } else {
                    if (this.Find(this.leveltext,0,0,A_ScreenWidth/4,A_ScreenHeight/2,A_ScreenWidth*3/4,A_ScreenHeight)) {
                        this.lastTowerCord := [locationX,locationY]
                        this.selectingTower := true
                        return
                    }
                }
            }
            it++
            Sleep(80)
        }
    }
;=================================================================
;Change your tower passive
;idk what's the name so lets call it passive
;Passive is like DJ Tracks, Ace Pilot Flight Mode, Mercenary base queue unit
;rows is for Passive box row e.g(Purple track is 1, Green track is 2, Red track is 3)
;hasAbiltiy is when ur tower hasAbility 1 is true, 0 is false. Ability shifts your passive location down
;column is for your Passive column e.g(Mercenary base queue 1 = column 1 etc)
    static ChangePassive(rows:=1,hasAbility:=0,column:=1) {
        trackorigin := [1400, 640]
        Sleep(50)
        Click(trackorigin[1]+(rows-1)*65,trackorigin[2]+(column-1)*85+hasAbility*105)
    }
;=================================================================
;Use Your Tower Ability
;key = your keybind
;Btw the ones below is optional
;place is for if you want to place something after pressing ability
;place is used for tower such as Hacker and Brawler
;x and y is the location for place (Reposition and  Cloning)
    static UseAbility(key,x:=unset,y:=unset,place:=false) {
        Sleep(50)
        Send("q")
        Sleep(50)
        MouseMove(100,100,0)
        Sleep(50)
        Send(key)
        Sleep(50)
        prevCord := this.lastTowerCord
        prevSelecting := this.selectingTower
        try {
            if (IsSet(x)==true && IsSet(y)==true) {
                place := (place = true || place = false) ? place : false
                if (place==true) {
                    this.SelectTower(x,y)
                } else {
                    Click(x,y)
                }
            }
        }
        if (prevSelecting==true) {
            this.SelectTower(prevCord[1],prevCord[2])
        }
    }

    static ArrayAutoCorrectSearch(query, Arraylist) {
        for i, needle in Arraylist {
            if InStr(needle, query) {
                return [needle, True, i]
            }
        }
        return [query, False, 0]
    }

    static CalibrateCamera(s:=0) {
        Webhook.SendDebugLog("Calibrating camera")
        MouseMove(A_ScreenWidth // 2, 100, s)
        Sleep(300)
        Click("Right Down")
        MouseMove(A_ScreenWidth // 2, (A_ScreenHeight * 3) // 4)
        Sleep(300)
        Click("Right Up")
        Sleep(50)
        Send("{WheelDown 50}")
    }
    
    static NewGameSetUp(isTriumph:=false) {
        Webhook.SendDebugLog("New game has started boi")
        MouseMove(100, 100, 0)
        loopStartedAt := A_TickCount
        while (true) {
            Sleep(100)
            if (this.LoopTimeout(loopStartedAt) == true) {
                return
            }
            if (this.Find(this.inventoryimg, 0.15, 0.05, 700, 840, 740, 880)) {
                break
            }
            if (isTriumph==true) {
                if (this.Find(this.triumphtext,0,0,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/2)) {
                    Click(830, 800)
                    Sleep(50)
                    Click(830, 880)
                }
            }
        }
        Sleep(300)
        Send("{Escape}")
        Sleep(200)
        Send("{r}")
        Sleep(200)
        Send("{Enter}")
        Sleep(6000)

        this.VoteModifiers()

        this.CalibrateCamera(4)
        Sleep(200)
        Send("{s Down}")
        Sleep(4500)
        Send("{s Up}")
        Sleep(200)

        Send("{w Down}")
        Sleep(2000)
        Send("{w Up}")
        Sleep(200)

        Send("{a Down}")
        Sleep(2200)
        Send("{a Up}")
        Sleep(200)

        Send("{e Down}")
        Sleep(300)
        Send("{e Up}")
        Sleep(1000)
        found := false
        Loop 20 {
            if (found = false) {
                Sleep(50)
                if (this.Find(this.corneredAtext, 0.15, 0.05, 695, 230, 715, 250)) {
                    found := true
                }   
            }
        }
        if (found = false) {
            this.NewGameSetUp()
            return
        }

        ; do these below if it found
        Click(733, 248)
        SendText(this.ArrayAutoCorrectSearch(this.map,this.maps)[1])
        Sleep(200)
        Click(782, 339)
        Sleep(400)

        if (InStr(TDSmacro.OcrWindowRead(810,245,1110,265).Text, "Map is already")!=0) {
            this.Rejoin()
            return
        }

        Send("{s Down}")
        Sleep(4000)
        Send("{s Up}")
        Sleep(200)

        Send("{d Down}")
        Sleep(3500)
        Send("{d Up}")
        Sleep(200)
        Send("{e Down}")
        Sleep(200)
        Send("{e Up}")
        Sleep(200)
        Click(972,878)
        loopStartedAt := A_TickCount
        while (true) {
            if (this.LoopTimeout(loopStartedAt) == true) {
                return
            }
            if (pos := this.Find(this.readybuttonimg, 0.1, 0.05,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/3)) {
                break
            }
        }
        Sleep(150)
        this.CalibrateCamera()
    }

    static VoteModifiers() {
        if !(Type(this.modifiersInput) = "Array") {
            return
        }
        cache := []
        for i,v in this.modifiersInput {
            res := this.ArrayAutoCorrectSearch(v,this.modifiers)
            if (res[2] == True) {
                cache.Push(res[3]-1)
            }
        }
        Webhook.SendDebugLog("Selecting Modifiers")
        Sleep(50)
        Click(73,976)
        Sleep(50)
        for v in cache {
            Click(this.modifierorigin[1]+Mod(v,4)*120,this.modifierorigin[2]+Floor(v/4)*110)
            Sleep(10)
        }
        Click(1125,888)
    }
    
    static Rejoin() {
        this.rejoining := true
        if (this.privateServerLink!="") {
            if ProcessExist("RobloxPlayerBeta.exe") {
                ProcessClose("RobloxPlayerBeta.exe")
            }
            Run(this.privateServerLink)
        } else {
            Run("roblox://placeId=3260590327")
        }
        Sleep(10000)
        loopStartedAt := A_TickCount
        while (true) {
            Sleep(100)
            try {
                WinActivate("ahk_exe RobloxPlayerBeta.exe")
            }
            if (this.LoopTimeout(loopStartedAt) == true) {
                return
            }
            if (pos := this.Find(this.playtext, 0.15, 0.05,A_ScreenWidth/3,A_ScreenHeight*3/4,A_ScreenWidth*2/3,A_ScreenHeight)) {
                MouseGetPos(&savedX, &savedY)
                MouseMove(pos.x, pos.y, 5)
                Sleep(50)
                Click(pos.x, pos.y)
                Sleep(50)
                MouseMove(savedX, savedY)
                break
            }
            if (pos := this.Find(this.loginRewardsImg, 0.05, 0.05, 640, 375, 700, 405)) {
                Click(970,800)
            }
        }
        Webhook.SendDebugLog("Play text found")
        loopStartedAt := A_TickCount
        while (true) {
            if (this.LoopTimeout(loopStartedAt) == true) {
                return
            }
            if (pos := this.Find(this.closemark, 0.05, 0.05, 1160, 250, 1210, 350)) {
                Sleep(200)
                break
            }
            Sleep(50)
        }
        cache := this.ArrayAutoCorrectSearch(this.gamemode,this.gamemodes)
        Click((cache[3]-1)*250+this.gamesorigin[1],this.gamesorigin[2])
        Sleep(500)
        if (cache[1] = this.gamemodes[3]) {
            Click((this.ArrayAutoCorrectSearch(this.survivalmode,this.survivalmodes)[3]-1)*250-125+this.gamesorigin[1],this.gamesorigin[2])
        }
        Webhook.SendDebugLog("Awaiting for solotext")
        loopStartedAt := A_TickCount
        while (true) {
            if (this.LoopTimeout(loopStartedAt) == true) {
                return
            }
            Sleep(80)
            if (pos := this.Find(this.solotext, 0.18, 0.05,550,330,960,560)) {
                Click(pos.x, pos.y-100)
                break
            }
        }
        this.NewGameSetUp()
    }
;==============================================================
;LEGACY WRAPPER (So we dont have to edit every strat lol)
;NEW USERS CAN USE THE NEW FUNCTIONS NAME BUT FOR THE LEGACY, IS THE LEGACY
    static logTodc(msg) {
        Webhook.Send(msg)
    }
    static canplace(locationX, locationY, Keybind, Price := 0) { ;this is a wrapper so legacy starts work i guess
        this.PlaceTower(locationX, locationY, Keybind, Price)
    }
    
    static selecttower(locationX, locationY) {
        this.TowerSelect(locationX,locationY)
    }
    static upgradeuntil(Level) {
        this.UpgradeUntilLevel(Level)
    }
    static restartonlost() {
        this.RestartMatch()
    }
    static clickready() {
        this.StartMatch()
    }
    static ChangeTrack(rows:=1,hasAbility:=0,column:=1) {
        this.ChangePassive(rows, hasAbility, column)
    }
    static CalibrateCam() {
        this.CalibrateCamera()
    }
}

EscapePath(path) {
    return StrReplace(path, "\", "/")
}

#Include FindText.ahk
#Include OCR.ahk
#Include ImagePut.ahk
#Include Webhook.ahk