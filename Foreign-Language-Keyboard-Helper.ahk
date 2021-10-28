#NoEnv
#Warn
#SingleInstance Force
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
SendMode Input
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1


global curLanguage := "Default"


return ; auto-execute section end


; ------------- functions start -------------

SwitchLanguageToGerman()
{
	curLanguage := "German"
	
	Gui, Destroy
}

SwitchLanguageToDefault()
{
	curLanguage := "Default"
	
	Gui, Destroy
}


CheckIfCharsShouldBeCapital()
{
	return GetKeyState("CapsLock", "T") ^ GetKeyState("Shift", "P")	; CapsLock Toggle XOR Shift Physical
}


SendCharWithProperCapitalization(char)
{	
	; this char is Uppercase if chars should be capital, otherwise Lowercase
	charWithProperCapitalization := CheckIfCharsShouldBeCapital() ? Format("{:U}", char) : Format("{:L}", char)
		
	Send, %charWithProperCapitalization%
}


SendCurChar()
{
	curHotkey := A_ThisHotkey
	
	curBaseChar := StrReplace(curHotkey, "*<^>!", "")	; remove *AltGr from str, leaving only the base character
		
	if(curLanguage == "German")
	{
		switch curBaseChar
		{
			case "a":
				SendCharWithProperCapitalization("ä")
				return
			case "o":
				SendCharWithProperCapitalization("ö")
				return
			case "u":
				SendCharWithProperCapitalization("ü")
				return
			case "s":
				SendCharWithProperCapitalization("ß")
				return
			default:
				MsgBox, Error - unrecognized German character.
				return
		}
	}
}

; ------------- functions end -------------


; ------------- labels start -------------

GuiClose:
Gui, Destroy
return

; ------------- labels end -------------


; ------------- hotkeys start -------------

^+!U::	; Ctrl + Shift + Alt + U for UI (for picking the language)
Gui, Font, s20, Verdana
Gui, Add, Button, Default x20 y20 gSwitchLanguageToGerman, German
Gui, Add, Button, x160 y20 gSwitchLanguageToDefault, Default	; system default, no effect
Gui, Show, w300 h100, Pick language to emulate
return


; foreign language characters
; <^>! - AltGr
; * - fire the hotkey even if extra modifiers are being held down
#If (curLanguage == "German")

*<^>!a::
*<^>!o::
*<^>!u::
*<^>!s::
SendCurChar()
return

#If	; clear #If


; strictly Duolingo-related section
#IfWinActive, Duolingo - The world's best way to learn German

*F1::	; listen normally
MouseClick, Left, % 0.48 * A_ScreenWidth, % 0.435 * A_ScreenHeight, 1
MouseMove, % 0.5 * A_ScreenWidth, % 0.85 * A_ScreenHeight
return

*F2::	; listen slowly
MouseClick, Left, % 0.53 * A_ScreenWidth, % 0.45 * A_ScreenHeight, 1
MouseMove, % 0.5 * A_ScreenWidth, % 0.85 * A_ScreenHeight
return

*F3::	; listen normally (speech bubble)
MouseClick, Left, % 0.435 * A_ScreenWidth, % 0.45 * A_ScreenHeight, 1
MouseMove, % 0.5 * A_ScreenWidth, % 0.85 * A_ScreenHeight
return

*F4::	; listen slowly (speech bubble)
MouseClick, Left, % 0.475 * A_ScreenWidth, % 0.45 * A_ScreenHeight, 1
MouseMove, % 0.5 * A_ScreenWidth, % 0.85 * A_ScreenHeight
return

#IfWinActive	; clear IfWinActive


^+!e::	; Ctrl + Shift + Alt + E for emergency Exit
ExitApp
return

; ------------- hotkeys end -------------