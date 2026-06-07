return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason.nvim", version = "*" },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("user.lsp")
		end,
	},
	{ "toniher/lsp-timeout.nvim" }, -- TODO: Upgrade to upstream
	{
		"j-hui/fidget.nvim",
		version = "*",
		config = function()
			require("fidget").setup()
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("lint").linters_by_ft = {
				bash = { "shellcheck" },
				javascript = { "eslint_d" },
				lua = { "selene" },
				-- markdown = { "vale" },
				-- markdown = { "markdownlint" },
				php = { "phpcs" },
				-- python = { "ruff" },
				rst = { "rstcheck" },
				sh = { "shellcheck" },
				terraform = { "tflint" },
				-- text = { "vale" },
				typescript = { "eslint_d" },
				zsh = { "shellcheck" },
				["*"] = { "editorconfig-checker" },
			}
		end,
	},
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("illuminate").configure({
				providers = {
					"lsp",
					-- "treesitter", # TODO: To recover https://github.com/RRethy/vim-illuminate/issues/247
					"regex",
				},
				delay = 200,
				filetypes_denylist = {
					"dirvish",
					"fugitive",
					-- "alpha",
					"NvimTree",
					"packer",
					"neogitstatus",
					"Trouble",
					"lir",
					"Outline",
					"spectre_panel",
					"toggleterm",
					"DressingSelect",
					"TelescopePrompt",
				},
				filetypes_allowlist = {},
				modes_denylist = {},
				modes_allowlist = {},
				providers_regex_syntax_denylist = {},
				providers_regex_syntax_allowlist = {},
				under_cursor = true,
			})
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
	},
}
