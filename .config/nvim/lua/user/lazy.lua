local fn = vim.fn

local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local util = require("user.util")

local machine = util.machine
local enable_treesitter = true

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	vim.notify("lazy.nvim failed to load: " .. tostring(lazy), vim.log.levels.ERROR)
	return
end
-- Load lazy.nvim
lazy.setup({
	spec = {
		{ import = "user.plugins.ai", enabled = true },
		{ import = "user.plugins.blink", enabled = true },
		{ import = "user.plugins.coding", enabled = true },
		{ import = "user.plugins.conform", enabled = true },
		{ import = "user.plugins.dap", enabled = true },
		{ import = "user.plugins.editing", enabled = true },
		{ import = "user.plugins.filetypes", enabled = true },
		{ import = "user.plugins.git", enabled = true },
		{ import = "user.plugins.lsp", enabled = true },
		{ import = "user.plugins.picker", enabled = true },
		{ import = "user.plugins.session", enabled = true },
		{ import = "user.plugins.snacks", enabled = true },
		{ import = "user.plugins.terminal", enabled = true },
		{ import = "user.plugins.translate", enabled = true },
		{ import = "user.plugins.treesitter", enabled = enable_treesitter },
		{ import = "user.plugins.ui", enabled = true },
	},
})
