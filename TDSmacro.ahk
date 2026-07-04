; TDSmacro.ahk
; requires FindText.ahk for ahkv2
; later i might try make OCR.ahk also needed so we can do 2 path towers :D
class TDSmacro {
    static lost := false
    static pixelconfidence := 0.05 
    static colorconfidence := 0.05 
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
    static giveuptolarance := 2
    static loses := 0
    static rejoining := false
    static sandclockimg := "|<>*137$22.0sQ07zs0TzU1zy0Dnw0jDE6wxUPzq1Dz84QsUE02300AQ00tk03b00CSQtttzbjbyTyQtxxnjXzzw7zzW" ;to check if player is on the uhh vote for a map type shi
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
    static patience := 150 ;if a loop is more than that long it will try to rejoin
    static gamesorigin := [500,550]
    static gamemodes := ["Hardcore", "PVP", "Survival", "Special Modes", "Sandbox"]
    static gamemode := "Survival"
    static survivalmodes := ["Easy", "Casual", "Intermediate", "Fallen", "Frost"]
    static map := "U-Turn"
    static modifiersarrayinput := []
    static survivalmode := "Frost"
    static starttime := A_TickCount
    ;static hardcoremodes := ["Hardcore", "Voidcore"]
    ;static hardcoremode := "Hardcore"
    static webhookUrl := ""
    static gdiToken := 0
    static whr := ComObject("WinHttp.WinHttpRequest.5.1")
    static __New() {
        ; A_LineFile gets the path of THIS specific file, ensuring the INI is found
        SplitPath(A_LineFile, , &moduleDir)
        iniPath := moduleDir "\config.ini"

        ; 1. Read webhook URL (default to empty string if missing)
        this.webhookUrl := IniRead(iniPath, "Settings", "DiscordWebhook", "")

        ; 2. Read debug mode (default to false, and parse string safely to boolean)
        debugVal := IniRead(iniPath, "Settings", "Debug", "false")
        this.debug := (debugVal = "true" || debugVal = "1")

            ; 3. Read default patience (default to 150, and convert to integer safely)
        try {
            this.patience := Integer(IniRead(iniPath, "Settings", "DefaultPatience", "150"))
        } catch {
            this.patience := 150
        }
        
        ; Initialize GDI+ once for the lifetime of the macro
        si := Buffer(A_PtrSize = 8 ? 24 : 16, 0)
        NumPut("UInt", 1, si)
        DllCall("gdiplus\GdiplusStartup", "Ptr*", &token := 0, "Ptr", si, "Ptr", 0)
        this.gdiToken := token
    }
    static modifierorigin := [790,380]
    static Clamp(Value, MinVal, MaxVal) {
        return Min(Max(Value, MinVal), MaxVal)
    }
    static logTodc(msg) {
        if (this.webhookUrl == "") {
            return false
        }
        try {
            payload := '{"content": "' msg '"}'
        
            this.whr.Open("POST", this.webhookUrl, true)
            this.whr.SetRequestHeader("Content-Type", "application/json")
            this.whr.Send(payload)
            return true
        } catch {
            return false
        }
    }

