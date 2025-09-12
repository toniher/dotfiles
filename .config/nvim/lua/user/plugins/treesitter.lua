return {
	{
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.10.0",
		event = { "BufReadPost", "BufNewFile" },
		-- dependencies = { "OXY2DEV/markview.nvim" },
		config = function()
			require("nvim-treesitter").setup() -- put your config here
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"diff",
					"dockerfile",
					"graphql",
					"html",
					"http",
					"java",
					"javascript",
					"json",
					"kdl",
					"lua",
					"markdown",
					"markdown_inline",
					"perl",
					"php",
					"python",
					"regex",
					"rust",
					"sql",
					"typescript",
					"xml",
					"yaml",
				}, -- put the language you want in this array
				-- ensure_installed = "all", -- one of "all" or a list of languages
				ignore_install = { "" }, -- List of parsers to ignore installing
				sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)

				highlight = {
					enable = true, -- false will disable the whole extension
					-- disable = { "css" }, -- list of language that will be disabled
				},
				autopairs = {
					enable = true,
				},
				indent = { enable = true, disable = { "python", "css" } },

				-- context_commentstring = {
				-- 	enable = true,
				-- 	enable_autocmd = false,
				-- },
			})
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context", event = { "BufReadPost", "BufNewFile" } },
	{
		"lukas-reineke/indent-blankline.nvim",
		tag = "v3.9.0",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			local hooks = require("ibl.hooks")
			vim.g.rainbow_delimiters = { highlight = highlight }

			-- create the highlight groups in the highlight setup hook, so they are reset
			-- every time the colorscheme changes
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)
			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

			require("ibl").setup({
				indent = { highlight = highlight },
				exclude = {
					filetypes = { "help", "terminal", "packer", "NvimTree" },
					buftypes = { "terminal", "nofile" },
				},
			})
		end,
	},
	{ "JoosepAlviste/nvim-ts-context-commentstring", event = { "BufReadPost", "BufNewFile" } },
	{ "https://gitlab.com/HiPhish/rainbow-delimiters.nvim", event = { "BufReadPost", "BufNewFile" } },
}
