return {
	{
		"HakonHarnes/img-clip.nvim",
		opts = {
			filetypes = {
				codecompanion = {
					prompt_for_file_name = false,
					template = "[Image]($FILE_PATH)",
					use_absolute_path = true,
				},
			},
		},
	},
	{
		"saxon1964/neovim-tips",
		version = "*", -- Only update on tagged releases
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				config = function()
					require("render-markdown").setup({
						completions = { blink = { enabled = true } },
					})
				end,
			},
		},
		opts = {
			-- OPTIONAL: Location of user defined tips (default value shown below)
			user_file = vim.fn.stdpath("config") .. "/neovim_tips/user_tips.md",
			-- OPTIONAL: Prefix for user tips to avoid conflicts (default: "[User] ")
			user_tip_prefix = "[User] ",
			-- OPTIONAL: Show warnings when user tips conflict with builtin (default: true)
			warn_on_conflicts = true,
			-- OPTIONAL: Daily tip mode (default: 1)
			-- 0 = off, 1 = once per day, 2 = every startup
			daily_tip = 1,
		},
		init = function()
			-- OPTIONAL: Change to your liking or drop completely
			-- The plugin does not provide default key mappings, only commands
			local map = vim.keymap.set
			map("n", "<leader>nto", ":NeovimTips<CR>", { desc = "Neovim tips", noremap = true, silent = true })
			map(
				"n",
				"<leader>nte",
				":NeovimTipsEdit<CR>",
				{ desc = "Edit your Neovim tips", noremap = true, silent = true }
			)
			map(
				"n",
				"<leader>nta",
				":NeovimTipsAdd<CR>",
				{ desc = "Add your Neovim tip", noremap = true, silent = true }
			)
			map(
				"n",
				"<leader>ntr",
				":NeovimTipsRandom<CR>",
				{ desc = "Show random tip", noremap = true, silent = true }
			)
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		event = "VeryLazy",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<c-\>]],
				hide_numbers = true,
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "horizontal",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
				},
			})
		end,
	},
	{
		"willothy/flatten.nvim",
		-- config = true,
		opts = function()
			---@type Terminal?
			local saved_terminal

			return {
				window = {
					open = "alternate",
				},
				hooks = {
					should_block = function(argv)
						-- Note that argv contains all the parts of the CLI command, including
						-- Neovim's path, commands, options and files.
						-- See: :help v:argv

						-- In this case, we would block if we find the `-b` flag
						-- This allows you to use `nvim -b file1` instead of
						-- `nvim --cmd 'let g:flatten_wait=1' file1`
						return vim.tbl_contains(argv, "-b")

						-- Alternatively, we can block if we find the diff-mode option
						-- return vim.tbl_contains(argv, "-d")
					end,
					pre_open = function()
						local term = require("toggleterm.terminal")
						local termid = term.get_focused_id()
						saved_terminal = term.get(termid)
					end,
					post_open = function(bufnr, winnr, ft, is_blocking)
						if is_blocking and saved_terminal then
							-- Hide the terminal while it's blocking
							saved_terminal:close()
						else
							-- If it's a normal file, just switch to its window
							if not winnr then
								winnr = vim.api.nvim_get_current_win()
								-- vim.notify(winnr, vim.log.levels.INFO)
							end
							vim.api.nvim_set_current_win(winnr)

							-- If we're in a different wezterm pane/tab, switch to the current one
							-- Requires willothy/wezterm.nvim
							-- require("wezterm").switch_pane.id(tonumber(os.getenv("WEZTERM_PANE")))
						end

						-- If the file is a git commit, create one-shot autocmd to delete its buffer on write
						-- If you just want the toggleable terminal integration, ignore this bit
						if ft == "gitcommit" or ft == "gitrebase" then
							vim.api.nvim_create_autocmd("BufWritePost", {
								buffer = bufnr,
								once = true,
								callback = vim.schedule_wrap(function()
									vim.api.nvim_buf_delete(bufnr, {})
								end),
							})
						end
					end,
					block_end = function()
						-- After blocking ends (for a git commit, etc), reopen the terminal
						vim.schedule(function()
							if saved_terminal then
								saved_terminal:open()
								saved_terminal = nil
							end
						end)
					end,
				},
			}
		end,
		-- opts = {  }
		-- Ensure that it runs first to minimize delay when opening file from terminal
		lazy = false,
		priority = 1001,
	},
	{
		"DrKJeff16/project.nvim",
		config = function()
			require("project").setup({
				detection_methods = { "lsp", "pattern" },
				exclude_dirs = { "~/.config/*" },
				-- patterns used to detect root dir, when **"pattern"** is in detection_methods
				patterns = { ".git", "Makefile", "package.json" },
			})
		end,
	},
	-- Color plugins
	"folke/tokyonight.nvim",
	-- LSP plugins
	{
		"neovim/nvim-lspconfig",
		tag = "v2.4.0",
		event = { "BufReadPre", "BufNewFile" },
	},
	{ "williamboman/mason.nvim", tag = "v2.0.1" },
	{ "williamboman/mason-lspconfig.nvim", tag = "v2.1.0" },
	{ "hinell/lsp-timeout.nvim" },
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		config = function()
			require("fidget").setup()
		end,
	},
	-- DAP
	{
		"mfussenegger/nvim-dap",
		event = { "BufReadPre", "BufNewFile" },
		tag = "0.9.0",
		dependencies = {
			{ "rcarriga/nvim-dap-ui", tag = "v4.0.0" },
			{ "nvim-neotest/nvim-nio", tag = "v1.10.1" },
			{ "jay-babu/mason-nvim-dap.nvim", tag = "v2.5.1" },
		},
	},
	-- More stuff
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
					"treesitter",
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
	-- trouble messages
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
	},
	"Mxrcon/nextflow-vim",
	{
		"mechatroner/rainbow_csv",
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = {
			"echasnovski/mini.icons",
		},
		config = function()
			require("which-key").setup()
		end,
	},
	{
		"mistweaverco/kulala.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			-- Setup is required, even if you don't pass any options
			require("kulala").setup()
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			-- {
			-- 	"rcarriga/nvim-notify",
			-- 	config = function()
			-- 		require("notify").setup({
			-- 			stages = "fade_in_slide_out",
			-- 			background_colour = "FloatShadow",
			-- 			timeout = 3000,
			-- 		})
			-- 	end,
			-- },
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
	},
	{
		"fedepujol/move.nvim",
		event = "VeryLazy",
		config = function()
			require("move").setup()
		end,
	},
	{ "lambdalisue/suda.vim", event = "VeryLazy" },
	{
		"chentoast/marks.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("marks").setup({
				-- whether to map keybinds or not. default true
				default_mappings = true,
				-- which builtin marks to show. default {}
				builtin_marks = { ".", "<", ">", "^" },
				-- whether movements cycle back to the beginning/end of buffer. default true
				cyclic = true,
				-- whether the shada file is updated after modifying uppercase marks. default false
				force_write_shada = false,
				-- how often (in ms) to redraw signs/recompute mark positions.
				-- higher values will have better performance but may cause visual lag,
				-- while lower values may cause performance penalties. default 150.
				refresh_interval = 250,
				-- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
				-- marks, and bookmarks.
				-- can be either a table with all/none of the keys, or a single number, in which case
				-- the priority applies to all marks.
				-- default 10.
				sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
				-- disables mark tracking for specific filetypes. default {}
				excluded_filetypes = {},
				-- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
				-- sign/virttext. Bookmarks can be used to group together positions and quickly move
				-- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
				-- default virt_text is "".
				bookmark_0 = {
					sign = "⚑",
					virt_text = "hello world",
					-- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
					-- defaults to false.
					annotate = false,
				},
				mappings = {},
			})
		end,
	},
	-- {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- 	build = "cd app && npm install",
	-- 	init = function()
	-- 		vim.g.mkdp_filetypes = { "markdown" }
	-- 	end,
	-- 	ft = { "markdown" },
	-- },
	{
		"ravibrock/spellwarn.nvim",
		event = "VeryLazy",
		config = true,
	},
	{
		"rcarriga/nvim-notify",
		lazy = false,
		config = true,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = { enabled = true },
			bufdelete = { enabled = true },
			dashboard = {
				enabled = true,
				sections = {
					{ section = "header" },
					{
						section = "keys",
						gap = 1,
						padding = 2,
						{
							icon = " ",
							key = "s",
							desc = "Sessions",
							action = ":AutoSession search",
						},
						{
							icon = " ",
							key = "z",
							desc = "Zoxide",
							action = "<leader>fz",
						},
					},
					{
						pane = 2,
						icon = " ",
						title = "Recent Files",
						section = "recent_files",
						indent = 2,
						padding = 1,
					},
					{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{
						pane = 2,
						icon = " ",
						title = "Git Status",
						section = "terminal",
						enabled = function()
							return Snacks.git.get_root() ~= nil
						end,
						cmd = "git status --short --branch --renames",
						height = 5,
						padding = 1,
						ttl = 5 * 60,
						indent = 3,
					},
					{ section = "startup" },
				},
			},
			dim = { enabled = true },
			git = { enabled = true },
			gitbrowse = { enabled = true },
			input = { enabled = true },
			lazygit = { enabled = true },
			-- notify = { enabled = true },
			picker = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			statuscolumn = { enabled = true },
			win = { enabled = true },
			words = { enabled = true },
			zen = {
				enabled = true,
				toggles = {
					-- ufo = true,
					dim = true,
					git_signs = false,
					diagnostics = false,
					line_number = false,
					indent = false,
					signcolumn = "no",
				},
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Create some toggle mappings
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>uc")
					Snacks.toggle.treesitter():map("<leader>uT")
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<leader>ub")
					Snacks.toggle.inlay_hints():map("<leader>uh")
					Snacks.toggle.indent():map("<leader>ug")
					Snacks.toggle.dim():map("<leader>uD")
				end,
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