    static logScreenshot(msg := "") {
    if (this.webhookUrl == "")
            return false

        if (this.debug)
            this.logTodc("Capturing screenshot...")

        try {
            pngBuffer := this.CaptureScreenToRAM()
            if (!pngBuffer || pngBuffer.Size == 0) {
                this.logTodc(msg . " (Failed to capture screenshot - buffer empty)")
                return false
            }

            if (this.debug)
                this.logTodc("Screenshot captured, size: " pngBuffer.Size " bytes. Preparing to send...")

            boundary := "----AHKWebhookBoundary" . A_TickCount
            
            ; Build HTTP multipart frames
            header := ""
            if (msg != "") {
                header .= "--" boundary "`r`n"
                header .= 'Content-Disposition: form-data; name="content"' "`r`n`r`n"
                header .= msg "`r`n"
            }
            header .= "--" boundary "`r`n"
            header .= 'Content-Disposition: form-data; name="file"; filename="screenshot.png"' "`r`n"
            header .= "Content-Type: image/png`r`n`r`n"
            
            footer := "`r`n--" boundary "--`r`n"
            
            bufHeader := this.StrToBuf(header, "UTF-8")
            bufFooter := this.StrToBuf(footer, "UTF-8")
            
            ; Combine header + PNG RAM buffer + footer into a single SafeArray
            totalSize := bufHeader.Size + pngBuffer.Size + bufFooter.Size
            SafeArr := ComObjArray(0x11, totalSize) ; 0x11 = Byte array
            
            pvData := 0
            if DllCall("oleaut32\SafeArrayAccessData", "Ptr", ComObjValue(SafeArr), "Ptr*", &pvData) == 0 {
                DllCall("RtlMoveMemory", "Ptr", pvData, "Ptr", bufHeader.Ptr, "Ptr", bufHeader.Size)
                DllCall("RtlMoveMemory", "Ptr", pvData + bufHeader.Size, "Ptr", pngBuffer.Ptr, "Ptr", pngBuffer.Size)
                DllCall("RtlMoveMemory", "Ptr", pvData + bufHeader.Size + pngBuffer.Size, "Ptr", bufFooter.Ptr, "Ptr", bufFooter.Size)
                DllCall("oleaut32\SafeArrayUnaccessData", "Ptr", ComObjValue(SafeArr))
            } else {
                throw Error("SafeArrayAccessData failed")
            }
            
            whr := ComObject("WinHttp.WinHttpRequest.5.1")
            whr.Open("POST", this.webhookUrl, false)
            whr.SetTimeouts(0, 30000, 30000, 60000)
            whr.SetRequestHeader("Content-Type", "multipart/form-data; boundary=" boundary)
            
            if (this.debug)
                this.logTodc("Sending screenshot to Discord...")

            whr.Send(SafeArr)
            
            if (this.debug)
                this.logTodc("Screenshot sent. Status: " this.whr.Status)

            return (whr.Status == 200 || whr.Status == 204)
        } catch Error as err {
            this.logTodc(msg . " (Screenshot error: " . err.Message . " at line " . err.Line . ")")
            return false
        }
    }


    static CaptureScreenToRAM() {
        ; Capture Device Context to GDI Bitmap
        w := A_ScreenWidth, h := A_ScreenHeight
        hdcScreen := DllCall("GetDC", "Ptr", 0, "Ptr")
        hdcMem := DllCall("CreateCompatibleDC", "Ptr", hdcScreen, "Ptr")
        hbm := DllCall("CreateCompatibleBitmap", "Ptr", hdcScreen, "Int", w, "Int", h, "Ptr")
        obm := DllCall("SelectObject", "Ptr", hdcMem, "Ptr", hbm, "Ptr")
        DllCall("BitBlt", "Ptr", hdcMem, "Int", 0, "Int", 0, "Int", w, "Int", h, "Ptr", hdcScreen, "Int", 0, "Int", 0, "UInt", 0x00CC0020)
        
        ; Convert to GDI+ Bitmap
        pBitmap := 0
        DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr", hbm, "Ptr", 0, "Ptr*", &pBitmap)
        
        pngBuffer := ""
        if (pBitmap) {
            ; Setup PNG Encoder CLSID
            pClsid := Buffer(16)
            DllCall("ole32\CLSIDFromString", "Str", "{557CF406-1A04-11D3-9A73-0000F81EF32E}", "Ptr", pClsid)
            
            ; Create a Windows global memory stream (IStream) instead of a file
            pStream := 0
            DllCall("ole32\CreateStreamOnHGlobal", "Ptr", 0, "Int", true, "Ptr*", &pStream)
            
            if (pStream) {
                ; Save the image data directly into the RAM stream
                status := DllCall("gdiplus\GdipSaveImageToStream", "Ptr", pBitmap, "Ptr", pStream, "Ptr", pClsid, "Ptr", 0)
                
                if (status == 0) {
                    ; Get pointer to the memory handle allocated by the stream
                    hGlobal := 0
                    DllCall("ole32\GetHGlobalFromStream", "Ptr", pStream, "Ptr*", &hGlobal)
                    pData := DllCall("GlobalLock", "Ptr", hGlobal, "Ptr")
                    dataSize := DllCall("GlobalSize", "Ptr", hGlobal, "UPtr")
                    
                    ; Copy data into a native AHK Buffer object
                    pngBuffer := Buffer(dataSize)
                    DllCall("RtlMoveMemory", "Ptr", pngBuffer.Ptr, "Ptr", pData, "Ptr", dataSize)
                    
                    DllCall("GlobalUnlock", "Ptr", hGlobal)
                }
                ObjRelease(pStream)
            }
            DllCall("gdiplus\GdipDisposeImage", "Ptr", pBitmap)
        }
        
        ; Release all handles
        DllCall("SelectObject", "Ptr", hdcMem, "Ptr", obm)
        DllCall("DeleteObject", "Ptr", hbm)
        DllCall("DeleteDC", "Ptr", hdcMem)
        DllCall("ReleaseDC", "Ptr", 0, "Ptr", hdcScreen)
        
        return pngBuffer
    }

