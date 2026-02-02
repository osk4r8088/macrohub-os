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

; Track init state so we can enable/disable at runtime
global g_Modules := Map(
    "autoclick",  { on: false },
    "multitask",  { on: false },
    "copypaste",  { on: false },
    "stringpaste",{ on: false }
)

InitAll()

InitAll() {
    if !FileExist(CFG_PATH) {
        MsgBox "Missing config.ini: " CFG_PATH
        ExitApp
    }

    ; Initialize modules once (they register hotkeys but we can turn them on/off)
    AutoClick_Init(CFG_PATH)
    MultiTask_Init(CFG_PATH)
    CopyPaste_Init(CFG_PATH)
    StringPaste_Init(CFG_PATH)

    ; Apply enabled flags from config
    Module_SetEnabled("autoclick",   IniRead(CFG_PATH, "Modules", "autoclick", "1") = "1")
    Module_SetEnabled("multitask",   IniRead(CFG_PATH, "Modules", "multitask", "1") = "1")
    Module_SetEnabled("copypaste",   IniRead(CFG_PATH, "Modules", "copypaste", "1") = "1")
    Module_SetEnabled("stringpaste", IniRead(CFG_PATH, "Modules", "stringpaste", "1") = "1")

    TraySetup()
}

Module_SetEnabled(name, enable) {
    global g_Modules, CFG_PATH
    g_Modules[name].on := !!enable

    ; Call module-specific enable/disable hooks
    switch name {
        case "autoclick":   AutoClick_SetEnabled(enable)
        case "multitask":   MultiTask_SetEnabled(enable)
        case "copypaste":   CopyPaste_SetEnabled(enable)
        case "stringpaste": StringPaste_SetEnabled(enable)
    }

    ; Persist to config.ini
    IniWrite(enable ? "1" : "0", CFG_PATH, "Modules", name)

    ; Refresh tray checkmarks
    TraySetup()
}

TraySetup() {
    global g_Modules, CFG_PATH

    A_TrayMenu.Delete()

    modMenu := Menu()
    modMenu.Add("AutoClick",   (*) => Module_SetEnabled("autoclick",   !g_Modules["autoclick"].on))
    modMenu.Add("MultiTask",   (*) => Module_SetEnabled("multitask",   !g_Modules["multitask"].on))
    modMenu.Add("CopyPaste",   (*) => Module_SetEnabled("copypaste",   !g_Modules["copypaste"].on))
    modMenu.Add("StringPaste", (*) => Module_SetEnabled("stringpaste", !g_Modules["stringpaste"].on))

    ; checkmarks
    if (g_Modules["autoclick"].on)   modMenu.Check("AutoClick")
    if (g_Modules["multitask"].on)   modMenu.Check("MultiTask")
    if (g_Modules["copypaste"].on)   modMenu.Check("CopyPaste")
    if (g_Modules["stringpaste"].on) modMenu.Check("StringPaste")

    A_TrayMenu.Add("Modules", modMenu)
    A_TrayMenu.Add()

    A_TrayMenu.Add("Open config.ini", (*) => Run('notepad.exe "' CFG_PATH '"'))
    A_TrayMenu.Add("Reload", (*) => Reload())
    A_TrayMenu.Add("Exit", (*) => ExitApp())
}
