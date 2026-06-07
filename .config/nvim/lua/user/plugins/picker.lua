return {
	{
		"DrKJeff16/project.nvim",
		config = function()
			require("project").setup({
				exclude_dirs = { "~/.config/*" },
				fzf_lua = {
					enabled = true,
				},
			})
		end,
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		opts = {},
	},
}
