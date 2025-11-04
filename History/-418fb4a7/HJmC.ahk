#Requires AutoHotkey v2.0
#SingleInstance Force



; ========================================
; Configuration Section
; ========================================
global APP_CONFIG := Map(
    "msword", {
        title: "",
        exe: "WINWORD.EXE",
        path: "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
    },    
    "msexcel", {
        title: "",
        exe: "EXCEL.EXE",
        path: "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
    },    
    "notepad", {
        title: "Notepad",
        exe: "notepad.exe",
        path: "notepad.exe"
    },
    "vscode", {
        title: "Visual Studio Code",
        exe: "Code.exe",
        path: "C:\Users\WALTON\AppData\Local\Programs\Microsoft VS Code\Code.exe"
    },
    "explorer", {
        title: "File Explorer",
        exe: "explorer.exe",
        path: "explorer.exe"
    },
    "terminal", {
        title: "Windows Terminal",
        exe: "WindowsTerminal.exe",
        path: "wt.exe"
    },
    "chrome", {
        title: "Google Chrome",
        exe: "chrome.exe",
        path: "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    }
)

; ========================================
; System Hotkeys
; ========================================
#+r::ReloadScript()
#+e::EditScript()
#q::SmartCloseWindow()
#Esc::ExitApp

; ========================================
; Key Remapping
; ========================================
; CapsLock::Esc
; Esc::CapsLock  ; Uncomment to swap instead of just remapping

; ========================================
; Application Shortcuts
; ========================================
#n::RunOrFocusApp(APP_CONFIG["notepad"])
; #v::RunOrFocusApp(APP_CONFIG["vscode"])
#f::RunOrFocusApp(APP_CONFIG["explorer"])
#t::RunOrFocusApp(APP_CONFIG["terminal"])
#b::RunOrFocusApp(APP_CONFIG["chrome"])
#e::RunOrFocusApp(APP_CONFIG["msexcel"])
#w::RunOrFocusApp(APP_CONFIG["msword"])
; Additional productivity shortcuts
#c::RunMpv()
#s::RunSnippingTool()
#+s::RunSystemSettings()
#m::ToggleAllWindowsMinimize()

; Window management shortcuts
#Left::SnapWindowLeft()
#Right::SnapWindowRight()
#Up::MaximizeWindow()
#Down::RestoreOrMinimizeWindow()
#+Left::MoveToMonitor("left")
#+Right::MoveToMonitor("right")

; ========================================
; Main Functions
; ========================================
RunOrFocusApp(config) {
    static lastActivated := Map()
    
    exe := config.exe
    path := config.path
    title := config.HasProp("title") ? config.title : ""
    
    ; Check if process exists
    if !ProcessExist(exe) {
        LaunchApp(path, exe)
        return
    }
    
    ; Build search criteria
    searchCriteria := title ? title " ahk_exe " exe : "ahk_exe " exe
    
    ; Get visible windows
    windows := GetVisibleWindows(searchCriteria)
    
    if windows.Length = 0 {
        LaunchApp(path, exe)
        return
    }
    
    ; Handle window activation/cycling
    activeWin := WinExist("A")
    activeExe := GetProcessName(activeWin)
    
    if activeExe = exe {
        HandleAppCycling(windows, activeWin, exe)
    } else {
        ActivateWindow(windows[1])
    }
    
    ; Track last activation time
    lastActivated[exe] := A_TickCount
}

; ========================================
; Helper Functions
; ========================================
LaunchApp(path, exe) {
    try {
        Run(path)
        ; Wait for window with timeout
        if WinWait("ahk_exe " exe, , 3) {
            WinActivate()
        }
    } catch as err {
        ShowError("Failed to launch " exe, err.Message)
    }
}

GetVisibleWindows(searchCriteria) {
    visible := []
    try {
        for hwnd in WinGetList(searchCriteria) {
            if IsWindowVisible(hwnd) && !IsWindowCloaked(hwnd) {
                visible.Push(hwnd)
            }
        }
    } catch {
        ; Return empty array on error
    }
    return visible
}

IsWindowVisible(hwnd) {
    style := WinGetStyle("ahk_id " hwnd)
    return (style & 0x10000000) != 0  ; WS_VISIBLE
}

IsWindowCloaked(hwnd) {
    ; Check if window is cloaked (Windows 10+ virtual desktop feature)
    static DWMWA_CLOAKED := 14
    cloaked := Buffer(4, 0)
    
    if DllCall("dwmapi\DwmGetWindowAttribute",
        "Ptr", hwnd,
        "UInt", DWMWA_CLOAKED,
        "Ptr", cloaked,
        "UInt", 4) = 0 {
        return NumGet(cloaked, "UInt") != 0
    }
    return false
}

HandleAppCycling(windows, activeWin, exe) {
    ; Find current window index
    currentIndex := 0
    for i, hwnd in windows {
        if hwnd = activeWin {
            currentIndex := i
            break
        }
    }
    
    ; Single window: minimize
    if windows.Length = 1 {
        WinMinimize("ahk_id " activeWin)
        return
    }
    
    ; Multiple windows: cycle
    nextIndex := Mod(currentIndex, windows.Length) + 1
    ActivateWindow(windows[nextIndex])
}

ActivateWindow(hwnd) {
    ; Restore if minimized
    if WinGetMinMax("ahk_id " hwnd) = -1 {
        WinRestore("ahk_id " hwnd)
    }
    
    ; Activate window
    WinActivate("ahk_id " hwnd)
    
    ; Ensure window comes to front
    WinMoveTop("ahk_id " hwnd)
}

GetProcessName(hwnd) {
    try {
        return WinGetProcessName("ahk_id " hwnd)
    } catch {
        return ""
    }
}

; ========================================
; Window Management Functions
; ========================================
SmartCloseWindow() {
    ; Don't close desktop or taskbar
    activeWin := WinExist("A")
    className := WinGetClass("ahk_id " activeWin)
    
    if className != "Shell_TrayWnd" && className != "Progman" {
        WinClose("ahk_id " activeWin)
    }
}

SnapWindowLeft() {
    WinMove(0, 0, A_ScreenWidth // 2, A_ScreenHeight, "A")
}

SnapWindowRight() {
    WinMove(A_ScreenWidth // 2, 0, A_ScreenWidth // 2, A_ScreenHeight, "A")
}

MaximizeWindow() {
    WinMaximize("A")
}

RestoreOrMinimizeWindow() {
    state := WinGetMinMax("A")
    if state = 1  ; Maximized
        WinRestore("A")
    else
        WinMinimize("A")
}

MoveToMonitor(direction) {
    ; Get monitor info
    monCount := MonitorGetCount()
    if monCount <= 1
        return
    
    ; Get current monitor
    hwnd := WinExist("A")
    currentMon := GetMonitorIndex(hwnd)
    
    ; Calculate target monitor
    if direction = "left"
        targetMon := currentMon > 1 ? currentMon - 1 : monCount
    else
        targetMon := currentMon < monCount ? currentMon + 1 : 1
    
    ; Get target monitor bounds
    MonitorGet(targetMon, &left, &top, &right, &bottom)
    
    ; Move window to center of target monitor
    WinGetPos(&winX, &winY, &winW, &winH, "ahk_id " hwnd)
    newX := left + ((right - left - winW) // 2)
    newY := top + ((bottom - top - winH) // 2)
    WinMove(newX, newY, , , "ahk_id " hwnd)
}

GetMonitorIndex(hwnd) {
    WinGetPos(&x, &y, &w, &h, "ahk_id " hwnd)
    centerX := x + w // 2
    centerY := y + h // 2
    
    Loop MonitorGetCount() {
        MonitorGet(A_Index, &left, &top, &right, &bottom)
        if (centerX >= left && centerX <= right && centerY >= top && centerY <= bottom)
            return A_Index
    }
    return 1
}

ToggleAllWindowsMinimize() {
    static minimized := false
    
    if !minimized {
        ; Minimize all windows
        Send("#m")
        minimized := true
    } else {
        ; Restore all windows
        Send("#+m")
        minimized := false
    }
}

; ========================================
; Utility Functions
; ========================================
RunMpv() {
    Run("mpv.exe")
}

RunSnippingTool() {
    Run("ms-screenclip:")
}

RunSystemSettings() {
    Run("ms-settings:")
}

ReloadScript() {
    Reload()
}

EditScript() {
    Edit()
}

ShowError(title, message) {
    MsgBox(message, title, "IconX")
}

; ========================================
; Auto-Execute Section
; ========================================
; Set coordinate mode to screen for all mouse functions
CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Screen")
CoordMode("ToolTip", "Screen")

; Create tray menu
A_TrayMenu.Delete()  ; Remove default items
A_TrayMenu.Add("Edit Script", (*) => Edit())
A_TrayMenu.Add("Reload Script", (*) => Reload())
A_TrayMenu.Add()  ; Separator
A_TrayMenu.Add("Exit", (*) => ExitApp())

; Show tooltip on startup
ShowStartupNotification()

ShowStartupNotification() {
    ToolTip("AutoHotkey Enhanced Script Loaded!", A_ScreenWidth - 250, 50)
    SetTimer(() => ToolTip(), -2000)  ; Remove after 2 seconds
}