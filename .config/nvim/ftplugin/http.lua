vim.api.nvim_set_keymap(
	"n",
	"<leader>k",
	":lua require('kulala').jump_prev()<CR>",
	{ noremap = true, silent = true, desc = "Go to previous" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>j",
	":lua require('kulala').jump_next()<CR>",
	{ noremap = true, silent = true, desc = "Go to next" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>l",
	":lua require('kulala').run()<CR>",
	{ noremap = true, silent = true, desc = "Run current" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>a",
	":lua require('kulala').run_all()<CR>",
	{ noremap = true, silent = true, desc = "Run all" }
)
