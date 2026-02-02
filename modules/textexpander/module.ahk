#Requires AutoHotkey v2.0

global g_TextExpander := { items: [], enabled: false, inited: false }

TextExpander_Init(cfgPath) {
    global g_TextExpander

    try
        pairs := IniRead(cfgPath, "TextExpander")
    catch
        return

    for line in StrSplit(pairs, "`n", "`r") {
        line := Trim(line)
        if (line = "")
            continue
        eq := InStr(line, "=")
        if (!eq)
            continue
        abbr := Trim(SubStr(line, 1, eq - 1))
        expansion := Trim(SubStr(line, eq + 1))
        if (abbr = "" || expansion = "")
            continue
        g_TextExpander.items.Push({ abbr: abbr, expansion: expansion })
    }
}

TextExpander_SetEnabled(enable) {
    global g_TextExpander
    g_TextExpander.enabled := !!enable

    ; register hotstrings on first enable (can't unregister, so only do once)
    if (enable && !g_TextExpander.inited) {
        g_TextExpander.inited := true
        for item in g_TextExpander.items {
            Hotstring ":*:" item.abbr, TextExpander_Send.Bind(item.expansion)
        }
    }
}

TextExpander_Send(text, *) {
    global g_TextExpander
    if !g_TextExpander.enabled
        return
    SendText text
}