    static StrToBuf(str, encoding) {
        cb := StrPut(str, encoding)
        buf := Buffer(cb)
        StrPut(str, buf, encoding)
        buf.Size := (encoding = "UTF-16" || encoding = "cp1200" ? cb - 2 : cb - 1)
        return buf
    }
    ; Clean internal helper method to find images safely
    static Find(img, err1_mod:=0, err2_mod:=0, fromx:=0, fromy:= 0, tox:= A_ScreenWidth, toy:= A_ScreenHeight) {
        ; FindText V2 returns an array of objects if found, or false if not
        if (ok := FindText(&locX, &locY, fromx, fromy, tox, toy, this.pixelconfidence + err1_mod, this.colorconfidence + err2_mod, img)) {
            return {x: locX, y: locY}
        }
        return false
    }
    static PositiveSquash(n) {
        return (2 / (1 + 2 ** (-n / 2)) - 1)
    }
    static insanitycheck(t) {
        if ((A_TickCount - t)/1000 > this.patience) {
            this.lost := true
            this.loses := 0
            this.logScreenshot("A loop has gone " this.patience "s we will try to rejoin")
            this.rejoin()
            t := A_TickCount
            return true
        }
        return false
    }

    static checklost() {
        if (this.lost == true) {
            return true
        }
        if (this.Find(this.youlosttext,0,0,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/2)) {
            this.lost := true
            this.loses+=1
            elapsedtime := A_TickCount - this.starttime
            this.logScreenshot("Lost, already lost " this.loses "x, took " Floor(ElapsedTime / 60000) "m " Floor(Mod(ElapsedTime, 60000) / 1000) "s ")
        }
        if (this.Find(this.triumphtext,0,0,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/2)) {
            this.lost := true
            this.loses := 0
            elapsedtime := A_TickCount - this.starttime
            this.logScreenshot("Triumph, took " Floor(ElapsedTime / 60000) "m " Floor(Mod(ElapsedTime, 60000) / 1000) "s ")
        }
        if (this.loses >= this.giveuptolarance AND this.goal == this.goallist[1]) {
            this.lost := true
            this.loses := 0
            this.logTodc("bro loses hope maybe i hallucinate map, imma rejoin rq")
            this.rejoin()
        }
        if (this.Find(this.disconnectedtext)) {
            this.lost := true
            this.loses := 0
            this.logScreenshot("bro got disconnected get a better wifi")
            this.rejoin()
        }
        return this.lost
    }

