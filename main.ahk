#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
SetWorkingDir A_ScriptDir

global CFG_PATH := A_ScriptDir "\config.ini"

; --- include modules ---
#Include %A_ScriptDir%\modules\autoclick\module.ahk
#Include %A_ScriptDir%\modules\multitask\module.ahk
#Include %A_ScriptDir%\modules\copypaste\module.ahk
#Include %A_ScriptDir%\modules\stringpaste\module.ahk

; --- init enabled modules ---
InitAll()

InitAll() {
    if !FileExist(CFG_PATH) {
        MsgBox "Missing config.ini: " CFG_PATH
        ExitApp
    }

    ; Simple toggle via [Modules] section (1/0)
    if (IniRead(CFG_PATH, "Modules", "autoclick", "1") = "1")
        AutoClick_Init(CFG_PATH)

    if (IniRead(CFG_PATH, "Modules", "multitask", "1") = "1")
        MultiTask_Init(CFG_PATH)

    if (IniRead(CFG_PATH, "Modules", "copypaste", "1") = "1")
        CopyPaste_Init(CFG_PATH)

    if (IniRead(CFG_PATH, "Modules", "stringpaste", "1") = "1")
        StringPaste_Init(CFG_PATH)

    TraySetup()
}

TraySetup() {
    A_TrayMenu.Delete()
    A_TrayMenu.Add("Reload", (*) => Reload())
    A_TrayMenu.Add("Open config.ini", (*) => Run('notepad.exe "' CFG_PATH '"'))
    A_TrayMenu.Add()
    A_TrayMenu.Add("Exit", (*) => ExitApp())
}
