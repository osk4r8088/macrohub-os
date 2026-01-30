#Requires AutoHotkey v2.0
#SingleInstance Force

XButton1::
{
    while GetKeyState("XButton1", "P")
    {
        Click
        Sleep 30  ; ~33 clicks/sec (adjust)
    }
}
