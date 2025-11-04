#Requires AutoHotkey v2.0
#SingleInstance Force
; Swap CapsLock and Escape keys (AutoHotkey v2)

CapsLock::Send "{Esc}"
Esc::
{
    SetCapsLockState !GetKeyState("CapsLock", "T")
}


