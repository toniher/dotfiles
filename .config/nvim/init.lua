if vim.loader then
	vim.loader.enable()
end
require("user.options")
require("user.keymaps")
require("user.lazy")

local colorscheme = "tokyonight-night"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end

require("user.autocommands")
require("user.lsp")
require("user.dap")

-- Other vim stuff
-- vim.notify = require("notify")

-- Adding http filetype
vim.filetype.add({
	extension = {
		["http"] = "http",
	},
})
