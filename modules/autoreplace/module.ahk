#Requires AutoHotkey v2.0

global g_AutoReplace := { items: [], enabled: false, inited: false }

AutoReplace_Init(cfgPath) {
    global g_AutoReplace

    try
        pairs := IniRead(cfgPath, "AutoReplace")
    catch
        return

    for line in StrSplit(pairs, "`n", "`r") {
        line := Trim(line)
        if (line = "")
            continue
        eq := InStr(line, "=")
        if (!eq)
            continue
        typo := Trim(SubStr(line, 1, eq - 1))
        correction := Trim(SubStr(line, eq + 1))
        if (typo = "" || correction = "")
            continue
        g_AutoReplace.items.Push({ typo: typo, correction: correction })
    }
}

AutoReplace_SetEnabled(enable) {
    global g_AutoReplace
    g_AutoReplace.enabled := !!enable

    ; register hotstrings on first enable
    if (enable && !g_AutoReplace.inited) {
        g_AutoReplace.inited := true
        for item in g_AutoReplace.items {
            Hotstring ":C:" item.typo, AutoReplace_Send.Bind(item.correction)
        }
    }
}

AutoReplace_Send(text, *) {
    global g_AutoReplace
    if !g_AutoReplace.enabled
        return
    SendText text
}
