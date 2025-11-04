#Requires AutoHotkey v2.0
#SingleInstance Force

; ========================================
; Configuration Section
; ========================================
global APP_CONFIG := Map(
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
    },
    "excel", {
        title: "Excel",
        exe: "EXCEL.EXE",
        path: "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
    },
    "word", {
        title: "Word",
        exe: "WINWORD.EXE",
        path: "C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE"
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
CapsLock::Esc
; Esc::CapsLock  ; Uncomment to swap instead of just remapping

; ========================================
; Application Shortcuts
; ========================================
#n::RunOrFocusApp(APP_CONFIG["notepad"])
#v::RunOrFocusApp(APP_CONFIG["vscode"])
#f::RunOrFocusApp(APP_CONFIG["explorer"])
#t::RunOrFocusApp(APP_CONFIG["terminal"])
#b::RunOrFocusApp(APP_CONFIG["chrome"])
#e::RunOrFocusApp(APP_CONFIG["excel"])
#w::RunOrFocusApp(APP_CONFIG["word"])

; Additional productivity shortcuts
#c::RunCalculator()
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
