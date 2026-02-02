#Requires AutoHotkey v2.0

global g_AutoClick := { cfg:"", delay:30, button:"Left", enabled:true }

AutoClick_Init(cfgPath) {
    global g_AutoClick
    g_AutoClick.cfg := cfgPath
    g_AutoClick.delay := Integer(IniRead(cfgPath, "AutoClick", "DelayMs", "30"))
    g_AutoClick.button := IniRead(cfgPath, "AutoClick", "Button", "Left")

    ; Trigger: Ctrl + LButton (hold)
    ; Register OFF initially; enabled via AutoClick_SetEnabled()
    Hotkey "^LButton", AutoClick_Handler, "Off"
}

AutoClick_SetEnabled(enable) {
    Hotkey "^LButton", enable ? "On" : "Off"
}

AutoClick_Handler(*) {
    global g_AutoClick
    ; While Ctrl and LButton are physically held, keep clicking
    while GetKeyState("Ctrl", "P") && GetKeyState("LButton", "P") {
        Click g_AutoClick.button
        Sleep g_AutoClick.delay
    }
}
