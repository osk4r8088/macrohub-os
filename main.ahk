#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetWorkingDir A_ScriptDir

#Include %A_ScriptDir%\modules\autoclick\module.ahk
#Include %A_ScriptDir%\modules\copypaste\module.ahk
#Include %A_ScriptDir%\modules\multitask\module.ahk
#Include %A_ScriptDir%\modules\stringpaste\module.ahk
#Include %A_ScriptDir%\modules\textexpander\module.ahk
#Include %A_ScriptDir%\modules\mediakeys\module.ahk
#Include %A_ScriptDir%\modules\autoreplace\module.ahk

global CFG_PATH := A_ScriptDir "\config.ini"
A_IconTip := "workflow-optimization_ahk"

global g_Modules := Map(
    "autoclick",   false,
    "multitask",   false,
    "copypaste",   false,
    "stringpaste",  false,
    "textexpander", false,
    "mediakeys",    false,
    "autoreplace",  false
)

; module display names mapped to internal names
global g_ModNames := Map(
    "autoclick",   "AutoClick",
    "multitask",   "MultiTask",
    "copypaste",   "CopyPaste",
    "stringpaste",  "StringPaste",
    "textexpander", "TextExpander",
    "mediakeys",    "MediaKeys",
    "autoreplace",  "AutoReplace"
)

global g_ModMenu := Menu()

InitAll()

InitAll() {
    global CFG_PATH, g_Modules

    if !FileExist(CFG_PATH) {
        MsgBox "Missing config.ini: " CFG_PATH
        ExitApp
    }

    ; init modules (hotkeys registered OFF)
    AutoClick_Init(CFG_PATH)
    CopyPaste_Init(CFG_PATH)
    MultiTask_Init(CFG_PATH)
    StringPaste_Init(CFG_PATH)
    TextExpander_Init(CFG_PATH)
    MediaKeys_Init(CFG_PATH)
    AutoReplace_Init(CFG_PATH)

    ; read enabled flags from config and apply
    g_Modules["autoclick"]   := IniRead(CFG_PATH, "Modules", "autoclick", "0") = "1"
    g_Modules["multitask"]   := IniRead(CFG_PATH, "Modules", "multitask", "1") = "1"
    g_Modules["copypaste"]   := IniRead(CFG_PATH, "Modules", "copypaste", "1") = "1"
    g_Modules["stringpaste"]  := IniRead(CFG_PATH, "Modules", "stringpaste", "1") = "1"
    g_Modules["textexpander"] := IniRead(CFG_PATH, "Modules", "textexpander", "0") = "1"
    g_Modules["mediakeys"]    := IniRead(CFG_PATH, "Modules", "mediakeys", "0") = "1"
    g_Modules["autoreplace"]  := IniRead(CFG_PATH, "Modules", "autoreplace", "0") = "1"

    ; apply enabled states
    AutoClick_SetEnabled(g_Modules["autoclick"])
    CopyPaste_SetEnabled(g_Modules["copypaste"])
    MultiTask_SetEnabled(g_Modules["multitask"])
    StringPaste_SetEnabled(g_Modules["stringpaste"])
    TextExpander_SetEnabled(g_Modules["textexpander"])
    MediaKeys_SetEnabled(g_Modules["mediakeys"])
    AutoReplace_SetEnabled(g_Modules["autoreplace"])

    TrayBuild()
}

Module_SetEnabled(name, enable) {
    global g_Modules, g_ModMenu, g_ModNames, CFG_PATH
    g_Modules[name] := !!enable

    switch name {
        case "autoclick":   AutoClick_SetEnabled(enable)
        case "copypaste":   CopyPaste_SetEnabled(enable)
        case "multitask":   MultiTask_SetEnabled(enable)
        case "stringpaste":  StringPaste_SetEnabled(enable)
        case "textexpander": TextExpander_SetEnabled(enable)
        case "mediakeys":    MediaKeys_SetEnabled(enable)
        case "autoreplace":  AutoReplace_SetEnabled(enable)
    }

    IniWrite(enable ? "1" : "0", CFG_PATH, "Modules", name)

    ; update checkmark
    label := g_ModNames[name]
    if enable
        g_ModMenu.Check(label)
    else
        g_ModMenu.Uncheck(label)

    ; notify
    state := enable ? "ON" : "OFF"
    TrayTip label " " state, "workflow-optimization_ahk", 1
}

; build tray menu once
TrayBuild() {
    global g_Modules, g_ModMenu, CFG_PATH

    ; build modules submenu
    g_ModMenu.Add("AutoClick",   (*) => Module_SetEnabled("autoclick",   !g_Modules["autoclick"]))
    g_ModMenu.Add("MultiTask",   (*) => Module_SetEnabled("multitask",   !g_Modules["multitask"]))
    g_ModMenu.Add("CopyPaste",   (*) => Module_SetEnabled("copypaste",   !g_Modules["copypaste"]))
    g_ModMenu.Add("StringPaste",  (*) => Module_SetEnabled("stringpaste",  !g_Modules["stringpaste"]))
    g_ModMenu.Add("TextExpander", (*) => Module_SetEnabled("textexpander", !g_Modules["textexpander"]))
    g_ModMenu.Add("MediaKeys",    (*) => Module_SetEnabled("mediakeys",    !g_Modules["mediakeys"]))
    g_ModMenu.Add("AutoReplace",  (*) => Module_SetEnabled("autoreplace",  !g_Modules["autoreplace"]))

    ; set initial checkmarks
    if g_Modules["autoclick"]
        g_ModMenu.Check("AutoClick")
    if g_Modules["multitask"]
        g_ModMenu.Check("MultiTask")
    if g_Modules["copypaste"]
        g_ModMenu.Check("CopyPaste")
    if g_Modules["stringpaste"]
        g_ModMenu.Check("StringPaste")
    if g_Modules["textexpander"]
        g_ModMenu.Check("TextExpander")
    if g_Modules["mediakeys"]
        g_ModMenu.Check("MediaKeys")
    if g_Modules["autoreplace"]
        g_ModMenu.Check("AutoReplace")

    ; build tray
    A_TrayMenu.Add("Modules", g_ModMenu)
    A_TrayMenu.Add()
    A_TrayMenu.Add("Open config.ini", (*) => Run('notepad.exe "' CFG_PATH '"'))
    A_TrayMenu.Add("Reload", (*) => Reload())
    A_TrayMenu.Add("Exit", (*) => ExitApp())
}
