return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>fo",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
			},
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- Added kulala, since it is not in Mason yet
			formatters = {
				kulala = {
					command = "kulala-fmt",
					args = { "$FILENAME" },
					stdin = false,
				},
			},
			formatters_by_ft = {
				http = { "kulala" },
				java = { "google-java-format" },
				javascript = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettierd" },
				php = { "php_cs_fixer" },
				python = { "ruff_organize_imports", "ruff_format" },
				rust = { "rustfmt" },
				sh = { "shfmt" },
				terraform = { "terraform_fmt" },
				typescript = { "prettierd" },
				["_"] = { "trim_whitespace" },
			},
		},
	},
}
