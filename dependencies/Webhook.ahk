class Webhook {
    static webhookUrl := ""
    static debug := false
    static gdiToken := 0
    static whr := ComObject("WinHttp.WinHttpRequest.5.1")
    static netReport:= [0,0,0,0]
    static startSession:=A_TickCount
    static sendScreenshots:=true
    static sendHourlyReports:=true
    static __New() {
        SplitPath(A_LineFile, , &moduleDir)
        if FileExist(A_ScriptDir "\config.ini") {
            iniPath := A_ScriptDir "\config.ini"
        } else if FileExist(moduleDir "\..\config.ini") {
            iniPath := moduleDir "\..\config.ini"
        } else {
            iniPath := A_ScriptDir "\config.ini"
        }
        this.webhookUrl := IniRead(iniPath, "Settings", "DiscordWebhook", "")
        debugVal := IniRead(iniPath, "Settings", "Debug", "false")
        this.debug := (debugVal = "true" || debugVal = "1")
        screenshotVal := IniRead(iniPath, "Settings", "SendScreenshots", "true")
        this.sendScreenshots := (screenshotVal = "true" || screenshotVal = "1")
        reportVal := IniRead(iniPath, "Settings", "SendHourlyReports", "true")
        this.sendHourlyReports := (reportVal = "true" || reportVal = "1")

        si := Buffer(A_PtrSize = 8 ? 24 : 16, 0)
        NumPut("UInt", 1, si)
        DllCall("gdiplus\GdiplusStartup", "Ptr*", &token := 0, "Ptr", si, "Ptr", 0)
        this.gdiToken := token
    }

    static Send(message) {
        if (this.webhookUrl == "") {
            return false
        }
        try {
            payload := '{"content": "' message '"}'
        
            this.whr.Open("POST", this.webhookUrl, true)
            this.whr.SetRequestHeader("Content-Type", "application/json")
            this.whr.Send(payload)
            return true
        } catch {
            return false
        }
    }

    static SendDebugLog(message) {
        if (this.debug == true) {
            this.Send(message)
        }
    }

    static SendHourlyReport(restarts, fails, avgruntime, coins := 0, gems := 0, ratio := 1) {
        if (this.sendHourlyReports==false) {
            return
        }
        if (this.webhookUrl=="") {
            return
        }
        try {
            this.SendDebugLog("Sending Hourly Reports")
        
            this.netReport := [
                this.netReport[1] + restarts,
                this.netReport[2] + fails,
                this.netReport[3] + coins,
                this.netReport[4] + gems
            ]

            coinsRate := Round(coins/ratio)
            gemsRate := Round(gems/ratio)
            utcTime := A_NowUTC
            formattedTimestamp := SubStr(utcTime, 1, 4) . "-" . SubStr(utcTime, 5, 2) . "-" . SubStr(utcTime, 7, 2) . "T" . SubStr(utcTime, 9, 2) . ":" . SubStr(utcTime, 11, 2) . ":" . SubStr(utcTime, 13, 2) . ".000Z"
        
            total := (restarts + fails > 0) ? (restarts + fails) : 1
            winPct  := Round((restarts / total) * 100, 1)
                failPct := Round((fails / total) * 100, 1)

            chartConfig := "{type:'pie',data:{labels:['Success','Fails'],datasets:[{data:[" . winPct . "," . failPct . "],backgroundColor:['#6fcc7b','#FF4F5E']}]},"
                        . "options:{"
                        . "  title:{display:true,text:'Success / Fails Ratio',fontColor:'#FFFFFF'},"
                        . "  legend:{position:'bottom',labels:{fontColor:'#FFFFFF'}},"
                        . "  plugins:{datalabels:{color:'#FFFFFF',formatter:(value)=>value+'%'}}"
                        . "}}"
                        
            encodedConfig := ""
            loop Parse, chartConfig {
                if InStr("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~", A_LoopField)
                    encodedConfig .= A_LoopField
                else
                    encodedConfig .= "%" . Format("{:02X}", Ord(A_LoopField))
            }
            
            chartUrl       := "https://quickchart.io/chart?c=" . encodedConfig
            emojiChart     := Chr(0x1F4CA)
            emojiMoney     := Chr(0x1F4B0)
            emojiGem       := Chr(0x1F48E)
            emojiSpeed     := Chr(0x26A1)
            emojiStopwatch := Chr(0x23F1)

            ; Calculate session duration
            elapsed := A_TickCount - this.startSession
            hours := Floor(elapsed / 1000 / 3600)
            mins  := Mod(Floor(elapsed / 1000 / 60), 60)
            secs  := Mod(Floor(elapsed / 1000), 60)
            sessionStr := hours . "h " . mins . "m " . secs . "s"

            ; Format average run speed from ms to minutes & seconds
            runMins := Floor(avgruntime / 1000 / 60)
            runSecs := Floor(Mod(avgruntime / 1000, 60))
            avgRunStr := runMins . "m " . runSecs . "s"

            ; Build fields list cleanly
            fields := []
            
            ; Use literal backticks safely in strings using double-backticks ``
            fields.Push(Map("name", emojiStopwatch . " Session duration", "value", "``" . sessionStr . "``", "inline", true))
            
            if (this.netReport[3] > 0 || coinsRate > 0) {
                fields.Push(Map("name", emojiMoney . " Coins Gained", "value", "**+" . this.netReport[3] . "**`n*(Rate: " . coinsRate . "/hr)*", "inline", true))
            }
            
            if (this.netReport[4] > 0 || gemsRate > 0) {
                fields.Push(Map("name", emojiGem . " Gems Gained", "value", "**+" . this.netReport[4] . "**`n*(Rate: " . gemsRate . "/hr)*", "inline", true))
            }
            
            fields.Push(Map("name", emojiSpeed . " Avg Run Speed", "value", "``" . avgRunStr . "``", "inline", true))
            
            ; Construct Discord Embed Structure
            embed := Map(
                "title", emojiChart . " TDS Macro Hourly Report - V1.3.1 Snapshots",
                "description", "Hourly summary of tdsmacro-oss (Irregular macro)",
                "color", 16777215,
                "fields", fields,
                "image", Map("url", chartUrl),
                "timestamp", formattedTimestamp
            )
            
            payload := Map("embeds", [embed])
            payloadJson := this.SimpleJSONify(payload)

            try {
                whr := ComObject("WinHttp.WinHttpRequest.5.1")
                whr.Open("POST", this.webhookUrl, false)
                whr.SetRequestHeader("Content-Type", "application/json; charset=UTF-8")
                whr.Send(this.StringToUTF8(payloadJson))
            } catch as err {
                this.SendDebugLog("Failed to send webhook report: " . err.Message)
            }
        }
    }

    ; Safe JSON Stringifier helper to avoid syntax & escaping issues
    static SimpleJSONify(obj) {
        if Type(obj) = "Map" {
            str := "{"
            for k, v in obj {
                str .= '"' . k . '":' . this.SimpleJSONify(v) . ','
            }
            return RTrim(str, ",") . "}"
        } else if Type(obj) = "Array" {
            str := "["
            for v in obj {
                str .= this.SimpleJSONify(v) . ','
            }
            return RTrim(str, ",") . "]"
        } else if Type(obj) = "String" {
            ; Clean up newlines and quotes for valid JSON
            escaped := StrReplace(obj, "\", "\\")
            escaped := StrReplace(escaped, '"', '\"')
            escaped := StrReplace(escaped, "`n", "\n")
            escaped := StrReplace(escaped, "`r", "")
            return '"' . escaped . '"'
        } else if IsNumber(obj) {
            return obj
        } else if Type(obj) = "Boolean" {
            return obj ? "true" : "false"
        }
        return '""'
    }

    static StringToUTF8(str) {
        stream := ComObject("ADODB.Stream")
        stream.Type := 2 ; adTypeText
        stream.Charset := "utf-8"
        stream.Open()
        stream.WriteText(str)
        stream.Position := 0
        stream.Type := 1 ; adTypeBinary
        stream.Position := 3 ; Skip UTF-8 BOM
        return stream.Read()
    }

    static SendScreenshot(message := "") {
        if (this.webhookUrl == "") {
            return false
        }
        
        if (this.sendScreenshots==false) {
            this.Send(message)
            return false
        }

        this.SendDebugLog("Capturing screenshot...")

        try {
            pngBuffer := this.CaptureScreenToRAM()
            if (!pngBuffer || pngBuffer.Size == 0) {
                this.Send(message . " (Failed to capture screenshot - buffer empty)")
                return false
            }

            if (this.debug)
                this.Send("Screenshot captured, size: " pngBuffer.Size " bytes. Preparing to send...")

            boundary := "----AHKWebhookBoundary" . A_TickCount
            
            ; Build HTTP multipart frames
            header := ""
            if (message != "") {
                header .= "--" boundary "`r`n"
                header .= 'Content-Disposition: form-data; name="content"' "`r`n`r`n"
                header .= message "`r`n"
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
            
            this.SendDebugLog("Sending img...")

            whr.Send(SafeArr)

            Webhook.SendDebugLog("it worked yipee Screenshot sent tho. Status: " this.whr.Status "Check  your walls")

            return (whr.Status == 200 || whr.Status == 204)
        } catch Error as err {
            Webhook.Send(message . " (Screenshot error: " . err.Message . " at line " . err.Line . ")")
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
}