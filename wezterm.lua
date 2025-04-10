local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.check_for_updates = false

local default_font_size = 14
if wezterm.hostname() == 'overlook' then
    default_font_size = 22
end

config.window_frame = {
    font_size = default_font_size,
}
config.bold_brightens_ansi_colors = true
config.font = wezterm.font(
    -- https://fonts.google.com/noto/specimen/Noto+Sans+Mono
    'Noto Sans Mono',
    { weight = 'Bold' }
)
config.colors = {
    cursor_bg = 'rgb(255 150 244)',
    cursor_fg = 'black',
    foreground = 'white',
    background = '#2aaa2aaa2aaa',
    ansi = {
        'rgb(0,0,0)',
        'rgb(239,41,41)',
        'rgb(124,207,44)',
        'rgb(222,190,50)',
        'rgb(100,147,197)',
        'rgb(166,114,160)',
        'rgb(52,226,226)',
        'rgb(85,87,83)',
    },
    brights = {
        'rgb(85,85,85)',
        'rgb(255,85,85)',
        'rgb(138,226,52)',
        'rgb(236,203,56)',
        'rgb(114,159,207)',
        'rgb(173,127,168)',
        'rgb(85,255,255)',
        'rgb(211,215,207)'
    },
}
config.mouse_bindings = {
    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
    },

    -- and make CTRL-Click open hyperlinks
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CTRL',
        action = wezterm.action.OpenLinkAtMouseCursor,
    },
}
config.audible_bell = "Disabled"
return config
