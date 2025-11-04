#Requires AutoHotkey v2.0
#SingleInstance Force
#+r::Reload  ; Edit script
#+e::Edit   ; Edit script
#q::WinClose("A")  ; Closes the active window
CapsLock::Esc ; CapsLock to Escape
Esc::Return ; Disable Escape
; Esc::CapsLock ; Escape to capslock