#Requires AutoHotkey v2.0

global g_MediaKeysHK := []

MediaKeys_Init(cfgPath) {
    global g_MediaKeysHK

    hkPlay := IniRead(cfgPath, "MediaKeys", "PlayPause", "Numpad0")
    hkNext := IniRead(cfgPath, "MediaKeys", "Next",      "Numpad6")
    hkPrev := IniRead(cfgPath, "MediaKeys", "Prev",      "Numpad4")
    hkVolUp := IniRead(cfgPath, "MediaKeys", "VolUp",    "Numpad2")
    hkVolDn := IniRead(cfgPath, "MediaKeys", "VolDown",  "Numpad5")
    hkMute := IniRead(cfgPath, "MediaKeys", "Mute",      "Numpad1")

    MediaKeys_Register(hkPlay, (*) => Send("{Media_Play_Pause}"))
    MediaKeys_Register(hkNext, (*) => Send("{Media_Next}"))
    MediaKeys_Register(hkPrev, (*) => Send("{Media_Prev}"))
    MediaKeys_Register(hkVolUp, (*) => Send("{Volume_Up}"))
    MediaKeys_Register(hkVolDn, (*) => Send("{Volume_Down}"))
    MediaKeys_Register(hkMute, (*) => Send("{Volume_Mute}"))
}

MediaKeys_Register(hk, fn) {
    global g_MediaKeysHK
    hk := Trim(hk)
    if (hk = "")
        return
    try {
        Hotkey hk, fn, "Off"
        g_MediaKeysHK.Push(hk)
    } catch as e {
        TrayTip "MediaKeys: failed to bind " hk
    }
}

MediaKeys_SetEnabled(enable) {
    global g_MediaKeysHK
    state := enable ? "On" : "Off"
    for hk in g_MediaKeysHK {
        try Hotkey hk, state
    }
}
