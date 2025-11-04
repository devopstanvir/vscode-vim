#Requires AutoHotkey v2.0
#SingleInstance Force
#+r::Reload  ; Edit script
#+e::Edit   ; Edit script
#q::WinClose("A")  ; Closes the active window
CapsLock::Esc ; CapsLock to Escape
; Esc::Return ; Disable Escape
; Esc::CapsLock ; Escape to capslock


; ======================================================
; Universal App Launcher / Focus Switcher
; Press your defined hotkeys to launch or activate apps
; ======================================================

; ---------------------
; Example Hotkeys
; ---------------------
#r::RunOrFocusApp("Comet Browser", "CometBrowser.exe", "C:\Program Files\Comet\CometBrowser.exe")
#e::RunOrFocusApp("Everything", "Everything.exe", "C:\Program Files\Everything\Everything.exe")
#c::RunOrFocusApp("Calculator", "Calculator.exe", "calc.exe")
#n::RunOrFocusApp("Notepad", "Notepad.exe", "notepad.exe")

; ---------------------
; Function Definition
; ---------------------
RunOrFocusApp(winTitle, exeName, exePath)
{
    ; Check if the process is running
    if !ProcessExist(exeName) {
        try {
            Run exePath
        } catch as err {
            MsgBox "Failed to launch " exeName "`nError: " err.Message
        }
        return
    }

    ; Try to find an open window for this process
    win := WinExist("ahk_exe " exeName)

    if win {
        if WinActive("ahk_id " win) {
            ; Optional: toggle minimize if already focused
            WinMinimize("ahk_id " win)
        } else {
            WinActivate("ahk_id " win)
        }
    } else {
        ; If no window found, try running again
        Run exePath
    }
}
