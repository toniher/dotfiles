-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }
local opts_move = { noremap = true, silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- New buffer
keymap("n", "<leader>na", "<cmd>tabnew<CR>", opts)
keymap("n", "<leader>nh", "<cmd>enew<CR>", opts)
keymap("n", "<leader>nb", "<cmd>new<CR>", opts)

-- Split
keymap("n", "<leader>sh", "<Cmd>split<CR>", opts)
keymap("n", "<leader>sv", "<Cmd>vsplit<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
-- Close buffers
-- keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)
keymap("n", "<S-q>", "<cmd>lua require('snacks').bufdelete()<CR>", { silent = true, desc = "Delete Buffer" })

-- buffer Move
keymap("n", "<leader>mh", ":BufferLineMovePrev<CR>", opts)
keymap("n", "<leader>ml", ":BufferLineMoveNext<CR>", opts)

-- Tabs
keymap("n", "<leader>bl", ":+tabnext<CR>", opts)
keymap("n", "<leader>bh", ":-tabnext<CR>", opts)
-- Close tab
keymap("n", "<leader>bq", "<cmd>tabclose!<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Plugins --

-- NvimTree
-- keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Snacks
keymap("n", "<leader>fb", "<cmd>lua require('snacks').picker.buffers()<CR>", opts)
keymap("n", "<leader>fd", "<cmd>lua require('snacks').picker.lsp_definitions()<CR>", opts)
keymap("n", "<leader>fg", "<cmd>lua require('snacks').picker.grep()<CR>", opts)
keymap(
	"n",
	"<leader>ff",
	"<cmd>lua require('snacks').picker.files({ hidden = true })<CR>",
	{ silent = true, desc = "Find files" }
)
keymap("n", "<leader>fj", "<cmd>lua require('snacks').picker.jumps()<CR>", opts)
keymap("n", "<leader>fl", "<cmd>lua require('snacks').picker.lsp_references()<CR>", opts)
keymap("n", "<leader>fm", "<cmd>lua require('snacks').picker.marks()<CR>", { silent = true, desc = "Find marks" })
keymap("n", "<leader>fp", "<cmd>lua require('snacks').picker.projects()<CR>", opts)
keymap("n", "<leader>fr", "<cmd>lua require('snacks').picker.recent()<CR>", opts)
keymap("n", "<leader>fs", ":AutoSession search<CR>", { noremap = true, desc = "Find session" })
keymap("n", "<leader>ft", "<cmd>lua require('snacks').picker.todo_comments()<CR>", opts)
keymap("n", "<leader>fz", "<cmd>lua require('snacks').picker.zoxide()<CR>", opts)

-- Session specific
keymap("n", "<leader>wd", "<cmd>SessionDelete<CR>", { noremap = true, desc = "Session delete" })
keymap("n", "<leader>wr", "<cmd>SessionSearch<CR>", { noremap = true, desc = "Session search" })
keymap("n", "<leader>ws", "<cmd>SessionSave<CR>", { noremap = true, desc = "Save session" })
keymap("n", "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", { noremap = true, desc = "Toggle autosave" })

-- Reload buffer
keymap("n", "<leader>r", ":bufdo :e<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- DAP
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)

-- Git
keymap("n", "<leader>gb", "<cmd>G blame<CR>", opts)
keymap("n", "<leader>gB", "<cmd>lua require('snacks').gitbrowse()<CR>", opts)
keymap("n", "<leader>gd", "<cmd>G diff<CR>", opts)
keymap("n", "<leader>gi", "<cmd>G<CR>", opts)
keymap("n", "<leader>gf", "<cmd>lua require('snacks').lazygit.log_file()<CR>", opts)
keymap("n", "<leader>gg", "<cmd>lua require('snacks').lazygit()<CR>", opts)
keymap("n", "<leader>gl", "<cmd>lua require('snacks').lazygit.log()<CR>", opts)
keymap("n", "<leader>gm", "<cmd>lua require('snacks').git.blame_line()<CR>", opts)
keymap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", opts)

-- Toggleterm
keymap("n", "<leader>tf", "<cmd>TermNew direction=float<CR>", opts)
keymap("n", "<leader>tg", "<cmd>ToggleTerm<CR>", opts)
keymap("n", "<leader>th", "<cmd>TermNew direction=horizontal size=20<CR>", opts)
keymap("n", "<leader>ts", "<cmd>TermSelect<CR>", opts)
keymap("n", "<leader>tt", "<cmd>TermNew direction=tab<CR>", opts)
keymap("n", "<leader>tv", "<cmd>TermNew direction=vertical size=75<CR>", opts)
keymap("n", "<leader>tx", "<cmd>lua require('snacks').terminal()<CR>", opts)

-- Toc of todos and fixmes
keymap("n", "<leader>to", "<cmd>TodoLocList<CR>", opts)
keymap("n", "<leader>tl", "<cmd>TodoFzfLua<CR>", opts)

-- Symbol Outine
keymap("n", "<leader>so", "<cmd>Outline<CR>", opts)

-- Markdown Preview
keymap("n", "<leader>mv", "<cmd>RenderMarkdown buf_toggle<CR>", opts)

-- CodeCompanion Chat
keymap("n", "<leader>ca", "<cmd>CodeCompanionActions<CR>", opts)
keymap("v", "<leader>ca", "<cmd>CodeCompanionActions<CR>", opts)
keymap("n", "<leader>cc", "<cmd>CodeCompanionChat<CR>", opts)
keymap("v", "<leader>cc", "<cmd>CodeCompanionChat<CR>", opts)
keymap("n", "<leader>ch", "<cmd>CodeCompanionHistory<CR>", opts)
keymap("n", "<leader>ct", "<cmd>CodeCompanionChat Toggle<CR>", opts)

-- MCPHub
keymap("n", "<leader>mc", "<cmd>MCPHub<CR>", opts)

-- TroubleToggle
keymap("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", opts_move)
keymap("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", opts_move)
keymap("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", opts_move)
keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", opts_move)

-- Normal-mode commands
keymap("n", "<A-K>", ":MoveLine(1)<CR>", opts_move)
keymap("n", "<A-J>", ":MoveLine(-1)<CR>", opts_move)
keymap("n", "<A-H>", ":MoveWord(-1)<CR>", opts_move)
keymap("n", "<A-L>", ":MoveWord(1)<CR>", opts_move)

-- Visual-mode commands
keymap("v", "<A-K>", ":MoveBlock(1)<CR>", opts)
keymap("v", "<A-J>", ":MoveBlock(-1)<CR>", opts)
keymap("v", "<A-H>", ":MoveHBlock(-1)<CR>", opts)
keymap("v", "<A-L>", ":MoveHBlock(1)<CR>", opts)

-- Paths
keymap("n", "<leader>cw", "<cmd>lua print(vim.loop.cwd())<cr>", opts_move)
keymap("n", "<leader>pw", "<cmd>echo expand('%:p')<cr>", opts_move)

--- Suda
-- keymap("n", "<leader>sr", "<cmd>SudaRead<cr>", opts)
keymap("n", "<leader>sw", "<cmd>SudaWrite<cr>", opts)

-- Spellcheck
keymap("n", "<leader>sp0", "<cmd>setlocal nospell<cr>", opts)
keymap("n", "<leader>sp1", "<cmd>setlocal spell<cr>", opts)
keymap("n", "<leader>spa", "<cmd>setlocal spelllang=ca<cr>", opts)
keymap("n", "<leader>spn", "<cmd>setlocal spelllang=en<cr>", opts)
keymap("n", "<leader>sps", "<cmd>setlocal spelllang=es<cr>", opts)

-- Toggle autocomplete
-- keymap('n', '<leader>au', "<cmd>ToggleAutoComplete<cr>", opts)

keymap(
	"n",
	"<leader>no",
	"<cmd>lua require('snacks').notifier.show_history()<CR>",
	{ silent = true, desc = "Notification History" }
)
keymap("n", "<leader>z", "<cmd>lua require('snacks').zen()<CR>", { silent = true, desc = "Toggle Zen Mode" })
keymap("n", "<leader>Z", "<cmd>lua require('snacks').zen.zoom()<CR>", { silent = true, desc = "Toggle Zoom" })

-- LSP
keymap("n", "<leader>l0", "<cmd>LspStop<cr>", opts_move)
keymap("n", "<leader>l1", "<cmd>LspStart<cr>", opts_move)
keymap("n", "<leader>li", "<cmd>LspInfo<cr>", opts_move)
