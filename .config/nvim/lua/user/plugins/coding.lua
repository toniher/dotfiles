return {
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			"mfussenegger/nvim-dap-python", --optional
		},
		branch = "main",
		cmd = "VenvSelect",
		keys = {
			{ ",v", "<cmd>VenvSelect<cr>" },
		},
		opts = {
			-- Your settings go here
		},
	},
	{
		"jeangiraldoo/codedocs.nvim",
	},
	{
		"nvim-java/nvim-java",
		version = "4.1.2", -- optionally pin to a tag
		ft = "java",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("java").setup({})

			local handlers = require("user.lsp.handlers")
			local opts = {
				on_attach = handlers.on_attach,
				capabilities = handlers.capabilities,
			}
			local ok, conf_opts = pcall(require, "user.lsp.settings.jdtls")
			if ok then
				opts = vim.tbl_deep_extend("force", conf_opts, opts)
			end
			vim.lsp.config("jdtls", opts)
			vim.lsp.enable("jdtls")
		end,
	},
	{
		"esmuellert/codediff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = "CodeDiff",
	},
	{
		"nvim-mini/mini.comment",
		version = "*",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("mini.comment").setup({
				options = {
					ignore_blank_line = true,
					custom_commentstring = function()
						return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
					end,
				},
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		opts = {},
		dependencies = "nvim-lua/plenary.nvim",
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {
			check_ts = true, -- treesitter integration
			disable_filetype = { "TelescopePrompt" },
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},

			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0, -- Offset from pattern match
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		},
	},
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
				require("luasnip.loaders.from_snipmate").lazy_load()
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},
	{
		"kylechui/nvim-surround",
		version = "^3.1.8", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = {},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
	},
	{
		"allaman/emoji.nvim",
		version = "6.1.0", -- optionally pin to a tag
		ft = "markdown", -- adjust to your needs
		dependencies = {
			-- optional for nvim-cmp integration
			"hrsh7th/nvim-cmp",
			-- optional for telescope integration
			-- "nvim-telescope/telescope.nvim",
		},
		event = { "VeryLazy", "InsertEnter" },
		opts = {
			-- default is false
			enable_cmp_integration = true,
		},
	},
}
