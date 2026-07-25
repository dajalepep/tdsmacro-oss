#Requires AutoHotkey v2.0
#SingleInstance Force

; Repo settings
repo := "dajalepep/tdsmacro-oss"
tempZip := A_Temp "\tdsmacro_update.zip"
tempFolder := A_Temp "\tdsmacro_update_files"

; Create GUI
guiUp := Gui("+AlwaysOnTop", "TDSmacro Updater")
guiUp.SetFont("s10", "Segoe UI")

guiUp.AddText(, "Select Branch to Update From:")
radMain := guiUp.AddRadio("Checked", "Main (Stable)")
radSnap := guiUp.AddRadio(, "Snapshots (Testing)")

txtStatus := guiUp.AddText("w300 vStatus", "Status: Ready")
btnUpdate := guiUp.AddButton("w140", "Update Now")

; Button Events
btnUpdate.OnEvent("Click", (*) => DoUpdate())
guiUp.OnEvent("Close", (*) => ExitApp())

guiUp.Show()

; --- Update Logic ---
DoUpdate() {
    branch := radSnap.Value ? "snapshots" : "main"
    zipUrl := "https://github.com/" repo "/archive/refs/heads/" branch ".zip"
    
    btnUpdate.Enabled := false
    
    try {
        txtStatus.Text := "Status: Downloading (" branch ")..."
        
        ; 1. Download zip
        if FileExist(tempZip)
            FileDelete(tempZip)
        Download(zipUrl, tempZip)
        
        txtStatus.Text := "Status: Extracting..."
        if DirExist(tempFolder)
            DirDelete(tempFolder, true)
        DirCreate(tempFolder)
        
        ; 2. Extract zip with PowerShell
        psCmd := "powershell -NoProfile -Command `"Expand-Archive -Path '" tempZip "' -DestinationPath '" tempFolder "' -Force`""
        RunWait(psCmd, , "Hide")
        
        txtStatus.Text := "Status: Copying files..."
        
        ; 3. Get extracted root folder inside zip
        extractDir := tempFolder
        Loop Files, tempFolder "\*", "D" {
            extractDir := A_LoopFilePath
            break
        }
        
        ; 4. Copy files (merges config.ini, skips updater.ahk)
        Loop Files, extractDir "\*.*", "R" {
            relPath := SubStr(A_LoopFilePath, StrLen(extractDir) + 2)
            dest := A_WorkingDir "\" relPath
            
            ; Merge new settings into config.ini without overwriting existing user values
            if (relPath = "config.ini" && FileExist(dest)) {
                MergeConfig(A_LoopFilePath, dest)
                continue
            }
            if (relPath = "updater.ahk" && FileExist(dest))
                continue
                
            SplitPath(dest, , &destDir)
            if !DirExist(destDir)
                DirCreate(destDir)
            FileCopy(A_LoopFilePath, dest, true)
        }
        
        ; 5. Clean up temp files
        if FileExist(tempZip)
            FileDelete(tempZip)
        if DirExist(tempFolder)
            DirDelete(tempFolder, true)
            
        txtStatus.Text := "Status: Update Complete!"
        MsgBox("Successfully updated to '" branch "' branch!", "Updater", 64)

    } catch Error as err {
        txtStatus.Text := "Status: Update Failed!"
        MsgBox("Update failed: " . err.Message, "Error", 16)
    }

    btnUpdate.Enabled := true
}

; --- Smart Config Merger ---
MergeConfig(newConfigPath, localConfigPath) {
    section := "Settings"
    lines := StrSplit(FileRead(newConfigPath), "`n", "`r")
    
    for line in lines {
        line := Trim(line)
        if (line = "" || SubStr(line, 1, 1) = "#" || SubStr(line, 1, 1) = ";")
            continue
            
        ; Track current INI section [SectionName]
        if RegExMatch(line, "^\[(.*)\]$", &mSec) {
            section := mSec[1]
            continue
        }
        
        ; Find Key=Value pairs
        if RegExMatch(line, "^([^=]+)=(.*)$", &mKV) {
            key := Trim(mKV[1])
            val := Trim(mKV[2])
            
            ; If local config doesn't have this key yet, add it!
            if (IniRead(localConfigPath, section, key, "MISSING_SETTING") == "MISSING_SETTING") {
                IniWrite(val, localConfigPath, section, key)
            }
        }
    }
}