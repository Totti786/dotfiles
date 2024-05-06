export const keybindList = [[
    {
        "icon": "pin_drop",
        "name": "Workspaces: navigation",
        "binds": [
            { "keys": ["", "+", "#"], "action": "Go to workspace #" },
            { "keys": ["", "+", "(Mouse Scroll ↑↓)"], "action": "Go to workspace -1/+1" },
            { "keys": ["", "Ctrl", "+", "←↑"], "action": "Go to workspace on the left" },
            { "keys": ["", "Ctrl", "+", "→↓"], "action": "Go to workspace on the right" },
        ],
        "id": 1
    },
    {
        "icon": "overview_key",
        "name": "Workspaces: management",
        "binds": [
            { "keys": ["", "Shift", "+", "#"], "action": "Move window to workspace #" },
            { "keys": ["", "Ctrl", "+", "#"], "action": "Move window to workspace # and follow" },
            { "keys": ["", "Shift", "+", "D"], "action": "Move window to special workspace" },
            { "keys": ["", "+", "D"], "action": "Toggle special workspace" },
            { "keys": ["", "Shift", "+", "G"], "action": "Toggle tabbed mode" },
        ],
        "id": 2
    },
    {
        "icon": "move_group",
        "name": "Windows",
        "binds": [
            { "keys": ["", "+", "←↑→↓"], "action": "Focus window in direction" },
            { "keys": ["", "+", "Lmb"], "action": "Move window" },
            { "keys": ["", "+", "Rmb"], "action": "Resize window" },
            { "keys": ["", "Shift", "+", "←↑→↓"], "action": "Swap window in direction" },
            { "keys": ["", "Shift", "+", "F"], "action": "Toggle Fullscreen" },
        ],
        "id": 3
    }
],
[
    {
        "icon": "widgets",
        "name": "Widgets (AGS)",
        "binds": [
            { "keys": ["", "OR", "", "+", "Tab"], "action": "Toggle overview/launcher" },
            { "keys": ["Ctrl", "Shift", "+", "R"], "action": "Restart AGS" },
            { "keys": ["", "+", "/"], "action": "Toggle this cheatsheet" },
            { "keys": ["", "+", "."], "action": "Toggle Focus Mode" },
            { "keys": ["", "+", ","], "action": "Toggle Color Menu" },
            { "keys": ["", "+", "K"], "action": "Toggle virtual keyboard" },
            { "keys": ["", "+", "X"], "action": "Power/Session menu" },

            { "keys": ["Esc"], "action": "Exit a window" },

            { "keys": ["", "Shift", "+", "W"], "action": "Pick Wallpaper" },
            { "keys": ["Alt", "Shift", "+", "W"], "action": "Set Random Wallpaper" },
        ],
        "id": 4
    },
    {
        "icon": "construction",
        "name": "Utilities",
        "binds": [
            { "keys": ["PrtSc"], "action": "Take Screenshot" },
            { "keys": ["Shift", "+", "PrtSc"], "action": "Screen snip  >>  clipboard" },
            { "keys": ["Alt", "+", "PrtSc"], "action": "Image to text  >>  clipboard" },
            { "keys": ["", "+", "P"], "action": "Color picker" },
            { "keys": ["", "Alt", "+", "R"], "action": "Record region" },
            { "keys": ["Ctrl", "Alt", "+", "R"], "action": "Record region with sound" },
            { "keys": ["", "Shift", "Alt", "+", "R"], "action": "Record screen with sound" }
        ],
        "id": 5
    },
],
[
    {
        "icon": "apps",
        "name": "Apps",
        "binds": [
            { "keys": ["", "+", "Enter"], "action": "Launch Terminal: Alacritty" },
            { "keys": ["", "+", "F"], "action": "Launch Browser: Firefox" },
            { "keys": ["", "+", "E"], "action": "Launch File Manager: Thunar" },
            { "keys": ["", "+", "W"], "action": "Launch Text Editor: Geany" },
            { "keys": ["", "+", "Z"], "action": "Launch Discord" },
            { "keys": ["", "Shift", "+", "S"], "action": "Launch Spotify" },
        ],
        "id": 6
    },
    {
        "icon": "keyboard",
        "name": "Typing",
        "binds": [
            { "keys": ["", "+", "V"], "action": "Clipboard history  >>  clipboard" },
        ],
        "id": 7
    },
    {
        "icon": "terminal",
        "name": "Launcher actions",
        "binds": [
            { "keys": [">raw"], "action": "Toggle mouse acceleration" },
            { "keys": [">img"], "action": "Select wallpaper and generate colorscheme" },
            { "keys": [">light"], "action": "Switch to light theme" },
            { "keys": [">dark"], "action": "Switch to dark theme" },
            { "keys": [">color"], "action": "Pick acccent color" },
            { "keys": [">todo"], "action": "Type something after that to add a To-do item" },
        ],
        "id": 8
    }
]];