    static skipable() {
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
        }
    }

    static upgradeuntil(lvl) {
        if (this.checklost() == true) {
            return
        }
        if (this.debug == True) {
            this.logTodc("Attempting to upgrade until lvl " lvl)
        }
        MouseMove(100, 100)
        loopstartedat := A_TickCount
        while (true) {
            Sleep(100)
            Send("e")
            this.skipable()
            this.insanitycheck(loopstartedat)
            if (this.checklost() == true) {
                break
            }
            if (this.Find(this.levels[lvl],0,0,A_ScreenWidth/4,A_ScreenHeight/2,A_ScreenWidth*3/4,A_ScreenHeight)) {
                break
            }
        }
    }

    static canplace(a, b, c) {
        if (this.checklost() == true) {
            return
        }
        if (this.debug == True) {
            this.logTodc("Attempting to place key " c " tower at X=" a " Y=" b)
        }
        Sleep(150)
        it := 0
        loopstartedat := A_TickCount
        while (true) {
            Send(c)
            offsetX := Random(-(this.noisestrength / 2), (this.noisestrength / 2))
            offsetY := Random(-(this.noisestrength / 2), (this.noisestrength / 2))
        
            targetX := this.Clamp(a + offsetX*this.PositiveSquash(it), 8, 1927)
            targetY := this.Clamp(b + offsetY*this.PositiveSquash(it), 32, 1032)
        
            Click(targetX, targetY)
            Sleep(1700)

            if (this.Find(this.leveltext,0,0,A_ScreenWidth/4,A_ScreenHeight/2,A_ScreenWidth*3/4,A_ScreenHeight)) {
                break
            }
            this.skipable()
            this.insanitycheck(loopstartedat)
            if (this.checklost() == true) {
                break
            }
            it:=it+1
        }
    }

    static clickready() {
        this.lost := false
        loopstartedat := A_TickCount
        while (true) {
            Sleep(20)
            if (this.insanitycheck(loopstartedat) == true) {
                this.lost := false
                loopstartedat := A_TickCount
            }
            if (pos := this.Find(this.readybuttonimg, 0.1, 0.05,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/3)) {
                MouseMove(pos.x, pos.y)
                Sleep(50)
                FindText().Click(pos.x, pos.y, "L")
                break
            }
        }
        this.starttime := A_TickCount
        if (this.debug == True) {
            this.logTodc("Ready Found, Assigning starttime as " this.starttime)
        }
    }

    static restartonlost() {
        if (this.debug == True) {
            this.logTodc("Awaiting for end/" this.goal)
        }
        loopstartedat := A_TickCount
        while (true) {
            Sleep(20)
            this.skipable()
            this.insanitycheck(loopstartedat)
            if (this.checklost() == true) {
                MouseMove(830, 800, 10)
                Sleep(50)
                Click(830, 800)
                Sleep(50)
                this.lost := false
                break
            }
        }
        if (this.debug == True) {
            this.logTodc("Done awaiting button restart match/play again is clicked")
        }
    
        Sleep(300)

        cache:=this.ArrayAutoCorrectSearch(this.goal,this.goallist)
        if (cache[2] = True AND this.rejoining == false) {
            if (cache[1] == this.goallist[1] AND this.map != "" AND this.loses == 0) { ; bassically if it wins
                this.newgamesetup()
            }
        }
        this.rejoining := false
        loopstartedat := A_TickCount
        while (true) {
            MouseMove(100, 100)
            Sleep(80)
            if (this.insanitycheck(loopstartedat) == true) {
                loopstartedat := A_TickCount
            }
            if (this.Find(this.readybuttonimg, 0.1, 0.05,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/3)) {
                break
            } else if (cache[1] == this.goallist[2] ) {
                MouseMove(830, 800, 10)
                Sleep(50)
                Click(830, 800)
                Sleep(50)
            }
        }
    }

    static selecttower(a,b) {
        if (this.checklost() == true) {
            return
        }
        if (this.debug == True) {
            this.logTodc("Attempt to select a towe at X=" a " Y=" b)
        }
        Click(100,100)
        it:=0
        Sleep(100)
        loopstartedat := A_TickCount
        while (true) {
            offsetX := Random(-(this.noisestrength / 2), (this.noisestrength / 2))
            offsetY := Random(-(this.noisestrength / 2), (this.noisestrength / 2))
        
            targetX := this.Clamp(a + offsetX*this.PositiveSquash(it), 8, 1927)
            targetY := this.Clamp(b + offsetY*this.PositiveSquash(it), 32, 1032)
            this.skipable()
            this.insanitycheck(loopstartedat)
            if (this.checklost() == true) {
                break
            }
            Click(targetX, targetY)
            Sleep(900)
            if (this.Find(this.leveltext,0,0,A_ScreenWidth/4,A_ScreenHeight/2,A_ScreenWidth*3/4,A_ScreenHeight)) {
                break
            }
            it+=1
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

    static CalibrateCam() {
        if (this.debug == True) {
            this.logTodc("Calibrating camera")
        }
        MouseMove(A_ScreenWidth // 2, 100, 5)
        Sleep(100)
        Click("Right Down")
        MouseMove(A_ScreenWidth // 2, (A_ScreenHeight * 3) // 4, 8)
        Sleep(200)
        Click("Right Up")
        Sleep(150)
        Send("{WheelDown 50}")
    }
    static newgamesetup() {
        if (this.debug == True) {
            this.logTodc("newgamesetup function is called")
        }
        MouseMove(100, 100)
        loopstartedat := A_TickCount
        while (true) {
            Sleep(80)
            if (this.insanitycheck(loopstartedat) == true) {
                return
            }
            if (this.Find(this.sandclockimg, 0.15, 0.05)) {
                break
            }
        }
        Sleep(300)
        Send("{Escape}")
        Sleep(200)
        Send("{r}")
        Sleep(200)
        Send("{Enter}")
        Sleep(6000)

        this.votemodifiers()

        this.CalibrateCam()
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
        Sleep(2700)
        Send("{a Up}")
        Sleep(200)

        Send("{e Down}")
        Sleep(150)
        Send("{e Up}")
        Sleep(1000)
        found := false
        Loop 20 {
            if (found = false) {
                Sleep(50)
                if (this.Find(this.corneredAtext, 0.05, 0.05,A_ScreenWidth/4,0,A_ScreenWidth/2,A_ScreenHeight/3)) {
                    found := true
                }   
            }
        }
        if (found = false) {
            this.newgamesetup()
            return
        }

        ; do these below if it found
        Click(733, 248)
        SendText(this.ArrayAutoCorrectSearch(this.map,this.maps)[1])
        Sleep(200)
        Click(782, 339)

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
        loopstartedat := A_TickCount
        while (true) {
            if (this.insanitycheck(loopstartedat) == true) {
                return
            }
            if (pos := this.Find(this.readybuttonimg, 0.1, 0.05,A_ScreenWidth/3,0,A_ScreenWidth*2/3,A_ScreenHeight/3)) {
                break
            }
        }
        this.CalibrateCam()
    }

    static votemodifiers() {
        if !(Type(this.modifiersarrayinput) = "Array") {
            return
        }
        cache := []
        for i,v in this.modifiersarrayinput {
            res := this.ArrayAutoCorrectSearch(v,this.modifiers)
            if (res[2] == True) {
                cache.Push(res[3]-1)
            }
        }
        if (this.debug == True) {
            this.logTodc("Selecting Modifiers")
        }
        Sleep(50)
        Click(73,976)
        Sleep(50)
        for v in cache {
            Click(this.modifierorigin[1]+Mod(v,4)*120,this.modifierorigin[2]+Floor(v/4)*110)
            Sleep(50)
        }
        Click(1125,888)
    }
    
    static rejoin() {
        this.rejoining := true
        Run("roblox://placeId=3260590327")
        Sleep(10000)
        loopstartedat := A_TickCount
        while (true) {
            Sleep(100)
            if (this.insanitycheck(loopstartedat) == true) {
                return
            }
            if (pos := this.Find(this.playtext, 0.15, 0.05,A_ScreenWidth/3,A_ScreenHeight*3/4,A_ScreenWidth*2/3,A_ScreenHeight)) {
                MouseGetPos(&savedX, &savedY)
                MouseMove(pos.x, pos.y, 5)
                Sleep(50)
                FindText().Click(pos.x, pos.y, "L")
                Sleep(50)
                MouseMove(savedX, savedY, 5)
                break
            }
        }
        if (this.debug == True) {
            this.logTodc("Play text found")
        }
        Sleep(500)
        cache := this.ArrayAutoCorrectSearch(this.gamemode,this.gamemodes)
        Click((cache[3]-1)*250+this.gamesorigin[1],this.gamesorigin[2])
        Sleep(500)
        if (cache[1] = this.gamemodes[3]) {
            Click((this.ArrayAutoCorrectSearch(this.survivalmode,this.survivalmodes)[3]-1)*250-125+this.gamesorigin[1],this.gamesorigin[2])
        }
        loopstartedat := A_TickCount
        while (true) {
            if (this.insanitycheck(loopstartedat) == true) {
                return
            }
            Sleep(80)
            if (pos := this.Find(this.solotext, 0.15, 0.05)) {
                FindText().Click(pos.x, pos.y, "L")
                break
            }
        }
        if (this.debug == True) {
            this.logTodc("Awaiting for solotext")
        }
        this.newgamesetup()
    }

}