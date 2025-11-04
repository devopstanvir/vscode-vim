#Requires AutoHotkey v2.0
#SingleInstance Force
#+r::Reload  ; Edit script
#+e::Edit   ; Edit script
#q::WinClose("A")  ; Closes the active window
CapsLock::Esc ; CapsLock to Escape
; Esc::Return ; Disable Escape
; Esc::CapsLock ; Escape to capslock


; =====================================================
; Enhanced RunOrFocus App Launcher Script
; AutoHotkey v2.0
; =====================================================

; ---------------------
; Hotkey Definitions
; ---------------------

#n::RunOrFocusApp("Notepad", "Notepad.exe", "notepad.exe")

; Additional useful hotkeys
#v::RunOrFocusApp("Visual Studio Code", "Code.exe", "C:\Program Files\Microsoft VS Code\Code.exe")
#f::RunOrFocusApp("File Explorer", "explorer.exe", "explorer.exe")
#t::RunOrFocusApp("Windows Terminal", "WindowsTerminal.exe", "wt.exe")
#b::RunOrFocusApp("chrome.exe", "C:\Program Files\Google\Chrome\Application\chrome.exe")

; ---------------------
; Enhanced Function
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

    ; Build the search criteria
    searchCriteria := winTitle != "" ? winTitle " ahk_exe " exeName : "ahk_exe " exeName

    ; Get all windows for this process
    try {
        windows := WinGetList(searchCriteria)
    } catch {
        ; If WinGetList fails, try to run the app
        Run exePath
        return
    }

    ; Filter out invisible windows and get visible ones only
    visibleWindows := []
    for hwnd in windows {
        if WinGetStyle("ahk_id " hwnd) & 0x10000000 {  ; WS_VISIBLE
            visibleWindows.Push(hwnd)
        }
    }

    ; If no visible windows found, launch the app
    if visibleWindows.Length = 0 {
        Run exePath
        return
    }

    ; Get currently active window
    activeWin := WinExist("A")
    activeExe := ""
    try {
        activeExe := WinGetProcessName("ahk_id " activeWin)
    }

    ; If the active window belongs to this app
    if activeExe = exeName {
        ; Find current window in the list
        currentIndex := 0
        for index, hwnd in visibleWindows {
            if hwnd = activeWin {
                currentIndex := index
                break
            }
        }

        ; If only one window exists, toggle minimize
        if visibleWindows.Length = 1 {
            WinMinimize("ahk_id " activeWin)
            return
        }

        ; Cycle to the next window
        if currentIndex > 0 {
            nextIndex := Mod(currentIndex, visibleWindows.Length) + 1
            nextWin := visibleWindows[nextIndex]
            
            ; Restore if minimized
            if WinGetMinMax("ahk_id " nextWin) = -1 {
                WinRestore("ahk_id " nextWin)
            }
            
            WinActivate("ahk_id " nextWin)
            return
        }
    }

    ; Activate the first window (default behavior)
    firstWin := visibleWindows[1]
    
    ; Restore if minimized
    if WinGetMinMax("ahk_id " firstWin) = -1 {
        WinRestore("ahk_id " firstWin)
    }
    
    WinActivate("ahk_id " firstWin)
}

; ---------------------
; Optional: Reload Script
; ---------------------
