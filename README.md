Collection of AutoHotkey scripts I use for workflow optimization, temporary problem solving, or just for simple keybind macros or misc.

Features (modules) can be toggled in the system tray submenu

Created with AutoHotKey V2, keep in mind that the syntax is different to the original version (V1 installation will not be able to run the scripts)

# Keybinds:

| Hotkey                 | Action                      | Module    |
| ---------------------- | --------------------------- | --------- |
| XButton1 (Mouse4)      | Copy (Ctrl + C)             | CopyPaste |
| XButton2 (Mouse5)      | Paste (Ctrl + V)            | CopyPaste |
| Ctrl + XButton1 (hold) | AutoClick (Left click spam) | AutoClick |

| Hotkey           | Action                            | Module      |
| ---------------- | --------------------------------- | ----------- |
| Ctrl + Shift + V | Paste plain text (no formatting)  | MultiTask   |
| Ctrl + Alt + P   | Paste preset text (`StringPaste`) | StringPaste |

| Hotkey   | Output             | Module    |
| -------- | ------------------ | --------- |
| Numpad * | `dd.MM.yyyy HH:mm` | MultiTask |
| Numpad - | `yyyy-MM-dd_HHmm`  | MultiTask |

| Hotkey   | Action           | Module    |
| -------- | ---------------- | --------- |
| Numpad 7 | Launch Edge      | MultiTask |
| Numpad 8 | Launch Notepad++ | MultiTask |
| Numpad 9 | Launch Teams     | MultiTask |
| Numpad + | Launch Outlook   | MultiTask |

| Hotkey    | Action                   | Module    |
| --------- | ------------------------ | --------- |
| F6 (hold) | AutoClick (configurable) | AutoClick |

| Action                       | Description                  |
| ---------------------------- | ---------------------------- |
| Tray → Modules → AutoClick   | Enable / Disable AutoClick   |
| Tray → Modules → MultiTask   | Enable / Disable MultiTask   |
| Tray → Modules → CopyPaste   | Enable / Disable CopyPaste   |
| Tray → Modules → StringPaste | Enable / Disable StringPaste |

All hotkeys and paths can be customized in: config.ini
