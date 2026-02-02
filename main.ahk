#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
SetWorkingDir A_ScriptDir

global CFG_PATH := A_ScriptDir "\config.ini"
A_IconTip := "workflow-optimization_ahk (MAIN)"

#Include %A_ScriptDir%\modules\autoclick\module.ahk
#Include %A_ScriptDir%\modules\multitask\module.ahk
#Include %A_ScriptDir%\modules\copypaste\module.ahk
#Include %A_ScriptDir%\modules\stringpaste\module.ahk

global g_Modules := Map(
    "autoclick",   false,
    "multitask",   false,
    "copypaste",   false,
    "stringpaste", false
)

global g_ModMenu := Menu()

InitAll()

InitAll() {
    global CFG_PATH

    if !FileExist(CFG_PATH) {
        MsgBox "Missing config.ini: " CFG_PATH
        ExitApp
    }

    ; init modules (they should register hotkeys Off initially)
    TryCall("AutoClick_Init", CFG_PATH)
    TryCall("MultiTask_Init", CFG_PATH)
    TryCall("CopyPaste_Init", CFG_PATH)
    TryCall("StringPaste_Init", CFG_PATH)

    ; read enabled flags (autoclick default OFF)
    Module_SetEnabled("autoclick",   IniRead(CFG_PATH, "Modules", "autoclick", "0") = "1")
    Module_SetEnabled("multitask",   IniRead(CFG_PATH, "Modules", "multitask", "1") = "1")
    Module_SetEnabled("copypaste",   IniRead(CFG_PATH, "Modules", "copypaste", "1") = "1")
    Module_SetEnabled("stringpaste", IniRead(CFG_PATH, "Modules", "stringpaste", "1") = "1")

    TraySetup()
}

TryCall(fnName, param := "") {
    ; Calls a function if it exists; never crashes the whole script.
    try {
        f := Func(fnName)
        if (param = "")
            f.Call()
        else
            f.Call(param)
    } catch {
        ; ignore missing or failing module init
    }
}

Module_SetEnabled(name, enable) {
    global g_Modules, CFG_PATH
    g_Modules[name] := !!enable

    ; call module toggle hooks only if they exist
    switch name {
        case "autoclick":   TryCall("AutoClick_SetEnabled", enable)
        case "multitask":   TryCall("MultiTask_SetEnabled", enable)
        case "copypaste":   TryCall("CopyPaste_SetEnabled", enable)
        case "stringpaste": TryCall("StringPaste_SetEnabled", enable)
    }

    IniWrite(enable ? "1" : "0", CFG_PATH, "Modules", name)
    TraySetup()
}

TryCall(fnName, param) {
    try {
        Func(fnName).Call(param)
    } catch {
        ; ignore
    }
}

TraySetup() {
    global g_Modules, CFG_PATH, g_ModMenu

    A_TrayMenu.Delete()

    ; Debug proves you're running the correct file
    A_TrayMenu.Add("Debug: show script path", (*) => MsgBox(A_ScriptFullPath))

    g_ModMenu.Delete()
    g_ModMenu.Add("AutoClick",   (*) => Module_SetEnabled("autoclick",   !g_Modules["autoclick"]))
    g_ModMenu.Add("MultiTask",   (*) => Module_SetEnabled("multitask",   !g_Modules["multitask"]))
    g_ModMenu.Add("CopyPaste",   (*) => Module_SetEnabled("copypaste",   !g_Modules["copypaste"]))
    g_ModMenu.Add("StringPaste", (*) => Module_SetEnabled("stringpaste", !g_Modules["stringpaste"]))

    if (g_Modules["autoclick"])   g_ModMenu.Check("AutoClick")
    if (g_Modules["multitask"])   g_ModMenu.Check("MultiTask")
    if (g_Modules["copypaste"])   g_ModMenu.Check("CopyPaste")
    if (g_Modules["stringpaste"]) g_ModMenu.Check("StringPaste")

    A_TrayMenu.Add("Modules", g_ModMenu)
    A_TrayMenu.Add()

    A_TrayMenu.Add("Open config.ini", (*) => Run('notepad.exe "' CFG_PATH '"'))
    A_TrayMenu.Add("Reload", (*) => Reload())
    A_TrayMenu.Add("Exit", (*) => ExitApp())
}
