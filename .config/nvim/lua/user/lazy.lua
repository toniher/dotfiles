local fn = vim.fn

local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
	return
end
-- Load lazy.nvim
lazy.setup({
	spec = {
		{ import = "user.plugins.plugins" },
		{ import = "user.plugins.git", enabled = true },
		{ import = "user.plugins.coding", enabled = true },
		{ import = "user.plugins.blink", enabled = true },
		{ import = "user.plugins.ai", enabled = true },
		{ import = "user.plugins.session", enabled = true },
		{ import = "user.plugins.conform", enabled = true },
		{ import = "user.plugins.treesitter", enabled = enable_treesitter },
		{ import = "user.plugins.ui", enabled = true },
	},
})
