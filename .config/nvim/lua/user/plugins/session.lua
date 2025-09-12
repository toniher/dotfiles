return {
	{
		"rmagatti/auto-session",
		lazy = false,
		dependencies = {},
		config = function()
			require("auto-session").setup({
				{
					auto_save = false,
					session_lens = {
						load_on_setup = true,
						previewer = false,
						theme_conf = {
							border = true,
						},
					},
					suppressed_dirs = { "~/", "~/.config", "~/Projects", "~/Downloads", "/" },
				},
			})
		end,
	},
}
