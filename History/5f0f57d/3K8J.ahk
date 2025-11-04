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

#r::RunOrFocusApp("CometBrowser.exe", "C:\Program Files\Comet\CometBrowser.exe")
#e::RunOrFocusApp("Everything.exe", "C:\Program Files\Everything\Everything.exe")
#c::RunOrFocusApp("Calculator.exe", "calc.exe")
#n::RunOrFocusApp("Notepad.exe", "notepad.exe")

global lastWinIdx := Map() ; Stores last window index for each exe

RunOrFocusApp(exeName, exePath) {
    if !ProcessExist(exeName) {
        try {
            Run exePath
        } catch as err {
            MsgBox "Failed to launch " exeName "`nError: " err.Message
        }
        lastWinIdx[exeName] := 1
        return
    }
    winList := []
    WinGetList("ahk_exe " exeName, &winList)
    if winList.Length = 0 {
        Run exePath
        lastWinIdx[exeName] := 1
        return
    }
    idx := lastWinIdx.Has(exeName) ? lastWinIdx[exeName] : 1
    idx := idx + 1
    if idx > winList.Length
        idx := 1
    WinActivate("ahk_id " winList[idx])
    lastWinIdx[exeName] := idx
}