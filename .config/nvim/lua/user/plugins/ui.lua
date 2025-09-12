local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

-- set up for symbol usage icons
local function h(name)
	return vim.api.nvim_get_hl(0, { name = name })
end

-- hl-groups can have any name
vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })

local function text_format(symbol)
	local res = {}

	local round_start = { "", "SymbolUsageRounding" }
	local round_end = { "", "SymbolUsageRounding" }

	-- Indicator that shows if there are any other symbols in the same line
	local stacked_functions_content = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count) or ""

	if symbol.references then
		local usage = symbol.references <= 1 and "usage" or "usages"
		local num = symbol.references == 0 and "no" or symbol.references
		table.insert(res, round_start)
		table.insert(res, { "󰌹 ", "SymbolUsageRef" })
		table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
		table.insert(res, round_end)
	end

	if symbol.definition then
		if #res > 0 then
			table.insert(res, { " ", "NonText" })
		end
		table.insert(res, round_start)
		table.insert(res, { "󰳽 ", "SymbolUsageDef" })
		table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
		table.insert(res, round_end)
	end

	if symbol.implementation then
		if #res > 0 then
			table.insert(res, { " ", "NonText" })
		end
		table.insert(res, round_start)
		table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
		table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
		table.insert(res, round_end)
	end

	if stacked_functions_content ~= "" then
		if #res > 0 then
			table.insert(res, { " ", "NonText" })
		end
		table.insert(res, round_start)
		table.insert(res, { " ", "SymbolUsageImpl" })
		table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
		table.insert(res, round_end)
	end

	return res
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
	cond = hide_in_width,
}

local filetype = {
	"filetype",
	icons_enabled = false,
}

local location = {
	"location",
	padding = 0,
}

local lint_progress = function()
	local linters = require("lint").get_running()
	if #linters == 0 then
		return "󰦕"
	end
	return "󱉶 " .. table.concat(linters, ", ")
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

return {
	{
		"amrbashir/nvim-docs-view",
		event = "LspAttach",
		cmd = "DocsViewToggle",
		opts = {
			position = "right",
			width = 100,
		},
	},
	{
		"hedyhli/outline.nvim",
		event = "VeryLazy",
		cmd = { "Outline", "OutlineOpen" },
		config = function()
			require("outline").setup({})
		end,
	},
	{
		"Wansmer/symbol-usage.nvim",
		event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
		config = function()
			require("symbol-usage").setup({
				text_format = text_format,
			})
		end,
	},
	{
		"mikavilpas/yazi.nvim",
		event = "VeryLazy",
		keys = {
			-- 👇 in this section, choose your own keymappings!
			{
				"<leader>-",
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
			{
				-- Open in the current working directory
				"<leader>cw",
				"<cmd>Yazi cwd<cr>",
				desc = "Open the file manager in nvim's working directory",
			},
			-- {
			-- 	-- NOTE: this requires a version of yazi that includes
			-- 	-- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
			-- 	"<c-up>",
			-- 	"<cmd>Yazi toggle<cr>",
			-- 	desc = "Resume the last yazi session",
			-- },
		},
		---@type YaziConfig
		opts = {
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = true,
			floating_window_scaling_factor = 1.0,
			keymaps = {
				show_help = "<f1>",
			},
		},
	},
	-- {
	-- 	"nvim-tree/nvim-tree.lua",
	-- 	tag = "v1.13.0",
	-- 	dependencies = {
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("nvim-tree").setup({
	-- 			respect_buf_cwd = true,
	-- 			update_focused_file = {
	-- 				enable = true,
	-- 				update_root = true,
	-- 			},
	-- 			sync_root_with_cwd = true,
	-- 			sort_by = "case_sensitive",
	-- 			view = {
	-- 				width = 40,
	-- 			},
	-- 			renderer = {
	-- 				group_empty = true,
	-- 			},
	-- 			filters = {
	-- 				dotfiles = false,
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		config = function()
			require("bufferline").setup({
				options = {
					close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
					right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
					offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
					separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
				},

				highlights = {
					fill = {
						fg = { attribute = "fg", highlight = "TabLine" },
						bg = { attribute = "bg", highlight = "TabLine" },
					},

					background = {
						fg = { attribute = "fg", highlight = "TabLine" },
						bg = { attribute = "bg", highlight = "TabLine" },
					},

					buffer_visible = {
						fg = { attribute = "fg", highlight = "TabLine" },
						bg = { attribute = "bg", highlight = "TabLine" },
					},

					close_button = {
						fg = { attribute = "fg", highlight = "TabLine" },
						bg = { attribute = "bg", highlight = "TabLine" },
					},
					close_button_visible = {
						fg = { attribute = "fg", highlight = "TabLine" },
						bg = { attribute = "bg", highlight = "TabLine" },
					},

					tab_selected = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},

					tab = {
						fg = { attribute = "fg", highlight = "TabLine" },
						bg = { attribute = "bg", highlight = "TabLine" },
					},

					tab_close = {
						-- fg = {attribute='fg',highlight='LspDiagnosticsDefaultError'},
						fg = { attribute = "fg", highlight = "TabLineSel" },
						bg = { attribute = "bg", highlight = "Normal" },
					},

					duplicate_selected = {
						fg = { attribute = "fg", highlight = "TabLineSel" },
						bg = { attribute = "bg", highlight = "TabLineSel" },
						italic = true,
					},

					duplicate_visible = {
						fg = { attribute = "fg", highlight = "TabLine" },
						bg = { attribute = "bg", highlight = "TabLine" },
						italic = true,
					},

					duplicate = {
						fg = { attribute = "fg", highlight = "TabLine" },
						bg = { attribute = "bg", highlight = "TabLine" },
						italic = true,
					},

					modified = {
						fg = { attribute = "fg", highlight = "TabLine" },
						bg = { attribute = "bg", highlight = "TabLine" },
					},

					modified_selected = {
						fg = { attribute = "fg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},

					modified_visible = {
						fg = { attribute = "fg", highlight = "TabLine" },
						bg = { attribute = "bg", highlight = "TabLine" },
					},

					separator = {
						fg = { attribute = "bg", highlight = "TabLine" },
						bg = { attribute = "bg", highlight = "TabLine" },
					},

					separator_selected = {
						fg = { attribute = "bg", highlight = "Normal" },
						bg = { attribute = "bg", highlight = "Normal" },
					},

					indicator_selected = {
						fg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
						bg = { attribute = "bg", highlight = "Normal" },
					},
				},
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					globalstatus = true,
					icons_enabled = true,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { "alpha", "dashboard" },
					always_divide_middle = true,
				},
				theme = "tokyonight",
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = { diagnostics },
					lualine_x = {
						{
							"copilot",
							-- Default values
							symbols = {
								status = {
									icons = {
										enabled = " ",
										sleep = " ", -- auto-trigger disabled
										disabled = " ",
										warning = " ",
										unknown = " ",
									},
									hl = {
										enabled = "#50FA7B",
										sleep = "#AEB7D0",
										disabled = "#6272A4",
										warning = "#FFB86C",
										unknown = "#FF5555",
									},
								},
								spinners = require("copilot-lualine.spinners").dots,
								spinner_color = "#6272A4",
							},
							show_colors = true,
							show_loading = true,
						},

						function()
							return require("auto-session.lib").current_session_name(true)
						end,
						"searchcount",
						diff,
						spaces,
						"encoding",
						filetype,
						{
							"rest",
							icon = "🚽",
							fg = "#428890",
						},
						lint_progress,
					},
					lualine_y = { location },
					lualine_z = { "progress" },
				},
			})
		end,
	},
}
