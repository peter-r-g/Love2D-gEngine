local INPUT = {}

INPUT.key = {
    ["A"] = "a",
    ["B"] = "b",
    ["C"] = "c",
    ["D"] = "d",
    ["E"] = "e",
    ["F"] = "f",
    ["G"] = "g",
    ["H"] = "h",
    ["I"] = "i",
    ["J"] = "j",
    ["K"] = "k",
    ["L"] = "l",
    ["M"] = "m",
    ["N"] = "n",
    ["O"] = "o",
    ["P"] = "p",
    ["Q"] = "q",
    ["R"] = "r",
    ["S"] = "s",
    ["T"] = "t",
    ["U"] = "u",
    ["V"] = "v",
    ["W"] = "w",
    ["X"] = "x",
    ["Y"] = "y",
    ["Z"] = "z",
    ["Zero"] = "0",
    ["One"] = "1",
    ["Two"] = "2",
    ["Three"] = "3",
    ["Four"] = "4",
    ["Five"] = "5",
    ["Six"] = "6",
    ["Seven"] = "7",
    ["Eight"] = "8",
    ["Nine"] = "9",
    ["Space"] = "space",
    ["Exclamation"] = "!",
    ["DoubleQuote"] = "\"",
    ["Hash"] = "#",
    ["Dollar"] = "$",
    ["Ampersand"] = "&",
    ["SingleQuote"] = "'",
    ["LeftParenthesis"] = "(",
    ["RightParenthesis"] = ")",
    ["Asterisk"] = "*",
    ["Plus"] = "+",
    ["Comma"] = ",",
    ["Hyphen"] = "-",
    ["Period"] = ".",
    ["Slash"] = "/",
    ["Colon"] = ":",
    ["Semicolon"] = ";",
    ["LessThan"] = "<",
    ["Equals"] = "=",
    ["GreaterThan"] = ">",
    ["Question"] = "?",
    ["At"] = "@",
    ["LeftSquareBracket"] = "[",
    ["Backslash"] = "\\",
    ["RightSquareBracket"] = "]",
    ["Caret"] = "^",
    ["Underscore"] = "_",
    ["Tilde"] = "`",
    
    ["KeyPad_Zero"] = "kp0",
    ["KeyPad_One"] = "kp1",
    ["KeyPad_Two"] = "kp2",
    ["KeyPad_Three"] = "kp3",
    ["KeyPad_Four"] = "kp4",
    ["KeyPad_Five"] = "kp5",
    ["KeyPad_Six"] = "kp6",
    ["KeyPad_Seven"] = "kp7",
    ["KeyPad_Eight"] = "kp8",
    ["KeyPad_Nine"] = "kp9",
    ["KeyPad_Period"] = "kp.",
    ["KeyPad_Comma"] = "kp,",
    ["KeyPad_Slash"] = "kp/",
    ["KeyPad_Asterisk"] = "kp*",
    ["KeyPad_Hyphen"] = "kp-",
    ["KeyPad_Plus"] = "kp+",
    ["KeyPad_Return"] = "kpenter",
    ["KeyPad_Equals"] = "kp=",
    
    ["UpArrow"] = "up",
    ["RightArrow"] = "right",
    ["DownArrow"] = "down",
    ["LeftArrow"] = "left",
    ["Home"] = "home",
    ["End"] = "end",
    ["PageUp"] = "pageup",
    ["PageDown"] = "pagedown",
    
    ["Insert"] = "insert",
    ["Backspace"] = "backspace",
    ["Tab"] = "tab",
    ["Clear"] = "clear",
    ["Return"] = "return",
    ["Delete"] = "delete",
    
    ["F1"] = "f1",
    ["F2"] = "f2",
    ["F3"] = "f3",
    ["F4"] = "f4",
    ["F5"] = "f5",
    ["F6"] = "f6",
    ["F7"] = "f7",
    ["F8"] = "f8",
    ["F9"] = "f9",
    ["F10"] = "f10",
    ["F11"] = "f11",
    ["F12"] = "f12",
    ["F13"] = "f13",
    ["F14"] = "f14",
    ["F15"] = "f15",
    ["F16"] = "f16",
    ["F17"] = "f17",
    ["F18"] = "f18",
    
    ["NumLock"] = "numlock",
    ["CapsLock"] = "capslock",
    ["ScrollLock"] = "scrolllock",
    ["RightShift"] = "rshift",
    ["LeftShift"] = "lshift",
    ["RightCtrl"] = "rctrl",
    ["LeftCtrl"] = "lctrl",
    ["RightAlt"] = "ralt",
    ["LeftAlt"] = "lalt",
    ["RightCommand"] = "rgui",
    ["LeftCommand"] = "lgui",
    ["Mode"] = "mode",
    
    ["WWW"] = "www",
    ["Mail"] = "mail",
    ["Calculator"] = "calculator",
    ["Computer"] = "computer",
    ["AppSearch"] = "appsearch",
    ["AppHome"] = "apphome",
    ["AppBack"] = "appback",
    ["AppForward"] = "appforward",
    ["AppRefresh"] = "apprefresh",
    ["AppBookmarks"] = "appbookmarks",
    
    ["Pause"] = "pause",
    ["Escape"] = "escape",
    ["Help"] = "help",
    ["PrintScreen"] = "printscreen",
    ["SystemRequest"] = "sysreq",
    ["Menu"] = "menu",
    ["Application"] = "application",
    ["Power"] = "power",
    ["CurrencyUnit"] = "currencyunit",
    ["Undo"] = "undo",
}

INPUT.button = {
    ["Left"] = 1,
    ["Middle"] = 2,
    ["Right"] = 3,
    ["Button4"] = 4,
    ["Button5"] = 5,
}

local keys = {}
local buttons = {}

function INPUT.IsKeyDown(key)
    return keys[key] == true or keys[key] == false or false
end

function INPUT.IsKeyHeld(key)
    return keys[key] == true
end

function INPUT.IsKeyUp(key)
    return keys[key] == nil
end

function INPUT.IsButtonDown(button)
    return buttons[button] == false
end

function INPUT.IsButtonUp(button)
    return buttons[button] == nil
end

function INPUT:KeyPressed(key, scanCode, isRepeat)
    if keys[key] == false then
        keys[key] = true
    else
        keys[key] = false
    end
end

function INPUT:KeyReleased(key, scanCode)
    keys[key] = nil
end

function INPUT:MousePressed(x, y, button, isTouch, presses)
    buttons[button] = false
end

function INPUT:MouseReleased(x, y, button, isTouch, presses)
    buttons[button] = nil
end

return INPUT