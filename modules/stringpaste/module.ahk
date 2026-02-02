#Requires AutoHotkey v2.0

global g_StringPaste := {
    hk: "",
    text: "",
    enabled: false
}

StringPaste_Init(cfgPath) {
    global g_StringPaste

    g_StringPaste.text := IniRead(cfgPath, "StringPaste", "Text", "paste")
    g_StringPaste.hk   := IniRead(cfgPath, "StringPaste", "Hotkey", "^!p")

    ; Register hotkey OFF initially
    Hotkey g_StringPaste.hk, StringPaste_Handler, "Off"
}

StringPaste_SetEnabled(enable) {
    global g_StringPaste
    g_StringPaste.enabled := !!enable
    Hotkey g_StringPaste.hk, enable ? "On" : "Off"
}

StringPaste_Handler(*) {
    global g_StringPaste
    StringPaste_Do(g_StringPaste.text)
}

StringPaste_Do(text) {
    saved := ClipboardAll()
    try {
        A_Clipboard := ""
        A_Clipboard := text
        ClipWait 0.5
        Send "^v"
        Sleep 30
    } finally {
        A_Clipboard := saved
    }
}
