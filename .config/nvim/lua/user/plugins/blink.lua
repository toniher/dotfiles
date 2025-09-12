local function assign_icon(items, icon)
	for _, item in ipairs(items) do
		item.labelDetails = {
			description = icon,
		}
	end
	return items
end

return {
	{
		"saghen/blink.cmp",
		lazy = false, -- lazy loading handled internally
		version = "*",
		dependencies = {
			{
				"saghen/blink.compat",
				opts = { impersonate_nvim_cmp = true, enable_events = true },
			},
			"mikavilpas/blink-ripgrep.nvim",
			"giuxtaposition/blink-cmp-copilot",
			"Kaiser-Yang/blink-cmp-git",
			"onsails/lspkind.nvim",
		},

		-- use a release tag to download pre-built binaries
		-- version = 'v0.*',
		-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		build = "cargo build --release",
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- see the "default configuration" section below for full documentation on how to define
			-- your own keymap.
			keymap = {
				preset = "super-tab",
				["<S-k>"] = { "scroll_documentation_up", "fallback" },
				["<S-j>"] = { "scroll_documentation_down", "fallback" },
			},

			snippets = {
				preset = "luasnip",
				expand = function(snippet)
					require("luasnip").lsp_expand(snippet)
				end,
				active = function(filter)
					if filter and filter.direction then
						return require("luasnip").jumpable(filter.direction)
					end
					return require("luasnip").in_snippet()
				end,
				jump = function(direction)
					require("luasnip").jump(direction)
				end,
			},
			sources = {
				default = {
					"git",
					"lsp",
					"path",
					"ripgrep",
					"snippets",
					"buffer",
					"emoji",
					-- "codecompanion",
					"codeium",
					"copilot",
				},
				providers = {
					git = {
						module = "blink-cmp-git",
						name = "Git",
						opts = {
							-- options for the blink-cmp-git
						},
						transform_items = function(_, items)
							return assign_icon(items, "󰊢")
						end,
					},
					buffer = {
						transform_items = function(_, items)
							return assign_icon(items, "󰓩")
						end,
					},
					snippets = {
						transform_items = function(_, items)
							return assign_icon(items, "󱓖")
						end,
					},
					codecompanion = {
						name = "CodeCompanion",
						module = "codecompanion.providers.completion.blink",
					},
					codeium = {
						name = "codeium",
						module = "blink.compat.source",
						score_offset = 3,
						transform_items = function(_, items)
							return assign_icon(items, "󰙨")
						end,
					},
					emoji = {
						name = "emoji",
						module = "blink.compat.source",
						-- overwrite kind of suggestion
						transform_items = function(ctx, items)
							local kind = require("blink.cmp.types").CompletionItemKind.Text
							for i = 1, #items do
								items[i].kind = kind
							end
							return items
						end,
					},
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
						transform_items = function(_, items)
							return assign_icon(items, "")
						end,
					},
					ripgrep = {
						module = "blink-ripgrep",
						name = "Ripgrep",
						-- the options below are optional, some default values are shown
						---@module "blink-ripgrep"
						---@type blink-ripgrep.Options
						opts = {
							-- the minimum length of the current word to start searching
							-- (if the word is shorter than this, the search will not start)
							prefix_min_len = 3,

							-- Specifies how to find the root of the project where the ripgrep
							-- search will start from. Accepts the same options as the marker
							-- given to `:h vim.fs.root()` which offers many possibilities for
							-- configuration. If none can be found, defaults to Neovim's cwd.
							--
							-- Examples:
							-- - ".git" (default)
							-- - { ".git", "package.json", ".root" }
							project_root_marker = ".git",

							-- When a result is found for a file whose filetype does not have a
							-- treesitter parser installed, fall back to regex based highlighting
							-- that is bundled in Neovim.
							fallback_to_regex_highlighting = true,

							-- Keymaps to toggle features on/off. This can be used to alter
							-- the behavior of the plugin without restarting Neovim. Nothing
							-- is enabled by default. Requires folke/snacks.nvim.
							toggles = {
								-- The keymap to toggle the plugin on and off from blink
								-- completion results. Example: "<leader>tg" ("toggle grep")
								on_off = nil,

								-- The keymap to toggle debug mode on/off. Example: "<leader>td" ("toggle debug")
								debug = nil,
							},

							backend = {
								-- The backend to use for searching. Defaults to "ripgrep".
								-- Available options:
								-- - "ripgrep", always use ripgrep
								-- - "gitgrep", always use git grep
								-- - "gitgrep-or-ripgrep", use git grep if possible, otherwise
								--   use ripgrep
								use = "ripgrep",

								-- Whether to set up custom highlight-groups for the icons used
								-- in the completion items. Defaults to `true`, which means this
								-- is enabled.
								customize_icon_highlight = true,

								ripgrep = {
									-- For many options, see `rg --help` for an exact description of
									-- the values that ripgrep expects.

									-- The number of lines to show around each match in the preview
									-- (documentation) window. For example, 5 means to show 5 lines
									-- before, then the match, and another 5 lines after the match.
									context_size = 5,

									-- The maximum file size of a file that ripgrep should include
									-- in its search. Useful when your project contains large files
									-- that might cause performance issues.
									-- Examples:
									-- "1024" (bytes by default), "200K", "1M", "1G", which will
									-- exclude files larger than that size.
									max_filesize = "1M",

									-- Enable fallback to neovim cwd if project_root_marker is not
									-- found. Default: `true`, which means to use the cwd.
									project_root_fallback = true,

									-- The casing to use for the search in a format that ripgrep
									-- accepts. Defaults to "--ignore-case". See `rg --help` for
									-- all the available options ripgrep supports, but you can try
									-- "--case-sensitive" or "--smart-case".
									search_casing = "--ignore-case",

									-- (advanced) Any additional options you want to give to
									-- ripgrep. See `rg -h` for a list of all available options.
									-- Might be helpful in adjusting performance in specific
									-- situations. If you have an idea for a default, please open
									-- an issue!
									--
									-- Not everything will work (obviously).
									additional_rg_options = {},

									-- Absolute root paths where the rg command will not be
									-- executed. Usually you want to exclude paths using gitignore
									-- files or ripgrep specific ignore files, but this can be used
									-- to only ignore the paths in blink-ripgrep.nvim, maintaining
									-- the ability to use ripgrep for those paths on the command
									-- line. If you need to find out where the searches are
									-- executed, enable `debug` and look at `:messages`.
									ignore_paths = {},

									-- Any additional paths to search in, in addition to the
									-- project root. This can be useful if you want to include
									-- dictionary files (/usr/share/dict/words), framework
									-- documentation, or any other reference material that is not
									-- available within the project root.
									additional_paths = {},
								},
							},

							-- Show debug information in `:messages` that can help in
							-- diagnosing issues with the plugin.
							debug = false,
						},
						-- (optional) customize how the results are displayed. Many options
						-- are available - make sure your lua LSP is set up so you get
						-- autocompletion help
						transform_items = function(_, items)
							return assign_icon(items, "")
						end,
					},
				},
			},
			completion = {
				trigger = {
					-- When true, will show the completion window after typing a trigger character
					show_on_trigger_character = true,
					-- When both this and show_on_trigger_character are true, will show the completion window
					-- when the cursor comes after a trigger character when entering insert mode
					show_on_insert_on_trigger_character = true,
					-- List of trigger characters (on top of `show_on_blocked_trigger_characters`) that won't trigger
					-- the completion window when the cursor comes after a trigger character when
					-- entering insert mode/accepting an item
					show_on_x_blocked_trigger_characters = { "'", '"', "(", "{" },
					-- or a function, similar to show_on_blocked_trigger_character
				},
				-- https://cmp.saghen.dev/recipes.html#nvim-web-devicons-lspkind
				menu = {
					draw = {
						components = {
							kind_icon = {
								text = function(ctx)
									local lspkind = require("lspkind")
									local icon = ctx.kind_icon
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											icon = dev_icon
										end
									else
										icon = require("lspkind").symbolic(ctx.kind, {
											mode = "symbol",
										})
									end

									return icon .. ctx.icon_gap
								end,

								-- Optionally, use the highlight groups from nvim-web-devicons
								-- You can also add the same function for `kind.highlight` if you want to
								-- keep the highlight groups in sync with the icons.
								highlight = function(ctx)
									local hl = ctx.kind_hl
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											hl = dev_hl
										end
									end
									return hl
								end,
							},
						},
					},
				},

				-- experimental auto-brackets support
				accept = {
					auto_brackets = { enabled = false },
				},

				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
					treesitter_highlighting = true,
					window = {
						border = "rounded",
					},
				},

				ghost_text = {
					enabled = true,
				},
			},

			signature = {
				enabled = true,
				window = {
					border = "rounded",
				},
			},
		},
		-- allows extending the enabled_providers array elsewhere in your config
		-- without having to redefine it
		opts_extend = { "sources.default" },
	},

	-- LSP servers and clients communicate what features they support through "capabilities".
	--  By default, Neovim support a subset of the LSP specification.
	--  With blink.cmp, Neovim has *more* capabilities which are communicated to the LSP servers.
	--  Explanation from TJ: https://youtu.be/m8C0Cq9Uv9o?t=1275
	--
	-- This can vary by config, but in general for nvim-lspconfig:
}
