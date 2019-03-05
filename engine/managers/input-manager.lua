-- Localize variables
local Steam, Class, Timer, EventManager = Steam, Class, Timer, EventManager

local MANAGER = {}

-- Table to hold all of the key translations
MANAGER.key = {
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

-- Table to hold all of the mouse button translations
MANAGER.button = {
    ["Left"] = 1,
    ["Middle"] = 2,
    ["Right"] = 3,
    ["Button4"] = 4,
    ["Button5"] = 5,
}

-- Table to hold the states of the keys
MANAGER.keys = {}

-- Table to hold the states of the buttons
MANAGER.buttons = {}

-- Function to check if a key is down
function MANAGER:IsKeyDown(key)
   return self.keys[key] == true or self.keys[key] == false or false
end

-- Function to check if a key is held down
function MANAGER:IsKeyHeld(key)
    return self.keys[key] == true
end

-- Function to check if a key is up
function MANAGER:IsKeyUp(key)
    return self.keys[key] == nil
end

-- Function to check if a mouse button is down
function MANAGER:IsButtonDown(button)
    return self.buttons[button] == false
end

-- Function to check if a mouse button is up
function MANAGER:IsButtonUp(button)
    return self.buttons[button] == nil
end

-- Subscribe to the key pressed event so we can update our keys
EventManager:Subscribe("KeyPressed", "InputManager.UpdateKeys", function(key, scanCode, isRepeat)
    if MANAGER.keys[key] == false then
        MANAGER.keys[key] = true
    else
        MANAGER.keys[key] = false
    end
end)

-- Subscribe to the key released event so we can update our keys
EventManager:Subscribe("KeyReleased", "InputManager.UpdateKeys", function(key, scanCode)
    MANAGER.keys[key] = nil
end)

EventManager:Subscribe("MousePressed", "InputManager.UpdateMouse", function(x, y, button, isTouch, presses)
    MANAGER.buttons[button] = false
end)

EventManager:Subscribe("MouseReleased", "InputManager.UpdateMouse", function(x, y, button, isTouch, presses)
    MANAGER.buttons[button] = nil
end)

return MANAGER