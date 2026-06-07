vim.keymap.set("n", "<leader>k", function() require("kulala").jump_prev() end,
	{ buffer = 0, noremap = true, silent = true, desc = "Go to previous" })
vim.keymap.set("n", "<leader>j", function() require("kulala").jump_next() end,
	{ buffer = 0, noremap = true, silent = true, desc = "Go to next" })
vim.keymap.set("n", "<leader>l", function() require("kulala").run() end,
	{ buffer = 0, noremap = true, silent = true, desc = "Run current" })
vim.keymap.set("n", "<leader>a", function() require("kulala").run_all() end,
	{ buffer = 0, noremap = true, silent = true, desc = "Run all" })
