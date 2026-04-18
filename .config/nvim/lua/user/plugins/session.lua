return {
	{
		"rmagatti/auto-session",
		lazy = false,
		opts = {
			session_lens = {
				picker = "fzf",
			},
			suppressed_dirs = { "~/", "~/.config", "~/Projects", "~/Downloads", "/" },
			bypass_save_filetypes = { "alpha", "dashboard", "snacks_dashboard" }, -- or whatever dashboard you use
		},
	},
}
