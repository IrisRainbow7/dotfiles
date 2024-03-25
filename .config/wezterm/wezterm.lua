require 'format'
require 'status'

local wezterm = require 'wezterm'
return {
    color_scheme = 'Material (base16)',
    window_background_opacity = 0.8,
    font = wezterm.font("HackGen Console NF"),
    font_size = 13.5,
    status_update_interval = 1000,
    background = {
        {
            source = {
                File = '/Users/koki.hirai/Downloads/azisava_mandelbrot_0107_1920x1080.png'
            },
            hsb = {
                -- hue = 0.15,
                saturation = 0.9,
                brightness = 0.2,
            },
            horizontal_offset = -160,
            vertical_offset = 30
        },
        {
            source = {
                Color = 'black'
            },
            hsb = {
                brightness = 0.5
            },
            opacity = 0.3,
            width = '100%',
            height = '100%'
        }
    },
    disable_default_key_bindings = true,
    leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 },
    keys = require("keybinds").keys,
    key_tables = require('keybinds').key_tables,
}
