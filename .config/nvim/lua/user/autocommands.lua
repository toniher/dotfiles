vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
	callback = function(args)
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true })
		vim.bo[args.buf].buflisted = false
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
	callback = function()
		vim.cmd("quit")
	end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.java" },
	callback = function(args)
		vim.lsp.codelens.refresh({ bufnr = args.buf })
	end,
})

local function link_illuminated()
	vim.cmd("hi! link illuminatedWord LspReferenceText")
end
vim.api.nvim_create_autocmd({ "ColorScheme" }, { callback = link_illuminated })
link_illuminated()

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	callback = function()
		local line_count = vim.api.nvim_buf_line_count(0)
		if line_count >= 5000 then
			vim.cmd("IlluminatePauseBuf")
		end
	end,
})

-- Added autocmds
-- Avoiding autocomplete in csv and tsv files
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "text", "txt", "csv", "tsv" },
	callback = function()
		vim.opt_local.expandtab = false
		vim.b.completion = false
	end,
})

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], opts)
	-- vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	callback = function()
		set_terminal_keymaps()
	end,
})
