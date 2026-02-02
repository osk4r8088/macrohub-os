#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn

; -------------------------
; Settings / paths
; -------------------------
global g_ConfigPath := A_ScriptDir "\config.ini"
global g_ModDir := A_ScriptDir "\modules"

; Load modules
#Include %A_ScriptDir%\modules\control_panel.ahk
#Include %A_ScriptDir%\modules\launcher.ahk
#Include %A_ScriptDir%\modules\clipboard.ahk

; -------------------------
; Helpers
; -------------------------
IniReadDef(section, key, default := "") {
    global g_ConfigPath
    try return IniRead(g_ConfigPath, section, key, default)
    catch return default
}

BindHotkey(hk, fn) {
    if (hk = "")
        return
    try Hotkey(hk, fn, "On")
    catch as e {
        MsgBox "Failed to bind hotkey: " hk "`n`n" e.Message, "AHK Suite", "Icon!"
    }
}

; -------------------------
; Init
; -------------------------
if !FileExist(g_ConfigPath) {
    MsgBox "Missing config.ini at:`n" g_ConfigPath "`nCreate it first.", "AHK Suite", "Icon!"
    ExitApp
}

; Init module state
Clipboard_Init()

; Tray menu
A_TrayMenu.Delete()
A_TrayMenu.Add("Open Launcher", (*) => Launcher_Show())
A_TrayMenu.Add("Clipboard History", (*) => Clipboard_ShowMenu())
A_TrayMenu.Add("System Control Panel", (*) => ControlPanel_ShowMenu())
A_TrayMenu.Add()
A_TrayMenu.Add("Reload", (*) => Reload())
A_TrayMenu.Add("Exit", (*) => ExitApp())

; Hotkeys from config
hkLauncher := IniReadDef("Hotkeys", "Launcher", "#Space")
hkControl  := IniReadDef("Hotkeys", "ControlPanel", "#^A")
hkClipHist := IniReadDef("Hotkeys", "ClipboardHistory", "^+V")
hkPlain    := IniReadDef("Hotkeys", "PastePlain", "^+!V")

BindHotkey(hkLauncher, (*) => Launcher_Show())
BindHotkey(hkControl,  (*) => ControlPanel_ShowMenu())
BindHotkey(hkClipHist, (*) => Clipboard_ShowMenu())
BindHotkey(hkPlain,    (*) => Clipboard_PastePlain())

; Optional: show a small tooltip on start
ToolTip "AHK Suite loaded`n" hkLauncher " launcher`n" hkControl " admin menu`n" hkClipHist " clipboard", 20, 20
SetTimer (*) => ToolTip(), -1200
