-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.enable_wayland = false

-- This is where you actually apply your config choices

-- config.font = wezterm.font("JetBrainsMono Nerd Font")
-- config.font = wezterm.font("CaskaydiaCove Nerd Font Mono")
config.font = wezterm.font("NotoMono Nerd Font")
config.window_background_opacity = 0.95
-- For example, changing the color scheme:
config.font_size = 13
config.color_scheme = "Tokyo Night"
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
-- and finally, return the configuration to wezterm
return config
