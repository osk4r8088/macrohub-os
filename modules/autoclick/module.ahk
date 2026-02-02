#Requires AutoHotkey v2.0

global g_AutoClick := { cfg:"", hk:"^XButton1", delay:30, button:"Left", enabled:true }

AutoClick_Init(cfgPath) {
    global g_AutoClick
    g_AutoClick.cfg := cfgPath
    g_AutoClick.hk := IniRead(cfgPath, "AutoClick", "Hotkey", "^XButton1")
    g_AutoClick.delay := Integer(IniRead(cfgPath, "AutoClick", "DelayMs", "30"))
    g_AutoClick.button := IniRead(cfgPath, "AutoClick", "Button", "Left")

    ; Register hotkey once, but default OFF/ON controlled via AutoClick_SetEnabled()
    Hotkey g_AutoClick.hk, (*) => AutoClick_WhileHeld(), "Off"
}

AutoClick_SetEnabled(enable) {
    global g_AutoClick
    g_AutoClick.enabled := !!enable
    Hotkey g_AutoClick.hk, enable ? "On" : "Off"
}

AutoClick_WhileHeld() {
    global g_AutoClick
    ; Determine physical key part for GetKeyState.
    ; For ^XButton1 hotkey, physical trigger is XButton1 (with Ctrl held).
    baseKey := "XButton1"

    while GetKeyState(baseKey, "P") && GetKeyState("Ctrl", "P") {
        Click g_AutoClick.button
        Sleep g_AutoClick.delay
    }
}
