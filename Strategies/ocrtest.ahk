#Requires AutoHotkey v2.0
#Include %A_ScriptDir%\..\dependencies\TDSmacro.ahk
CoordMode("Mouse", "Window")

OCR.DisplayImage := 1

F1:: {
    X1 := 1030
    Y1 := 630
    start := A_TickCount
    result := TDSmacro.OcrWindowRead(X1,Y1,1180,845,2)
    ; Split text by spaces OR newlines to catch words cleanly
    tablefromresult := StrSplit(RegExReplace(result.Text, "`r`n", " "), " ")
    
    price := ""
    twopath := False
    
    ; 1. First, check if "UPGRADES" or your 2path indicator is present anywhere in the full text
    if (InStr(result.Text, "UPGRADES")) {
        ; Adjust this logic if "UPGRADES" is what triggers a 2path block
        twopath := True 
    }
    
    ; 2. Loop to find and extract the price digits ONLY from the word containing "$"
    for i, v in tablefromresult {
        if (InStr(v, "$")) {
            ; Pull digits out of 'v' (the price word), NOT the entire 'result.Text'
            price := RegExReplace(v, "[^\d]")
            break ; Stop looking once we found the price word
        }
    }
    
    ; 3. Handle the Tooltips correctly based on states
    if (twopath == True) {
        ToolTip "Its 2path bro 😭 Time: " A_TickCount-start
    } else if (price == "") {
        ToolTip "nothing was found son Time: " A_TickCount-start
    } else {
        ToolTip "Price: " price " Time: " A_TickCount-start
    }
    
    SetTimer () => ToolTip(), -3000
}

F4:: {
    X1 := 666
    Y1 := 800-20
    start := A_TickCount
    result := TDSmacro.OcrWindowRead(X1,Y1,755,800,2)
    
    ; Split text by spaces OR newlines to catch words cleanly
    level := -1
    pos:=InStr(result.Text, "Level:")
    try {
        if !(pos=0) {
            cache := SubStr(result.Text,pos+7,1)
            if (cache="O") {
                cache:=0
            }
            if (cache="I") {
                cache:=1
            }
            if (cache="S") {
                cache:=5
            }
            level:= (RegExReplace(cache, "[^\d]")="") ? -1 : Number(RegExReplace(cache, "[^\d]"))
        }
    }
    
    if (level=-1) {
        ToolTip "nothing here " A_TickCount - start " ms"
    } else {
        ToolTip level "Time:" A_TickCount - start " ms"
    }
    
    SetTimer () => ToolTip(), -3000
}

F5:: {
    MouseGetPos(&mx,&my)
    timebefor := A_TickCount
    result := TDSmacro.OcrWindowRead(mx+5,my-85,mx+245,my-60)
    
    if (InStr(result.Text,"Place")==0) {
        ToolTip "nothing here, took" A_TickCount-timebefor " ms"
    } else {
        ToolTip "havent placed yet :/" A_TickCount-timebefor " ms"
    }
    
    SetTimer () => ToolTip(), -3000
}

F6:: {
    X1 := 610
    Y1 := 45
    X2 := 675
    Y2 := 95
    result := TDSmacro.OcrWindowRead(X1,Y1,X2,Y2,2)
    
    if (InStr(result.Text,"Wave:")!=0 && InStr(result.Text,"/")!=0) {
        temparray := []
        for i,v in StrSplit(result.Text," ") {
            try {
                num := Integer(RegExReplace(result.Text, "[^\d]"))
                if (Type(num) == "Integer") {
                    temparray.Push(num)
                }
            }
        }
        if (temparray.Length == 2) {
            ToolTip("Wave " temparray[1] " Out of " temparray[2])
        } else {
            ToolTip("Wave unknown have allat of number bro")
        }
    } else {
        ToolTip(result.Text)
    }

    SetTimer () => ToolTip(), -3000
}

F7::{
    result := TDSmacro.OcrWindowRead(810,245,1110,265)
    if (InStr(result.Text, "Map is already")!=0) {
        ToolTip("rejoin gng")
    }
    if (InStr(result.Text, "Map changed")!=0 || InStr(result.Text, "map per")) {
        ToolTip("change successfull")
    }
}

F2:: {
    X1 := 1210
    Y1 := 930
    result := TDSmacro.OcrWindowRead(X1,Y1,X1+120,Y1+30,2)
    cleanText := RegExReplace(result.Text, "[^\d]")
    
    if (cleanText == "") {
        ToolTip "No numbers found in that region."
    } else {
        A_Clipboard := cleanText
        ToolTip "Found Clean Number: " cleanText
    }
    SetTimer () => ToolTip(), -3000
}

F3:: {
    currentProcess := "ahk_exe " WinGetProcessName("A")
    X_Left := 640
    Y_Left := 530
    W_Left := 360
    H_Left := 150
    
    resultLeft := TDSmacro.OcrWindowRead(X_Left,Y_Left,X_Left+W_Left,Y_Left+H_Left,2)
    coins := 0
    pos:=InStr(resultLeft.Text, " Coins")
    try {
        if !(pos=0) {
            cache:= StrReplace(StrReplace(StrReplace(SubStr(resultLeft.Text,Max(pos-4,1),4), "O", "0"), "I", "1"), "S", "5")
            coins := (RegExReplace(cache, "[^\d]")="") ? -1 : Number(RegExReplace(cache, "[^\d]"))
        }
    }

    xp := 0
    pos:=InStr(resultLeft.Text, " XP")
    try {
        if !(pos=0) {
            cache:= StrReplace(StrReplace(StrReplace(SubStr(resultLeft.Text,Max(pos-4,1),4), "O", "0"), "I", "1"), "S", "5")
            xp := (RegExReplace(cache, "[^\d]")="") ? -1 : Number(RegExReplace(cache, "[^\d]"))
        }
    }
    cleanText := "Coins earned: " coins " XP earned: " xp


    if (cleanText == "") {
        ToolTip "No numbers found in that region."
    } else {
        A_Clipboard := cleanText
        ToolTip "Found Clean Number: " cleanText
    }
}
Esc::ExitApp