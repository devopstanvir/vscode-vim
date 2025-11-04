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

    ; Get all windows for this process
    winList := []
    WinGetList("ahk_exe " exeName, &winList)

    if winList.Length = 0 {
        ; If no window found, try running again
        Run exePath
        return
    }

    ; Find the currently active window in the list
    activeWin := WinActive("ahk_exe " exeName)
    idx := winList.IndexOf(activeWin)

    ; Cycle to next window (wrap around)
    nextIdx := idx ? (idx + 1) : 1
    if nextIdx > winList.Length
        nextIdx := 1

    WinActivate("ahk_id " winList[nextIdx])
}
