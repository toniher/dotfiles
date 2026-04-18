return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		init = function()
			local ensure_installed = {
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
			}
			local installed = require("nvim-treesitter.config").get_installed()
			local to_install = vim.iter(ensure_installed)
				:filter(function(lang)
					return not vim.tbl_contains(installed, lang)
				end)
				:totable()
			require("nvim-treesitter").install(to_install)

			vim.api.nvim_create_autocmd('FileType', {
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
		opts = {
			highlight = { enable = true },
			indent = { enable = true, disable = { "python", "css" } },
			autopairs = { enable = true },
			-- context_commentstring = {
			-- 	enable = true,
			-- 	enable_autocmd = false,
			-- },
		},
	},
	{ "nvim-treesitter/nvim-treesitter-context", event = { "BufReadPost", "BufNewFile" } },
	{
		"lukas-reineke/indent-blankline.nvim",
		tag = "v3.9.1",
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
	-- { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main", event = { "BufReadPost", "BufNewFile" } },
{
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
    end,
  },
	{ "https://gitlab.com/HiPhish/rainbow-delimiters.nvim", event = { "BufReadPost", "BufNewFile" } },
}
