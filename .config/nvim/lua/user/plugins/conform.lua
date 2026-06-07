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
			-- format_on_save = {
			-- 	-- These options will be passed to conform.format()
			-- 	timeout_ms = 500,
			-- },
			-- Disable format on save, since it can be disruptive
			format_on_save = nil,
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- Toniher: Added kulala, since it is not in Mason yet
			-- Toniher: Added nextflow, since we might want something more than the LSP formatting
			formatters = {
				kulala = {
					command = "kulala-fmt",
					args = { "$FILENAME" },
					stdin = false,
				},
				nextflow = {
					command = "nextflow",
					args = { "lint", "-format", "-sort-declarations", "-spaces", "4", "-harshil-alignment", "$FILENAME" },
					stdin = false,
				},
			},
			formatters_by_ft = {
				cff = { "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				http = { "kulala" },
				java = { "google-java-format" },
				javascript = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettierd" },
				nextflow = { "nextflow" },
				nginx = { "nginxfmt" },
				php = { "php_cs_fixer" },
				python = { "ruff_organize_imports", "ruff_format" },
				rust = { "rustfmt" },
				scss = { "prettierd" },
				sh = { "shfmt" },
				terraform = { "terraform_fmt" },
				typescript = { "prettierd" },
				yaml = { "prettierd" },
				["_"] = { "trim_whitespace" },
			},
		},
	},
}
